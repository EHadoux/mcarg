module MCArg
  class Node
    attr_reader :children, :function, :value, :optimal, :label
    attr_accessor :parent

    def initialize(function, label=nil)
      @function = function
      @label    = label
      @children = Hash.new(nil)
      @value    = nil
      @optimal  = nil
      @parent   = nil
    end

    def add_child(node)
      child = @children[node.label]
      if child.nil?
        node.parent = self
        @children[node.label] = node
      end
      @children[node.label]
    end

    def optimize(discount = 0.9)
      if value.is_nil?
        @children.each_value { |c| c.optimize(discount) }
        optimal = MCArg.method(@function).(children)
        value   = discount * optimal.value
      end
    end
  end
end
