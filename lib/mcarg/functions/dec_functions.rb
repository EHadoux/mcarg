module MCArg
  def self.max_dec(children)
    children.max_by { |n| n.value }
  end

  def self.min_dec(children)
    children.min_by {|n| n.value }
  end

  def self.max_chance(children)
    max_dec(children)
  end

  def self.min_chance(children)
    min_dec(children)
  end

  def self.max_regret_chance(children)
    max_val = children.max_by { |n| n.value }.value
    children.max_by { |n| max_val - n.value }
  end

  def self.leaf(children)
    nil
  end
end
