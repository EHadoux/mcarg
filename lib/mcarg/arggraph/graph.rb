module MCArg
  class Graph
    attr_reader :args, :goal

    def initialize(args, goal)
      @args         = args
      @goal         = goal.map { |g| @args[g] }
    end

    def build_executions(current, list, filters)
      args = Array.new(@args.keys)
      filters.each do |filt|
        args = MCArg.method(filt).(current, args, self)
      end
      return list + [current] if args.empty?
      args.each do |arg|
        list = build_executions(current + [arg], list, filters)
      end
      list
    end

    def build_tree(**fcts)
      executions = build_executions([], [], fcts[:filters])
      root = Node.new(fcts[:dec_fct])
      tree = Tree.new(root)

      executions.each do |ex|
        current = root
        ex[0...-1].each_with_index do |arg, it|
          current = current.add_child Node.new((it.even? ? fcts[:chn_fct] : fcts[:dec_fct]), arg)
        end
        current.add_child LeafNode.new(MCArg.method(fcts[:agg_fct]).(MCArg.method(fcts[:eval_fct]).(@goal, ex)), ex[-1])
      end
      tree
    end

    def self.build_from_apx(filename)
      args, goal = APXParser.parse(filename)
      Graph.new(args, goal)
    end
  end
end
