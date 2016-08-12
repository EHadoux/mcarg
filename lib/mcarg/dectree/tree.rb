module MCArg
  class Tree
    attr_reader :root

    def initialize(root)
      @root = root
    end

    def optimize
      root.optimize
    end

    def draw_tree(filename)
      require "graphviz"

      graph = GraphViz.new(:tree, :type => :graph, :rankdir => "LR")
      root = graph.add_node("root", :shape => :square, :label => (@root.optimal.nil? ? "" : "#{@root.optimal.label} #{@root.value}"))
      build_children(graph, @root, root, :circle, 1)

      graph.output( :png => "#{filename}.png" )
    end

    def build_children(graph, node, gnode, shape, tag)
      node.children.each do |l, n|
        if n.children.empty?
          child = graph.add_node(n.value.to_s + tag.to_s, :shape => "none", :label => n.value)
          graph.add_edge(gnode, child, :label => l)
          tag += 1
        else
          child = graph.add_node(l + tag.to_s, :shape => shape, :label => (n.optimal.nil? ? "" : "#{n.optimal.label} #{n.value}"))
          graph.add_edge(gnode, child, :label => l)
          tag = build_children(graph, n, child, (shape == :square ? :circle : :square), tag+1)
        end
      end
      tag
    end
  end
end
