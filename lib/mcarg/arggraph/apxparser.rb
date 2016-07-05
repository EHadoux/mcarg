module MCArg
  class APXParser
    LABEL = "[[:alnum:]]+"
    FLOAT = "1(\.0)?|0\.[0-9]+"

    def self.parse(filename)
      args = {}
      goal = []
      IO.foreach(filename) do |line|
        case line
        when /arg\((#{LABEL})\)\./
          args[$1] = Argument.new($1)
        when /att\((#{LABEL}), (#{LABEL})\)\./
          args[$1].add_attacked(args[$2])
        when /prob\((#{LABEL}), (#{FLOAT})\)\./
          args[$1].initial_belief = $2.to_f
        when /goal\((#{LABEL}(,[[:blank:]]*#{LABEL})*)\)\./
          goal = $1.split(",").map(&:strip)
        when /^\s*^/
        else
          puts "Unknown #{line}"
        end
      end

      return [args, goal]
    end
  end
end
