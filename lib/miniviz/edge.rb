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
    # Layout
    ####################################

    def extract_layout_from_svg(element)
      # TODO: Extract path information.
    end
  end
end
