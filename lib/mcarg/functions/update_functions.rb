module MCArg
  def self.refinement(distribution, factor, side, arg)
    nb_bits  = Math.log2(distribution.size).ceil
    new_dist = Array.new(distribution)
    arg.belief = 0
    (0...distribution.size).each do |it|
      bits = ("%0#{nb_bits}b" % it)
      h = String.new(bits)
      h[arg.index] = (side ? "0" : "1")

      if side ^ (bits[arg.index] == "0")
        new_dist[it] += factor * distribution[h.to_i(2)]
      else
        new_dist[it] = (1 - factor) * distribution[it]
      end
      arg.belief += new_dist[it] if bits[arg.index] == "1"
    end
    new_dist
  end

  def self.naive(distribution, arg)
    MCArg.refinement(distribution, 1, true, arg)
  end

  def self.trusting(distribution, arg)
    related = arg.attacked.values + arg.attackers.values
    dist = MCArg.refinement(distribution, 1, true, arg)
    related.each {|a| dist = MCArg.refinement(dist, 1, false, a)}
    dist
  end

  def self.strict(distribution, arg)
    dist    = distribution
    related = arg.attacked.values
    if arg.attackers.values.all? {|a| a.belief <= 0.5}
      dist = MCArg.refinement(distribution, 1, true, arg)
      related.each {|a| dist = MCArg.refinement(dist, 1, false, a)}
    end
    dist
  end
end
