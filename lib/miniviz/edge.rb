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

    # The identifier for the source node.
    attr_accessor :source

    # The identifier for the target node.
    attr_accessor :target

    # The label attached to the edge.
    attr_accessor :label
  end
end
