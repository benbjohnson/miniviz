require 'test_helper'

class TestNode < MiniTest::Unit::TestCase
  def setup
    @graph = Miniviz::Graph.new()
  end

  def test_missing_node_identifier
    @graph.add_nodes([{id:"A", children:[{id:""}]}])
    assert_equal({:errors=>["Node identifier cannot be blank"]}, @graph.layout())
  end

  def test_duplicate_node_identifier
    @graph.add_nodes([{id:"A", children:[{id:"B"}]}, {id:"B"}])
    assert_equal({:errors=>["Duplicate node identifiers not allowed"]}, @graph.layout())
  end
end
