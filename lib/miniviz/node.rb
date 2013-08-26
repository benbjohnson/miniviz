class Miniviz
  class Node
    ##########################################################################
    #
    # Constructor
    #
    ##########################################################################

    def initialize(options={})
      Miniviz.symbolize_keys!(options)
      @graph = options[:graph]
      @id = options[:id]
      @label = options[:label]
      @children = []
      self.add_children(options[:children] || [])
    end


    ##########################################################################
    #
    # Attributes
    #
    ##########################################################################

    # The graph that this node belongs to.
    attr_accessor :graph

    # The Graphviz object for this node.
    attr_accessor :gv

    # The node identifier.
    attr_accessor :id

    # The label used for the node.
    attr_accessor :label

    # A list of child nodes within this node.
    attr_accessor :children


    ##########################################################################
    #
    # Methods
    #
    ##########################################################################

    ####################################
    # Children
    ####################################

    def add_child(node)
      node = Node.new(node) unless node.is_a?(Node)
      node.graph = graph
      @children << node
      return node
    end

    def add_children(nodes)
      nodes.to_a.each {|node| add_child(node) }
    end

    def get_node(node_id)
      if node_id == id
        return self
      end

      children.each do |child|
        n = child.get_node(node_id)
        return n unless n.nil?
      end

      return nil
    end

    def all_nodes()
      return children.inject([self]) {|r,child| r.concat(child.all_nodes)}
    end

    ####################################
    # Validation
    ####################################

    def validate
      errors = []

      if id.to_s == ""
        errors << "Node identifier cannot be blank"
      end

      children.each {|child| errors.concat(child.validate) }

      return errors
    end

    ####################################
    # Layout
    ####################################

    def extract_layout_from_svg(element)
      # TODO: Extract x,y and width,height.
    end
  end
end
