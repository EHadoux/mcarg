module MCArg
  def self.w_avg(values, params)
    [values, params[:weights]].transpose.map {|a,b| a*b}.reduce(:+)
  end

  def self.owa(values, params)
    MCArg.w_avg(values.sort, params[:weights])
  end

  def self.max_agg(values, _)
    values.max
  end

  def self.min_agg(values, _)
    values.min
  end
end
