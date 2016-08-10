module MCArg
  class Argument
    attr_reader :attackers, :attacked, :label, :index
    attr_accessor :belief, :initial_belief, :component

    def initialize(label, index)
      @label     = label
      @belief    = 0.5
      @initial_belief = @belief
      @attackers = {}
      @attacked  = {}
      @index     = index
      @component = nil
    end

    def add_attacked(arg)
      @attacked[arg.label] = arg
      arg.attackers[@label] = self
    end

    def reset_belief
      @belief = @initial_belief
    end

    def propagate_component
      @attacked.each do |_, a|
        if a.component != @component
          a.component = @component
          a.propagate_component
        end
      end
      @attackers.each do |_, a|
        if a.component != @component
          a.component = @component
          a.propagate_component
        end
      end
    end
  end
end
