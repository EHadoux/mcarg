module MCArg
  class Graph
    attr_reader :args, :goal

    LABEL = "[[:alnum:]]+"
    FLOAT = "1(\.0)?|0\.[0-9]+"

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

    def self.build_from_apx(file)
      args = {}
      goal = []
      index = 0
      IO.foreach(file) do |line|
        case line
        when /arg\((#{LABEL})\)\./
          args[$1] = Argument.new($1, index)
          index += 1
        when /att\((#{LABEL}), (#{LABEL})\)\./
          args[$1].add_attacked(args[$2])
        when /prob\((#{LABEL}), (#{FLOAT})\)\./
          args[$1].initial_belief = $2.to_f
        when /goal\((#{LABEL}(,[[:blank:]]*#{LABEL})*)\)\./
          goal = $1.split(",").map(&:strip)
        when /^\s*^/
        else
          puts "Unknown #{line}"
        end
      end

      Graph.new(args, goal)
    end
  end
end
