module MCArg
  # Value functions
  def self.present(goal, execution)
    goal.map { |g| [g.label, (execution.include?(g.label) ? 1.fdiv(goal.size) : 0)]}.to_h
  end

  def self.random(goal, _)
    goal.map { |g| [g.label, rand(10)] }.to_h
  end

  # Combination function
  #def self.std_sum(goal)
  #  goal.values.reduce(:+)
  #end
end
