module MCArg
  def self.w_avg(values, weights)
    [values, weights].transpose.map {|a,b| a*b}.reduce(:+)
  end

  def self.owa(values, weights)
    MCArg.w_avg(values.sort, weights)
  end

  def self.max_agg(values, _)
    values.max
  end

  def self.min_agg(values, _)
    values.min
  end
end
