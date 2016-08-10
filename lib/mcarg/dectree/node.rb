require "pry"
module MCArg
  class Node
    attr_reader :children, :function, :value, :optimal, :label, :fct_arg
    attr_accessor :parent

    def initialize(function, fct_arg, label=nil)
      @function  = function
      @fct_arg   = fct_arg
      @label     = label
      @children  = Hash.new(nil)
      @value     = nil
      @optimal   = nil
      @parent    = nil
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
      if @value.nil?
        @children.each_value { |c| c.optimize(discount) }
        _, @optimal = MCArg.method(@function).(children, @fct_arg)
        @value   = discount * optimal.value
      end
    end
  end
end
