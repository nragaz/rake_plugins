module RakePlugins
  class Railtie < Rails::Railtie
    rake_tasks do
      load File.expand_path("../tasks/plugins.rake", __FILE__)
    end
  end
end