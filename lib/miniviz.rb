require 'nokogiri'
require 'graphviz'

class Miniviz
  PT2PX = 96.0 / 72.0
  PADDING = 4

  class Error < StandardError; end

  def self.symbolize_keys!(hash)
    if hash.is_a?(Hash)
      hash.keys.each do |key|
        hash[(key.to_sym rescue key) || key] = hash.delete(key)
      end
    end
    hash
  end
end

require 'miniviz/graph'
require 'miniviz/node'
require 'miniviz/edge'
require 'miniviz/svg'
require 'miniviz/version'
