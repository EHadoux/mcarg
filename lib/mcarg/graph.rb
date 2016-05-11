module MCArg
  def self.no_duplicate(current, args)
    args - current
  end

  class Graph
    attr_reader :nodes, :args, :exec_filters

    def initialize(args, *exec_filters)
      @args = args
      @exec_filters = exec_filters
    end

    def build_tree(dec_fct, chn_fct, eval_fct)
      executions = build_executions([], [])
      root = Node.new(dec_fct)
      tree = Tree.new(root)

      executions.each do |ex|
        current = root
        ex[0...-1].each_with_index do |arg, it|
          current = current.add_child Node.new((it.odd? ? chn_fct : dec_fct), arg)
        end
        current.add_child LeafNode.new(MCArg.method(eval_fct).(ex), ex[-1])
      end
      tree
    end

    def build_executions(current, list)
      args = Array.new(@args)
      @exec_filters.each do |filt|
        args = MCArg.method(filt).(current, args)
      end
      return list + [current] if args.empty?
      args.each do |arg|
        list = build_executions(current + [arg], list)
      end
      list
    end
  end
end
