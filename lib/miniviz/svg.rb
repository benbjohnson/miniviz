class Miniviz
  class Svg
    # Normalizes a series of path points.
    def self.d(graph, value)
      value = value.gsub(/\s*([-0-9.]+)([, ]+)([-0-9.]+)\s*/) do
        x, sep, y = $1.to_f, $2, graph.invert_y($3.to_f)
        " #{x+PADDING}#{sep}#{y+PADDING} "
      end
      return value.squeeze(" ").strip
    end

    # Normalizes a series of polygon points into a bounding box.
    def self.points_to_rect(graph, value)
      x1, y1, x2, y2 = nil, nil, nil, nil
      value.scan(/([-0-9.]+)[, ]+([-0-9.]+)/).each do |x, y|
        x, y = x.to_f, graph.invert_y(y.to_f)
        x1 = x if x1.nil? || x < x1
        y1 = y if y1.nil? || y < y1
        x2 = x if x2.nil? || x > x2
        y2 = y if y2.nil? || y > y2
      end
      return (x1+PADDING), (y1+PADDING), (x2-x1), (y2-y1)
    end
  end
end