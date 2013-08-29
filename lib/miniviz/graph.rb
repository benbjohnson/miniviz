require 'fileutils'

class Miniviz
  class Graph
    ##########################################################################
    #
    # Static Methods
    #
    ##########################################################################

    # Ease of use function for building a graph and generating its layout.
    def self.layout(options={})
      graph = Graph.new(options)
      graph.layout()
      return graph.as_json()
    end


    ##########################################################################
    #
    # Constructor
    #
    ##########################################################################

    def initialize(options={})
      self.object = options[:object] || options
      self.rankdir = options[:rankdir] || options["rankdir"] || "TB"
      self.fontname = options[:fontname] || options["fontname"] || "Times,serif"
      self.fontsize = options[:fontsize] || options["fontsize"] || 14

      @nodes, @edges = [], []
      self.add_nodes(options[:nodes] || options["nodes"] || [])
      self.add_edges(options[:edges] || options["edges"] || [])
    end


    ##########################################################################
    #
    # Attributes
    #
    ##########################################################################

    # The original object that this graph is created from.
    attr_accessor :object

    # A list of nodes in the graph.
    attr_accessor :nodes

    # A list of edges between nodes in the graph.
    attr_accessor :edges

    # The width of the graph.
    attr_accessor :width

    # The height of the graph.
    attr_accessor :height

    # The orientation of the nodes ("LR", "RL", "TB", "BT").
    attr_accessor :rankdir

    # The font family used in the graph.
    attr_accessor :fontname

    # The font size, in points, used in the graph.
    attr_accessor :fontsize


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

    def get_node(node_id)
      nodes.each do |node|
        n = node.get_node(node_id)
        return n unless n.nil?
      end
      return nil
    end

    def all_nodes()
      return nodes.inject([]) {|r,node| r.concat(node.all_nodes)}
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

    def get_edge(source, target)
      edges.each do |edge|
        if edge.source == source && edge.target == target
          return edge
        end
      end
      return nil
    end



    ####################################
    # Layout
    ####################################

    # Lays out the nodes and edges in the graph.
    def layout(options={})
      errors = validate()
      if errors.length > 0
        return errors
      end

      # Generate graphviz layout to file and read it back in.
      g = to_graphviz()
      svg = generate_svg_layout(g)
      extract_layout_from_svg(svg)

      return []
    end

    # Applies the layout to the source objects.
    def apply_layout(options={})
      if object.is_a?(Hash)
        object["width"] = width
        object["height"] = height
      end

      nodes.each do |node|
        node.apply_layout(options)
      end
      edges.each do |edge|
        edge.apply_layout(options)
      end
    end

    def validate()
      errors = []
      nodes.each {|node| errors.concat(node.validate) }
      edges.each {|edge| errors.concat(edge.validate) }
      
      ids = all_nodes.map{|n| n.id}
      if ids.detect {|i| ids.count(i) > 1 }
        errors << "Duplicate node identifiers not allowed"
      end

      return errors
    end

    # Generates a Graphviz graph from the nodes and edges.
    def to_graphviz()
      g = GraphViz.new(:G, :type => :digraph)
      g[:rankdir] = rankdir
      nodes.each do |node|
        node.to_graphviz(g)
      end
      edges.each do |edge|
        edge.to_graphviz(g)
      end
      return g
    end


    ####################################
    # Encoding
    ####################################

    # Encodes the graph into a hash.
    def to_hash(*a)
      {
        'width' => width,
        'height' => height,
        'nodes' => nodes.to_a.map{|n| n.to_hash()},
        'edges' => edges.to_a.map{|e| e.to_hash()},
      }
    end

    def as_json(*a); return to_hash(*a); end
    def to_json(*a); return as_json(*a).to_json; end


    ####################################
    # SVG
    ####################################

    def to_svg
      output = []
      output << "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
      output << "<svg xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" width=\"#{width+(PADDING*2)}\" height=\"#{height+(PADDING*2)}\">"
      edges.each do |edge|
        output << edge.to_svg()
      end
      nodes.each do |node|
        output << node.to_svg()
      end
      output << "</svg>"
      return output.join("\n")
    end


    ####################################
    # Utility
    ####################################

    # Inverts the graphviz y coordinate based on the height of the graph.
    def invert_y(value)
      height + (value - (PADDING * PT2PX * 2))
    end


    ##########################################################################
    #
    # Private Methods
    #
    ##########################################################################
    
    private

    # Writes out the SVG layout to file and reads it back in as a string.
    def generate_svg_layout(g)
      tmppath = Tempfile.open('miniviz') {|f| f.path}
      tmppath += ".svg"
      begin
        FileUtils.mkdir_p(File.dirname(tmppath))
        g.output(svg:tmppath)
        FileUtils.cp(tmppath, "/tmp/miniviz.test.svg")
        return IO.read(tmppath)
      ensure
        FileUtils.rm(tmppath, :force => true)
      end
    end

    # Normalizes and extracts layout data from an SVG file.
    def extract_layout_from_svg(svg)
      svg = Nokogiri::XML(svg)
      
      # Extract width and height from root node.
      root = svg.at_css("svg")
      self.width = (root["width"].to_f * PT2PX).round(3)
      self.height = (root["height"].to_f * PT2PX).round(3)

      svg.css(".node").each do |element|
        id = element.at_css("title").text().to_s
        get_node(id).extract_layout_from_svg(element)
      end

      svg.css(".edge").each do |element|
        source, target = element.at_css("title").text().split("->")
        get_edge(source, target).extract_layout_from_svg(element)
      end
    end
  end
end
