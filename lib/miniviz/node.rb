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
      @children = options[:children] || []
    end


    ##########################################################################
    #
    # Attributes
    #
    ##########################################################################

    # The graph that this node belongs to.
    attr_accessor :id

    # The node identifier.
    attr_accessor :id

    # The label used for the node.
    attr_accessor :label

    # A list of child nodes within this node.
    attr_accessor :children
  end
end
