module MCArg
  class Graph
    attr_reader :args, :goal

    def initialize(args, goal)
      @args = args
      @goal = goal.map { |g| @args[g] }
    end

    def build_executions(current, list, filters, horizon)
      return list if horizon < 0
      args = Array.new(@args.keys)
      filters.each do |filt|
        args = MCArg.method(filt).(current, args, self)
      end
      return list + [current] if args.empty?
      args.each do |arg|
        list = build_executions(current + [arg], list, filters, horizon - 1)
      end
      list
    end

    def build_tree(**fcts)
      executions = build_executions([], [], fcts[:filters], fcts[:horizon])
      root = Node.new(fcts[:dec_fct])
      tree = Tree.new(root)
      powerval = 2 ** @args.size
      basedistribution = [Rational(1, powerval)] * powerval

      executions.each do |ex|
        reset_beliefs
        distribution = basedistribution.clone

        current = root
        ex[0...-1].each_with_index do |arg, it|
          current = current.add_child Node.new((it.even? ? fcts[:chn_fct] : fcts[:dec_fct]), fcts[:alpha], arg)
          distribution = MCArg.method(fcts[:update_fct]).(distribution, @args[arg])
        end
        distribution = MCArg.method(fcts[:update_fct]).(distribution, @args[ex[-1]])
#        leafval = MCArg.method(fcts[:comb_fct]).(MCArg.method(fcts[:eval_fct]).(@goal, ex))
        leafval = MCArg.method(fcts[:eval_fct]).(@goal, ex).values
        leafval = MCArg.method(fcts[:agg_fct]).([leafval[0], @goal[0].belief], fcts[:agg_weights])
        current.add_child LeafNode.new(leafval, ex[-1])
      end
      tree
    end

    def self.build_from_apx(filename)
      args, goal = APXParser.parse(filename)
      Graph.new(args, goal)
    end

    def reset_beliefs
      @args.values.each {|a| a.reset_belief}
    end

    def draw_graph(filename)
      require "graphviz"

      graph = GraphViz.new(:tree, :type => :graph, :rankdir => "LR")
      nodes = {}
      @args.each do |_,a|
        nodes[a.label] = graph.add_node(a.label)
      end

      @args.each do |_,a|
        a.attacked.each do |_,atked|
          graph.add_edge(nodes[a.label], nodes[atked.label])
        end
      end

      graph.output( :png => "#{filename}.png" )
    end
  end
end
