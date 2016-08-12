module MCArg
  # Value functions
  def self.present(goal, execution, _)
    goal.map { |g| [g, (execution.include?(g.label) ? 1.fdiv(goal.size) : 0)]}.to_h
  end

  def self.random(goal, _, _)
    goal.map { |g| [g, rand(10)] }.to_h
  end
end
