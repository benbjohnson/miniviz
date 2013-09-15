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
      self.weight = options[:weight] || options["weight"]
      self.penwidth = options[:penwidth] || options["penwidth"]
      self.arrowhead = options[:arrowhead] || options["arrowhead"]
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

    # The arrowhead shape.
    attr_accessor :arrowhead

    # An integer weight used for layout.
    attr_accessor :weight

    # The SVG path.
    attr_accessor :d

    # The width of the stroke on the path.
    attr_accessor :stroke_width

    # The SVG arrowhead polygon points.
    attr_accessor :arrowhead_points

    # The X coordinate of the edge label.
    attr_accessor :label_x

    # The Y coordinate of the edge label.
    attr_accessor :label_y



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
      hash['label_x'] = label_x unless label_x.nil?
      hash['label_y'] = label_y unless label_y.nil?
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
      output << "<polygon fill=\"black\" stroke=\"black\" points=\"#{arrowhead_points}\"/>"
      if label.to_s != ""
        output << "<text text-anchor=\"middle\" x=\"#{label_x}\" y=\"#{label_y}\" font-family=\"#{graph.fontname}\" font-size=\"#{graph.fontsize}pt\">#{label}</text>"
      end
      output << "</g>"
      return output.join("\n")
    end

    def to_graphviz(g)
      self.gv = g.add_edges(self.source_node.gv, self.target_node.gv)
      self.gv[:fontname] = graph.fontname
      self.gv[:fontsize] = graph.fontsize.to_s
      self.gv[:label] = self.label unless self.label.nil?
      self.gv[:penwidth] = self.penwidth unless self.penwidth.nil?
      self.gv[:weight] = self.weight.to_i unless self.weight.nil?
      self.gv[:arrowhead] = self.arrowhead unless self.arrowhead.nil?
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
        object["arrowhead_points"] = arrowhead_points
        object["label_x"] = label_x
        object["label_y"] = label_y
      end
    end

    def extract_layout_from_svg(element)
      self.d = Miniviz::Svg.d(graph, element.at_css("path")["d"])
      self.stroke_width = Miniviz::Svg.pt2px(element.at_css("path")["stroke-width"])
      self.arrowhead_points = element.at_css("polygon") ? Miniviz::Svg.d(graph, element.at_css("polygon")["points"]) : nil
      self.label_x, self.label_y = Miniviz::Svg.xy(graph, element.at_css("text"))
      return nil
    end
  end
end
