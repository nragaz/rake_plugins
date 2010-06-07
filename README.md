rake_plugins
============

Simple Rails plugin management using Rake.

Usage
-----

In your Gemfile:

    gem "rake_plugins", :git => "git://github.com/nragaz/rake_plugins.git"

Adds the following Rake tasks:

    plugin:list
    plugin:install[<source>]
    plugin:update[<name>]
    plugin:update_all
    plugin:remove[<name>]
    
Installed plugins and their sources are tracked in <tt>vendor/installed_plugins.yml</tt>.

You can also copy <tt>installed_plugins.yml</tt> from one app to another and then run <tt>plugin:update_all</tt>. Or, don't check in <tt>vendor/plugins</tt> -- just run <tt>plugin:update_all</tt> after deploy.