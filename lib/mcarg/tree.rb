module MCArg
  attr_reader :root

  class Tree
    def initialize(root)
      @root = root
    end

    def optimize
      root.optimize
    end
  end
end