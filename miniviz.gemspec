$:.push File.expand_path("../lib", __FILE__)

require "miniviz/version"

Gem::Specification.new do |s|
  s.name        = "miniviz"
  s.version     = Miniviz::VERSION
  s.authors     = ["Ben Johnson"]
  s.email       = ["benbjohnson@yahoo.com"]
  s.homepage    = "https://github.com/benbjohnson/miniviz"
  s.summary     = "A simplified interface to GraphViz for laying out clusters, nodes and edges."
  s.description = "A simplified interface to GraphViz for laying out clusters, nodes and edges."

  s.add_dependency('ruby-graphviz', '~> 1.0')
  s.add_dependency('nokogiri', '~> 1.6')

  s.files = Dir["lib/**/*"] + ["LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]
  s.require_path = 'lib'
end
