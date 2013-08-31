class Miniviz
  class Edge
    ##########################################################################
    #
    # Constructor
    #
    ##########################################################################

    def initialize(options={})
      self.object = options[:object] || options

      self.graph = options[:graph] || options["graph"]
      self.source = options[:source] || options["source"]
      self.target = options[:target] || options["target"]
      self.label = options[:label] || options["label"]
      self.penwidth = options[:penwidth] || options["penwidth"]
    end


    ##########################################################################
    #
    # Attributes
    #
    ##########################################################################

    # The original object that this edge is created from.
    attr_accessor :object

    # The graph that this edge belongs to.
    attr_accessor :graph

    # The Graphviz object for this edge.
    attr_accessor :gv

    # The identifier for the source node.
    attr_reader :source

    def source=(value)
      @source = value.nil? ? nil : value.to_s
    end

    def source_node
      return nil if graph.nil?
      graph.get_node(source)
    end

    # The identifier for the target node.
    attr_reader :target

    def target=(value)
      @target = value.nil? ? nil : value.to_s
    end

    def target_node
      return nil if graph.nil?
      graph.get_node(target)
    end

    # The label attached to the edge.
    attr_accessor :label

    # The width of the pen, in pixels.
    attr_accessor :penwidth

    # The SVG path.
    attr_accessor :d

    # The width of the stroke on the path.
    attr_accessor :stroke_width

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
      output << "<path fill=\"none\" stroke=\"black\" stroke-width=\"#{stroke_width}\" d=\"#{d}\"/>"
      output << "<polygon fill=\"black\" stroke=\"black\" points=\"#{arrowhead}\"/>"
      output << "</g>"
      return output.join("\n")
    end

    def to_graphviz(g)
      self.gv = g.add_edges(self.source_node.gv, self.target_node.gv)
      self.gv[:penwidth] = self.penwidth unless self.penwidth.nil?
      self.gv
    end

    ####################################
    # Layout
    ####################################

    # Applies layout information to the source object.
    def apply_layout(options={})
      if object.is_a?(Hash)
        object["d"] = d
        object["stroke_width"] = stroke_width || 1
        object["arrowhead"] = arrowhead
      end
    end

    def extract_layout_from_svg(element)
      self.d = Miniviz::Svg.d(graph, element.at_css("path")["d"])
      self.stroke_width = Miniviz::Svg.pt2px(element.at_css("path")["stroke-width"])
      self.arrowhead = Miniviz::Svg.d(graph, element.at_css("polygon")["points"])
      return nil
    end
  end
end
