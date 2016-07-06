module MCArg
  def self.no_duplicate(current, args, _)
    args - current
  end
end
