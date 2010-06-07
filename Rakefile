namespace :gem do
  desc "Build the gem"
  task :build => :cleanup do
    system "gem build rake_plugins.gemspec"
  end
  
  desc "Install the gem"
  task :install => :build do
    system "gem install -l rake_plugins-*.gem"
  end
  
  desc "Remove built gems"
  task :cleanup do
    system "rm rake_plugins-*.gem"
  end
end