module MCArg
  def self.update(distribution, new_dist, it, factor, side, arg) #private
    argindex = it[arg.index]
    if side ^ (argindex == 0)
      mask = 1 << arg.index
      index = side ? ~(mask ^ ~it) : (it | mask)
      new_dist[it] += factor * distribution[index]
    else
      new_dist[it] = (1 - factor) * distribution[it]
    end
    arg.belief += new_dist[it] if argindex == 1
  end

  def self.refinement(distribution, factor, side, arg, params) # private
    nb_bits  = Math.log2(distribution.size).ceil
    new_dist = Array.new(distribution)
    t = []
    arg.belief = 0
    (0...distribution.size).each {|it| MCArg.update(distribution, new_dist, it, factor, side, arg)}
    new_dist
  end

  def self.naive(distribution, arg, params)
    MCArg.refinement(distribution, 1, true, arg, params)
  end

  def self.trusting(distribution, arg, params)
    related = arg.attacks.values + arg.is_atked_by.values
    dist = MCArg.refinement(distribution, 1, true, arg, params)
    related.each {|a| dist = MCArg.refinement(dist, 1, false, a, params)}
    dist
  end

  def self.strict(distribution, arg, params)
    related = arg.attacks.values
    if arg.is_atked_by.values.all? {|a| a.belief <= 0.5}
      distribution = MCArg.refinement(distribution, 1, true, arg, params)
      related.each {|a| distribution = MCArg.refinement(distribution, 1, false, a, params)}
    end
    distribution
  end

  def self.ambivalent(distribution, arg, params)
    related = arg.is_atked_by.values
    if arg.is_atked_by.values.all? {|a| a.belief <= 0.5}
      distribution = MCArg.refinement(distribution, 0.75, true, arg, params)
      related.each {|a| distribution = MCArg.refinement(distribution, 0.75, false, a, params)}
    end
    distribution
  end
end
