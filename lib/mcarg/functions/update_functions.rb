module MCArg
  def self.refinement(distribution, factor, side, arg)
    nb_bits  = Math.log2(distribution.size).ceil
    new_dist = Array.new(distribution)
    (0...distribution.size).each do |it|
      bits = ("%0#{nb_bits}b" % it).freeze
      h = String.new(bits)
      h[arg] = (side ? "0" : "1")

      if side
        if bits[arg] == "1"
          new_dist[it] += factor * distribution[h.to_i(2)]
        else
          new_dist[it] = (1 - factor) * distribution[it]
        end
      else
        if bits[arg] == "0"
          new_dist[it] += factor * distribution[h.to_i(2)]
        else
          new_dist[it] = (1 - factor) * distribution[it]
        end
      end
    end
    new_dist
  end
end
