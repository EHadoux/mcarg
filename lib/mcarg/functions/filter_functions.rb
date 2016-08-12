module MCArg
  def self.no_duplicate(current, args, _)
    args - current
  end

  def self.no_goal_self_attacks(current, args, params)
    if current.size.even?
      args.reject {|arg| params[:graph].goal.any? {|g| params[:graph].args[arg].attacks.include? g.label}}
    else
      args
    end
  end

  # Not test nor finished, don't plan to use it
  def self.relevant_args(current, args, params)
    return args if current.empty?
    active_args           = current.map {|a| params[:graph].args[a]}
    active_components     = Set.new(active_args.map(&:component))
    others, new_comp_args = args.partition {|a| active_components.include? params[:graph].args[a].component}
    others.reject! {|a| params[:graph].args[a].attacks.none? {|atked| active_args.include? atked}}
    new_comp_args + others
  end
end
