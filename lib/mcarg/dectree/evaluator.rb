module MCArg
  def self.kullback_leibler(p, q)
    p.lazy.zip(q).map {|pp, qp| (pp == 0) ? 0 : pp * Math.log2(pp / qp)}.reduce(:+) #log2 -> [0,1] for JSD
  end

  def self.jensen_shannon(p, q)
    m = p.lazy.zip(q).map {|pp, pq| (pp + pq) / 2}.to_a
    kullback_leibler(p, m) / 2 + kullback_leibler(q, m) / 2
  end

  def self.discrete_distribution(distributions)
    r = rand
    distributions.map!.with_index.detect{ |d, i| r -= d; r < 0 }[1]
  end

  class Evaluator
    attr_reader :tree
    cattr_reader :distributions

    RANDOM   = -> node {node.children.values.sample}
    OPTIMAL  = -> node {node.optimal}
    DISCRETE = -> node, distance do
      size = node.children.size
      int_distance = (distance * 10).to_i
      if distributions[0].empty?
        loop do
          profile = Array.new(size) {rand / size}
          dist = (MCArg.jensen_shannon(node.model, profile) * 10).to_i
          distributions[node.label][dist - int_distance] << profile if dist >= int_distance
          break if dist == int_distance
        end
      end
      profile = distributions[node.label][0].shift
    end

    def initialize(tree)
      @tree = tree
      @@distributions = Hash.new { |hash, key| hash[key] = [] }
    end

    def evaluate(runs, pro, opp, from, to)
      @@distributions.clear
      avg = [0.0] * (to - from) * 10.0 + 1
      #CORRECT THE @@DISTRIBUTIONS -> Hash<Array<Array>>
      (from * 10).upto(to * 10).map.with_index do |dist, ind|
        runs.times do
          avg[ind] += nextnode(@tree.root, pro, opp, dist / 10.0)
        end
        avg[ind] / runs
      end
    end

    def nextnode(node, pro, opp, dist)
      return node.value if node.is_a? LeafNode
      if node.proponent
        nextnode(pro.(node), pro, opp, dist)
      else
        nextnode(opp.(node, dist), pro, opp, dist)
      end
    end
  end
end
