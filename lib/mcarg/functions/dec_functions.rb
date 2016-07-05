def dominate(p1, p2)
  comp = -2
  p1.each_with_index do |v, ind|
    next if v == p2[ind]
    if v < p2[ind]
      next if comp == 1
      return 0 if comp == -1
      comp = 1
    else
      next if comp == -1
      return 0 if comp == 1
      comp = -1
    end
  end
  comp
end

module MCArg
  # Decision functions
  def self.max_dec(children)
    children.max_by { |n| n.value }
  end

  def self.min_dec(children)
    children.min_by {|n| n.value }
  end  

  def self.pareto_dec(children)
    optima = [children[0]]
    children[1..-1].each do |c|
      to_rem = []
      to_add = []
      dom = false
      optima.each do |o|
        case dominate(c.value, o.value)
        when 1
          dom = true
          break
        when -1
          to_rem << o
        end
      end
      optima -= to_rem
      optima << c unless dom
    end
    optima
  end

  # Chance functions
  def self.max_chance(children)
    max_dec(children)
  end

  def self.min_chance(children)
    min_dec(children)
  end

  def self.max_regret_chance(children)
    max_val = children.select{|c| c.is_a? LeafNode}.max_by { |n| n.value }.value
    children.each {|c| c.value = max_val - c.value if c.is_a? LeafNode}
    children.max_by { |n| n.value }
  end

  def self.pareto_chance(children)
    pareto_dec(children)
  end

  def self.dominated_chance(children)
    dominated = [children[0]]
    children[1..-1].each do |c|
      to_rem = []
      to_add = []
      dom = true
      dominated.each do |o|
        case dominate(c.value, o.value)
        when -1
          dom = false
          break
        when 1
          to_rem << o
        end
      end
      dominated -= to_rem
      dominated << c if dom
    end
    dominated
  end

  def self.leaf(children)
    nil
  end
end
