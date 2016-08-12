module MCArg
  class Argument
    attr_reader :is_atked_by, :attacks, :label, :index
    attr_accessor :belief, :initial_belief, :component

    def initialize(label, index)
      @label          = label
      @belief         = 0.5
      @initial_belief = @belief
      @is_atked_by    = {}
      @attacks        = {}
      @index          = index
      @component      = nil
    end

    def add_attack(arg)
      @attacks[arg.label] = arg
      arg.is_atked_by[@label] = self
    end

    def reset_belief
      @belief = @initial_belief
    end

    def propagate_component
      @attacks.each do |_, a|
        if a.component != @component
          a.component = @component
          a.propagate_component
        end
      end
      @is_atked_by.each do |_, a|
        if a.component != @component
          a.component = @component
          a.propagate_component
        end
      end
    end
  end
end
