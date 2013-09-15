require 'test_helper'

class TestGraph < MiniTest::Unit::TestCase
  def setup
    @graph = Miniviz::Graph.new()
  end

  def test_layout
    @graph.add_nodes([
      {
        id:"A",
        label:"My Cluster",
        nodes:[
          {id:"A1", shape:"point"},
          {id:"A2"},
          {
            id:"A3",
            label:"Subcluster",
            nodes:[
              {id:"A3.1"},
              {id:"A3.2"},
            ]
          }
        ]
      },
      {id:"B"},
      {id:"C"},
      ])
    @graph.add_edges([
      {source:"A2", target:"A1", label:"REALLY LONG LABEL!", weight:10},
      {source:"A3.2", target:"A1", penwidth:10, weight:10},
      {source:"A1", target:"B"},
      {source:"B", target:"C"},
      ])
    @graph.rankdir = "LR"
    @graph.fontsize = 20
    @graph.layout()
    IO.write("/tmp/miniviz.out.svg", @graph.to_svg())
    assert_equal({foo: "bar"}, @graph.to_hash)
  end
end
