# def dominate(p1, p2)
#   comp = -2
#   p1.each_with_index do |v, ind|
#     next if v == p2[ind]
#     if v < p2[ind]
#       next if comp == 1
#       return 0 if comp == -1
#       comp = 1
#     else
#       next if comp == -1
#       return 0 if comp == 1
#       comp = -1
#     end
#   end
#   comp
# end

module MCArg
  def self.max(node, params) # private
    assert node.children.values.all? {|n| n.value}, "All children should have a value"
    max_node     = node.children.values.max_by {|n| n.value}
    node.value   = max_node.value * params[:discount]
    node.optimal = max_node
  end

  def self.min(node, params) # private
    assert node.children.values.all? {|n| n.value}, "All children should have a value"
    min_node     = node.children.values.min_by {|n| n.value}
    node.value   = min_node.value * params[:discount]
    node.optimal = min_node
  end

  def self.leaf(children, _)
    raise NotImplementedError
  end

  def self.maximin(node, params)
    node.children.values.reject {|c| c.is_a? LeafNode}.each do |c|
      assert c.children.values.all? {|n| n.value}, "All children should have a value"
      min     = c.children.values.map(&:value).min
      c.value = min * params[:discount]
    end
    MCArg.max(node, params)
  end

  def self.maximax(node, params)
    node.children.values.reject {|c| c.is_a? LeafNode}.each do |c|
      assert c.children.values.all? {|n| n.value}, "All children should have a value"
      max     = c.children.values.map(&:value).max
      c.value = max * params[:discount]
    end
    MCArg.max(node, params)
  end

  def self.laplace(node, params)
    node.children.values.reject {|c| c.is_a? LeafNode}.each do |c|
      assert c.children.values.all? {|n| n.value}, "All children should have a value"
      c.value = c.children.values.map { |n| n.value.fdiv(children.size) }.reduce(:+) * params[:discount]
    end
    MCArg.max(node, params)
  end

  def self.hurwicz(node, params)
    node.children.values.reject {|c| c.is_a? LeafNode}.each do |c|
      assert c.children.values.all? {|n| n.value}, "All children should have a value"
      min, max = c.children.values.map(&:value).minmax
      c.value  = (params[:alpha] * max + (1 - params[:alpha]) * min) * params[:discount]
    end
    MCArg.max(node, params)
  end

  def self.minmaxregret(node, params)
    node.children.values.reject {|c| c.is_a? LeafNode}.reject! {|c| c.value}.each do |c|
      leaves, others = c.children.values.partition {|n| n.is_a? LeafNode}
      min, max     = leaves.map(&:value).minmax
      max_non_leaf = others.map(&:value).max
      c.value = [(max - min) * (2 - params[:discount]), max_non_leaf].max # Because we want to increase the regret is the outcome is further
    end

    assert node.children.values.all? {|n| n.value}, "All children should have a value"
    leaves = node.children.values.select {|n| n.is_a? LeafNode}
    if leaves.empty?
      MCArg.min(node, params.merge({discount: 2 - params[:discount]}))
    else # Regret on a leaf connected to a proponent node is 0 because it can choose to surely have this outcome
      max_leaf     = leaves.max_by {|n| n.value}
      node.value   = 0
      node.optimal = max_leaf
    end
  end

  # def self.pareto_dec(children)
  #   optima = [children[0]]
  #   children[1..-1].each do |c|
  #     to_rem = []
  #     to_add = []
  #     dom = false
  #     optima.each do |o|
  #       case dominate(c.value, o.value)
  #       when 1
  #         dom = true
  #         break
  #       when -1
  #         to_rem << o
  #       end
  #     end
  #     optima -= to_rem
  #     optima << c unless dom
  #   end
  #   optima
  # end

  # def self.pareto_chance(children, _)
  #   pareto_dec(children)
  # end

  # def self.dominated_chance(children, _)
  #   dominated = [children[0]]
  #   children[1..-1].each do |c|
  #     to_rem = []
  #     to_add = []
  #     dom = true
  #     dominated.each do |o|
  #       case dominate(c.value, o.value)
  #       when -1
  #         dom = false
  #         break
  #       when 1
  #         to_rem << o
  #       end
  #     end
  #     dominated -= to_rem
  #     dominated << c if dom
  #   end
  #   dominated
  # end
end
