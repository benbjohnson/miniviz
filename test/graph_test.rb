require 'test_helper'

class TestGraph < MiniTest::Unit::TestCase
  def setup
    @graph = Miniviz::Graph.new()
  end

  def test_layout
    @graph.add_nodes([
      {id:"A"},
      {id:"B"},
      {id:"C"},
      ])
    @graph.add_edges([
      {source:"A", target:"B"},
      {source:"B", target:"C"},
      ])
    assert_equal({foo: "bar"}, @graph.layout())
  end
end
