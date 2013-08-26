require 'test_helper'

class TestEdge < MiniTest::Unit::TestCase
  def setup
    @graph = Miniviz::Graph.new()
  end

  def test_missing_source_node
    @graph.add_nodes([{id:"A", children:[{id:"B"}]}])
    @graph.add_edges([{source:"B", target:"C"}])
    assert_equal(["Edge target not found: 'C'"], @graph.validate())
  end
end
