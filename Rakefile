require 'rubygems'
require 'rubygems/package_task'
require 'rake/testtask'

$:.unshift File.join(File.dirname(__FILE__), 'lib')
require 'miniviz/version'


Rake::TestTask.new do |t|
  t.options = "-v"
  t.libs << "test"
  t.test_files = FileList["test/*_test.rb", "test/**/*_test.rb"]
end


task :console do
  sh "irb -I lib -r miniviz"
end

task :release do
  puts ""
  print "Are you sure you want to relase Sky #{Miniviz::VERSION}? [y/N] "
  exit unless STDIN.gets.index(/y/i) == 0
  
  unless `git branch` =~ /^\* master$/
    puts "You must be on the master branch to release!"
    exit!
  end
  
  # Build gem and upload
  sh "gem build miniviz.gemspec"
  sh "gem push miniviz-#{Miniviz::VERSION}.gem"
  sh "rm miniviz-#{Miniviz::VERSION}.gem"
  
  # Commit
  sh "git commit --allow-empty -a -m 'v#{Miniviz::VERSION}'"
  sh "git tag v#{Miniviz::VERSION}"
  sh "git push origin master"
  sh "git push origin v#{Miniviz::VERSION}"
end
