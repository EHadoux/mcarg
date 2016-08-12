module MCArg
  class APXParser
    LABEL = "[[:alnum:]]+"
    FLOAT = "1(\.0)?|0\.[0-9]+"

    def self.parse(filename)
      args = {}
      goal = []
      index = 0 # Absolutely needed for the update
      component = 0
      IO.foreach(filename) do |line|
        case line
        when /arg\((#{LABEL})\)\./
          args[$1] = Argument.new($1, index)
          index += 1
        when /att\((#{LABEL}), (#{LABEL})\)\./
          args[$1].add_attack(args[$2])
          if args[$1].component.nil?
            args[$1].component = component
            component += 1
          end
          args[$1].propagate_component
        when /prob\((#{LABEL}), (#{FLOAT})\)\./
          args[$1].initial_belief = $2.to_f
        when /goal\((#{LABEL}(,[[:blank:]]*#{LABEL})*)\)\./
          goal = $1.split(",").map(&:strip).map {|g| args[g]}
        when /^\s*^/
        else
          puts "Unknown #{line}"
        end
      end

      return [args, goal]
    end
  end
end
