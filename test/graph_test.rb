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
    @graph.layout()
    IO.write("/tmp/miniviz.out.svg", @graph.to_svg())
    assert_equal({foo: "bar"}, @graph.to_hash)
  end
end
