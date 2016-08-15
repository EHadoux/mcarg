module MCArg
  def kullback_leibler(p, q)
    p.lazy.zip(q).map {|pp, qp| pp * Math.log2(pp / qp)}.reduce(:+) #log2 -> [0,1] for JSD
  end

  def jensen_shannon(p, q)
    m = p.lazy.zip(q).map {|pp, pq| (pp + pq) / 2}.to_a
    kullback_leibler(p, m) / 2 + kullback_leibler(q, m) / 2
  end

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
