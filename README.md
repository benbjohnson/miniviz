miniviz
=======

> A simplified interface to GraphViz for laying out clusters, nodes and edges.


## Overview

GraphViz is an awesome tool.
It makes amazing graph layouts given just nodes, edges and clusters.
Unfortunately, there are several reasons why it's output is unusable for modern UIs:

1. The unit of measure is in points and inches instead of pixels.

2. A traditional cartesian coordinate system is used (instead of an inverted-y system like most UIs use).

3. GraphViz has its own `dot` language which is not easy for newcomers.


## How is Miniviz Different?

Miniviz tries to simplify a common use case of wanting to layout a list of nodes and a list of edges and return coordinate information.
Coordinate information is returned as standard "x" and "y" in pixels with y incremented as it moves down the screen.
Miniviz also gives a simple interface of using basic hashes for inputing nodes and edges.


## Usage

To use Miniviz, you can take some nodes and edges and create a graph with them like this:

```ruby
nodes = [
  {id:"A"},
  {id:"B"},
  {id:"C"}
]

edges = [
  {source:"A", target:"B"},
  {source:"B", target:"C"},
]

graph = Miniviz::Graph.new(nodes:nodes, edges:edges)

# Output to normalized JSON or Hash
graph.to_json()  # => "{\"nodes\":[{\"id\":\"A\",\"x\":20,\"y\":30}, ...], \"edges\":[...]}"

# Output to normalized SVG.
graph.to_svg()
```

Now you can use Graphviz positional data for your D3.js visualizations or whatever you can think of.
