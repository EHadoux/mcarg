module MCArg
  require_relative "mcarg/dec_functions"
  require_relative "mcarg/eval_functions"
  autoload :Tree, "mcarg/tree"
  autoload :Node, "mcarg/node"
  autoload :Graph, "mcarg/graph"
  autoload :LeafNode, "mcarg/leaf_node"
end
