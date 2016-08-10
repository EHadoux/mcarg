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
    children.max_by { |l,n| n.value }
  end

  def self.min_dec(children)
    children.min_by {|l,n| n.value }
  end

  def self.min_regret_dec(children)
    leafChildren = children.select{|l,c| c.is_a? LeafNode}
    unless leafChildren.empty?
      l, node = leafChildren.max_by { |l, n| n.value }
      node.value = 0
      return [l, node]
    end
    children.min_by {|l,n| n.value }
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
  def self.max_chance(children, _)
    max_dec(children)
  end

  def self.min_chance(children, _)
    min_dec(children)
  end

  def self.laplace_chance(children, _)
    val = children.map { |l,n| n.value.fdiv(children.size) }.reduce(:+)
    children.each {|l,c| c.value = val}
    children.max_by { |l,n| n.value }
  end

  def self.hurwicz_chance(children, alpha)
    max = children.max_by { |l,n| n.value }
    min = children.min_by { |l,n| n.value }
    children.each {|l,c| c.value = alpha * max + (1-alpha) * min}
  end

  def self.max_regret_chance(children, _)
    leafChildren = children.select{|l,c| c.is_a? LeafNode}
    unless leafChildren.empty?
      _, node = leafChildren.max_by { |l, n| n.value }
      max_val = node.value
      children.each {|l,c| c.value = max_val - c.value if c.is_a? LeafNode}
    end
    children.max_by { |l,n| n.value }
  end

  def self.pareto_chance(children, _)
    pareto_dec(children)
  end

  def self.dominated_chance(children, _)
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

  def self.leaf(children, _)
    nil
  end
end
