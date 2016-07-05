module MCArg
  require_relative "mcarg/functions/dec_functions"
  require_relative "mcarg/functions/eval_functions"
  require_relative "mcarg/functions/update_functions"
  require_relative "mcarg/functions/filter_functions"

  autoload :Tree, "mcarg/dectree/tree"
  autoload :Node, "mcarg/dectree/node"
  autoload :LeafNode, "mcarg/dectree/leaf_node"
  autoload :Graph, "mcarg/arggraph/graph"
  autoload :Argument, "mcarg/arggraph/argument"
  autoload :APXParser, "mcarg/arggraph/apxparser"
end
