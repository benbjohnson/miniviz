class Miniviz
  class Edge
    ##########################################################################
    #
    # Constructor
    #
    ##########################################################################

    def initialize(options={})
      Miniviz.symbolize_keys!(options)
      @graph = options[:graph]
      @source = options[:source]
      @target = options[:target]
      @label = options[:label]
    end


    ##########################################################################
    #
    # Attributes
    #
    ##########################################################################

    # The graph that this edge belongs to.
    attr_accessor :graph

    # The Graphviz object for this edge.
    attr_accessor :gv

    # The identifier for the source node.
    attr_accessor :source

    def source_node
      return nil if graph.nil?
      graph.get_node(source)
    end

    # The identifier for the target node.
    attr_accessor :target

    def target_node
      return nil if graph.nil?
      graph.get_node(target)
    end

    # The label attached to the edge.
    attr_accessor :label

    # The SVG path.
    attr_accessor :d

    # The SVG arrowhead polygon points.
    attr_accessor :arrowhead


    ##########################################################################
    #
    # Methods
    #
    ##########################################################################

    ####################################
    # Validation
    ####################################

    def validate
      errors = []

      if source_node.nil?
        errors << "Edge source not found: '#{source}'"
      end
      if target_node.nil?
        errors << "Edge target not found: '#{target}'"
      end

      return errors
    end

    ####################################
    # Encoding
    ####################################

    # Encodes the edge into a hash.
    def to_hash(*a)
      hash = {
        'source' => source,
        'target' => target,
      }
      hash['label'] = label unless label.nil?
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
      output << "<path fill=\"none\" stroke=\"black\" d=\"#{d}\"/>"
      output << "<polygon fill=\"black\" stroke=\"black\" points=\"#{arrowhead}\"/>"
      output << "</g>"
      return output.join("\n")
    end

    ####################################
    # Layout
    ####################################

    def extract_layout_from_svg(element)
      self.d = Miniviz::Svg.d(graph, element.at_css("path")["d"])
      self.arrowhead = Miniviz::Svg.d(graph, element.at_css("polygon")["points"])
      return nil
    end
  end
end
