module MCArg
  class Evaluator
    attr_reader :tree

    RANDOM  = -> node {node.children.values.sample}
    OPTIMAL = -> node {node.optimal}

    def initialize(tree)
      @tree = tree
    end

    def evaluate(runs, pro, opp)
      avg = 0.0
      runs.times do
        avg += nextnode(@tree.root, pro, opp)
      end
      avg / runs
    end

    def nextnode(node, pro, opp)
      return node.value if node.is_a? LeafNode
      if node.proponent
        nextnode(pro.(node), pro, opp)
      else
        nextnode(opp.(node), pro, opp)
      end
    end
  end
end
