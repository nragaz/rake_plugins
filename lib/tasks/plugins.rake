require 'YAML'

namespace :plugin do
  desc "Install a plugin"
  task :install, :source do |t, args|
    current_plugins = Dir["vendor/plugins/*"]
    system "bundle exec rails plugin install #{args.source} -f"
    installed = (current_plugins - Dir["vendor/plugins/*"]).first
    raise "Plugin could not be installed from #{args.source}" unless installed
    name = File.basename(installed)
    installed_plugins = File.exist?("vendor/plugins/installed.yml") ? YAML.load("vendor/plugins/installed.yml") : []
    installed_plugins[name] = args.source
    File.open('vendor/plugins/installed.yml', 'w') { |f| YAML.dump(installed_plugins, f) }
    p "Installed plugin #{name} from #{args.source}\n"
  end
  
  desc "Update an installed plugin"
  task :update, :name do |t, args|
    installed_plugins = File.exist?("vendor/plugins/installed.yml") ? YAML.parse_file("vendor/plugins/installed.yml") : []
    raise "Plugin #{args.name} is not installed" unless installed_plugins.has_key?(args.name)
    system "bundle exec rails plugin install #{installed_plugins[args.name]} -f"
    p "Updated plugin #{args.name} from #{installed_plugins[args.name]}\n"
  end

  desc "List installed plugins"
  task :list do
    installed_plugins = File.exist?("vendor/plugins/installed.yml") ? YAML.parse_file("vendor/plugins/installed.yml") : []
    p "No plugins installed\n" if installed_plugins.empty?
    installed_plugins.each { |name, source| p " * #{name} (#{source})\n" }
    unmanaged_plugins = Dir["vendor/plugins/*"].map { |path| File.basename(path) } - installed_plugins.keys
    p "\nThe following plugins are not being managed: #{unmanaged_plugins.join(", ")}" if unmanaged_plugins.any?
  end
  
  desc "Update installed plugins"
  task :update_all do
    installed_plugins = File.exist?("vendor/plugins/installed.yml") ? YAML.parse_file("vendor/plugins/installed.yml") : []
    p "No plugins to update\n" if installed_plugins.empty?
    installed_plugins.each do |name, source|
      p "Updating plugin #{name} from #{source}...\n"
      system "bundle exec rails plugin install #{source} -f"
    end
    unmanaged_plugins = Dir["vendor/plugins/*"].map { |path| File.basename(path) } - installed_plugins.keys
    p "\nThe following plugins are not being managed: #{unmanaged_plugins.join(", ")}" if unmanaged_plugins.any?
  end
end