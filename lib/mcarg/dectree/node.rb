module MCArg
  class Node
    attr_reader :children, :proponent, :dec_func, :label, :fct_arg
    attr_accessor :parent, :value, :optimal

    def initialize(dec_hash, proponent, label=nil)
      @dec_func  = dec_hash[:func]
      @fct_arg   = dec_hash[:params]
      @proponent = proponent
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

    def optimize
      assert @proponent, "Optimization of proponent's args only"
      assert @value.nil?
      @children.values.reject {|c| c.is_a? LeafNode}.each {|c| c.children.values.reject {|c| c.is_a? LeafNode}.each {|n| n.optimize}}
      @dec_func.(self, @fct_arg)
    end
  end
end
