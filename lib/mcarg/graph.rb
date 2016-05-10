module MCArg
  attr_reader :nodes, :args, :exec_filters

  def no_duplicate(current, args)
    args - current
  end

  class Graph
    def initialize(exec_filters)
      @exec_filters = exec_filters
    end

    def build_tree
      executions = build_execution([], [])
    end

    def build_execution(current, list)
      args = Array.new(@args)
      @exec_filters.each do |filt|
        args = filt.(current, args)
      end
      return list + [current] if args.empty?
      args.each do |arg|
        list = build_execution(current + arg, list)
      end
      list
    end
  end
end