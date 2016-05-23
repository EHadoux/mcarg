module MCArg
  class Argument
    attr_reader :attackers, :attacked, :label, :index
    attr_accessor :belief, :initial_belief

    def initialize(label, index)
      @label     = label
      @index     = index
      @belief    = 0
      @initial_belief = 0
      @attackers = {}
      @attacked  = {}
    end

    def add_attacked(arg)
      @attacked[arg.label] = arg
      arg.attackers[@label] = self
    end

    def reset_belief
      @belief = @initial_belief
    end
  end
end
