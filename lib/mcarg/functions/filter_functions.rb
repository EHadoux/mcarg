module MCArg
  def self.no_duplicate(current, args, _)
    args - current
  end

  def self.no_attacked_from_believed(current, args, graph)
    beliefs = Hash.new(0)
    distribution = [Rational(1, graph.size)] * graph.size
    current.each do |arg|
      distribution = MCArg.refinement(distribution, 1, true, graph.args[arg].index)
    end
    distribution.each_with_index do |prob, index|
      
    end
    to_rem = []
    args.each do |arg|
      distrib_test = Array.new(distribution)
      distrib_test = MCArg.refinement(distrib_test, 1, true, graph.args[arg].index)
      bel = 0
      distrib_test.each_with_index do |set_bel, index|
        bel += set_bel if index.to_s(2)[graph.args[arg].index] == "1"
      end

    end
  end
end
