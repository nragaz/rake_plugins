require 'yaml'

namespace :plugin do
  desc "Install a plugin"
  task :install, :source do |t, args|
    name = File.basename(args.source).split('.').first
    raise "Plugin could not be installed from #{args.source}" unless system "bundle exec rails plugin install #{args.source} -f"
    
    installed_plugins = File.exist?("vendor/installed_plugins.yml") ?
                          File.open("vendor/installed_plugins.yml") { |f| YAML::load(f) } : {}
    installed_plugins[name] = args.source
    File.open('vendor/installed_plugins.yml', 'w') { |f| YAML.dump(installed_plugins, f) }
    
    puts "Installed plugin #{name} from #{args.source}\n"
  end
  
  desc "Update an installed plugin"
  task :update, :name do |t, args|
    installed_plugins = File.exist?("vendor/installed_plugins.yml") ? 
                          File.open("vendor/installed_plugins.yml") { |f| YAML::load(f) } : {}
    raise "Plugin #{args.name} is not installed" unless installed_plugins.has_key?(args.name)
    system "bundle exec rails plugin install #{installed_plugins[args.name]} -f"
    puts "Updated plugin #{args.name} from #{installed_plugins[args.name]}\n"
  end

  desc "List installed plugins"
  task :list do
    installed_plugins = File.exist?("vendor/installed_plugins.yml") ?
                          File.open("vendor/installed_plugins.yml") { |f| YAML::load(f) } : {}
    puts installed_plugins.any? ? "Installed plugins:\n\n" : "No plugins installed\n"
    installed_plugins.each { |name, source| puts " * #{name} (#{source})\n" }
    
    unmanaged_plugins = Dir["vendor/plugins/*"].map { |path| File.basename(path) } - installed_plugins.keys
    puts "\nThe following plugins are not being managed: #{unmanaged_plugins.join(", ")}\n" if unmanaged_plugins.any?
  end
  
  desc "Update installed plugins"
  task :update_all do
    installed_plugins = File.exist?("vendor/installed_plugins.yml") ?
                          File.open("vendor/installed_plugins.yml") { |f| YAML::load(f) } : {}
    puts "No plugins to update\n" if installed_plugins.empty?
    installed_plugins.each do |name, source|
      puts "Updating plugin #{name} from #{source}...\n"
      system "bundle exec rails plugin install #{source} -f"
    end

    unmanaged_plugins = Dir["vendor/plugins/*"].map { |path| File.basename(path) } - installed_plugins.keys
    puts "\nThe following plugins are not being managed: #{unmanaged_plugins.join(", ")}\n" if unmanaged_plugins.any?
  end
  
  desc "Remove installed plugin"
  task :remove, :name do |t, args|
    installed_plugins = File.exist?("vendor/installed_plugins.yml") ?
                          File.open("vendor/installed_plugins.yml") { |f| YAML::load(f) } : {}
    raise "Plugin #{args.name} is not installed" unless installed_plugins.has_key?(args.name)
    if system("bundle exec rails plugin remove #{args.name}")
      installed_plugins.delete(args.name)
      File.open('vendor/installed_plugins.yml', 'w') { |f| YAML.dump(installed_plugins, f) }
      puts "Plugin #{args.name} removed\n"
    else
      "Plugin #{args.name} could not be removed\n"
    end
  end
end