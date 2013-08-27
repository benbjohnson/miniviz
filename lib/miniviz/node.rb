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

    # The X coordinate of the node.
    attr_accessor :x

    # The Y coordinate of the node.
    attr_accessor :y

    # The width of the node.
    attr_accessor :width

    # The height of the node.
    attr_accessor :height


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
    # Encoding
    ####################################

    # Encodes the node into a hash.
    def to_hash(*a)
      hash = {}
      hash['id'] = id
      hash['label'] = label unless label.nil?
      hash['x'] = x unless x.nil?
      hash['y'] = y unless y.nil?
      hash['width'] = width unless width.nil?
      hash['height'] = height unless height.nil?
      hash['children'] = children.to_a.map{|n| n.to_hash()} if children.to_a.length > 0
      return hash
    end

    def as_json(*a); return to_hash(*a); end
    def to_json(*a); return as_json(*a).to_json; end

    ####################################
    # SVG
    ####################################

    def to_svg
      output = []
      output << "<g>"
      output << "<rect fill=\"none\" stroke=\"black\" x=\"#{x}\" y=\"#{y}\" width=\"#{width}\" height=\"#{height}\"/>"
      output << "</g>"
      return output.join("\n")
    end

    ####################################
    # Layout
    ####################################

    def extract_layout_from_svg(element)
      self.x, self.y, self.width, self.height = Miniviz::Svg.points_to_rect(graph, element.at_css("polygon")["points"])
      return nil
    end
  end
end
