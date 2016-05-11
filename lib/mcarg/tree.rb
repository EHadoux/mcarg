module MCArg
  class Tree
    attr_reader :root

    def initialize(root)
      @root = root
    end

    def optimize
      root.optimize
    end

    def draw_tree
      require "graphviz"

      graph = GraphViz.new(:tree, :type => :graph, :rankdir => "LR")
      root = graph.add_nodes("root", :shape => :box)
      build_children(graph, @root, root, :circle, 1)

      graph.output( :png => "test.png" )
    end

    def build_children(graph, node, gnode, shape, tag)
      node.children.each do |l, n|
        if n.children.empty?
          child = graph.add_nodes(n.value.to_s + tag.to_s, :shape => "none")
          graph.add_edges(gnode, child, :label => l)
        else
          child = graph.add_nodes(l + tag.to_s, :shape => shape)
          graph.add_edges(gnode, child, :label => l)
          tag = build_children(graph, n, child, (shape == :box ? :circle : :box), tag+1)
        end
      end
      tag
    end
  end
end
