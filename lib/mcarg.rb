module MCArg
  require_relative "mcarg/functions/dec_functions"
  require_relative "mcarg/functions/eval_functions"
  require_relative "mcarg/functions/update_functions"
  require_relative "mcarg/functions/filter_functions"
    
  autoload :Tree, "mcarg/dec_tree/tree"
  autoload :Node, "mcarg/dec_tree/node"
  autoload :LeafNode, "mcarg/dec_tree/leaf_node"
  autoload :Graph, "mcarg/arg_graph/graph"
  autoload :Argument, "mcarg/arg_graph/argument"
end
