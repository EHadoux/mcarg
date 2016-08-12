module MCArg
  class LeafNode < Node
    attr_accessor :value

    def initialize(value, label)
      super({func: MCArg.method(:leaf)}, false, label)
      @value = value
    end

    def add_child(node)
      throw NotImplementedError
    end
  end
end
