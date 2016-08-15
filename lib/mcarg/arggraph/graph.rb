module MCArg
  class Graph
    attr_reader :args, :goal

    def initialize(args, goal)
      @args = args
      @goal = goal
    end

    def build_executions(current, list, f_hash, horizon)
      return list + [current] if horizon < 0

      args = Array.new(@args.keys)
      f_hash[:func].each do |filt|
        args = filt.(current, args, f_hash[:params])
      end

      return list + [current] if args.empty?

      args.each do |arg|
        list = build_executions(current + [arg], list, f_hash, horizon - 1)
      end
      list
    end

    def build_tree(**params)
      executions = build_executions([], [], params[:filters], params[:horizon])
      root = Node.new(params[:dec], true)
      tree = Tree.new(root)
      powerval = 2 ** @args.size
      #basedistribution = [Rational(1, powerval)] * powerval
      basedistribution = [1.0/powerval] * powerval

      block = Proc.new do |ex|
        reset_beliefs
        distribution = basedistribution.clone

        current = root
        ex[0...-1].each_with_index do |arg, it|
          current = current.add_child Node.new(params[:dec], !current.proponent, arg)
          distribution = params[:belief][:func].(distribution, @args[arg], params[:belief][:params])
        end
        distribution = params[:belief][:func].(distribution, @args[ex[-1]], params[:belief][:params])

        goal_value_pairs  = params[:val][:func].(@goal, ex, params[:val][:params])
        value_belief_comb = goal_value_pairs.map {|g,v| v * g.belief}
        leafval = params[:agg][:func].(value_belief_comb, params[:agg][:params])
        current.add_child LeafNode.new(leafval, ex[-1])
      end

      if params[:quiet]
        executions.each {|ex| block.(ex) }
      else
        Commander::UI::progress(executions) {|ex| block.(ex) }
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
