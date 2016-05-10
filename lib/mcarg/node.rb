module MCArg
  attr_reader :children, :type, :parent, :label, :optimal, :value
  cattr_accessor :decision_method, :chance_method

  def max_dec(children)
    children.max_by { |a| a.value }
  end

  class Node
    def initialize(label, parent, value=nil)
      @parent   = parent
      @type     = (@parent.type == :decision ? :chance : :decision)
      @label    = label
      @children = {}
      @optimal  = nil
      @value    = value
    end

    def optimize
      unless @children.empty
        @children.each {|c| c.optimize}
        @optimal, @value = case @type
        when :decision
          @@decision_method.(children)
        when :chance
          @@chance_method.(children)
        end
      end
    end
  end
end