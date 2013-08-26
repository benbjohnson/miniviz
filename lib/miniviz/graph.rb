class Miniviz
  class Graph
    ##########################################################################
    #
    # Constructor
    #
    ##########################################################################

    def initialize(options={})
      Miniviz.symbolize_keys!(options)
      self.add_nodes(options[:nodes] || [])
      self.add_edges(options[:edges] || [])
    end


    ##########################################################################
    #
    # Attributes
    #
    ##########################################################################

    # A list of nodes in the graph.
    attr_accessor :nodes

    # A list of edges between nodes in the graph.
    attr_accessor :edges


    ##########################################################################
    #
    # Methods
    #
    ##########################################################################
    
    ####################################
    # Nodes
    ####################################

    def add_node(node)
      node = Node.new(node) unless node.is_a?(Node)
      node.graph = self
      @nodes << node
      return node
    end

    def add_nodes(nodes)
      nodes.to_a.each {|node| add_node(node) }
    end

    ####################################
    # Edges
    ####################################

    def add_edge(edge)
      edge = Edge.new(edge) unless edge.is_a?(Edge)
      edge.graph = self
      @edges << edge
      return edge
    end

    def add_edges(edges)
      edges.to_a.each {|edge| add_edge(edge) }
    end


    ####################################
    # Layout
    ####################################

    # Lays out the nodes and edges in the graph.
    def layout(options={})
      return {}
    end
  end
end
