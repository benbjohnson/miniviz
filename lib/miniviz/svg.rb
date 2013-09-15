class Miniviz
  class Svg
    # Converts a value from points to pixels.
    def self.pt2px(value)
      return nil if value.nil?
      return value.to_f * PT2PX
    end

    # Normalizes a series of path points.
    def self.d(graph, value)
      value = value.gsub(/\s*([-0-9.]+)([, ]+)([-0-9.]+)\s*/) do
        x, sep, y = ($1.to_f * PT2PX), $2, graph.invert_y(($3.to_f * PT2PX))
        " #{(x+(PADDING * PT2PX)).round(3)}#{sep}#{(y+(PADDING * PT2PX)).round(3)} "
      end
      return value.squeeze(" ").strip
    end

    # Normalizes the x and y attributes on an SVG node.
    def self.xy(graph, element)
      return nil, nil if element.nil?
      x = ((element["x"].to_f+PADDING) * PT2PX).round(3)
      y = graph.invert_y((element["y"].to_f+PADDING) * PT2PX).round(3)
      return x, y
    end

    # Normalizes the coordinates and size of the ellipse.
    def self.ellipse(graph, element)
      return nil, nil, nil, nil if element.nil?
      cx = ((element["cx"].to_f+PADDING) * PT2PX).round(3)
      cy = graph.invert_y((element["cy"].to_f+PADDING) * PT2PX).round(3)
      rx = (element["rx"].to_f * PT2PX).round(3)
      ry = (element["ry"].to_f * PT2PX).round(3)
      return cx - rx, cy - ry, rx * 2, ry * 2
    end

    # Normalizes a series of polygon points into a bounding box.
    def self.points_to_rect(graph, value)
      x1, y1, x2, y2 = nil, nil, nil, nil
      value.scan(/([-0-9.]+)[, ]+([-0-9.]+)/).each do |x, y|
        x, y = x.to_f * PT2PX, graph.invert_y(y.to_f * PT2PX)
        x1 = x if x1.nil? || x < x1
        y1 = y if y1.nil? || y < y1
        x2 = x if x2.nil? || x > x2
        y2 = y if y2.nil? || y > y2
      end
      return (x1+(PADDING * PT2PX)).round(3), (y1+(PADDING * PT2PX)).round(3), (x2-x1).round(3), (y2-y1).round(3)
    end
  end
end
