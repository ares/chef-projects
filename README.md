projects Cookbook
=================

By default this cookbook only disables SELinux and setup directory structure for other projects_* cookbooks.
It provides many useful helpers to install apps from git. It can also be used to install postgres DB.

It also disables selinux, therefore you should not use it in production environment!

Attributes
----------

### projects root

this is the root for all project paths (see project_path helper)

default value requires user cookbook that defines node[:user] attributes,
but you can change it to whatever you prefer

    default[:projects][:root] = "/home/#{node[:user]}/Projekty/Zdrojaky/"

note that node[:user] must be present for postgres configuration (this user will be granted
access)

Usage
-----
#### projects::default

Just include `projects` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[projects]"
  ]
}
```

To install postgres, you can do it from you cookbook like this

    include_recipe 'projects::setup_postgres'

or add it to runlist similar to example above.

## Helpers

There are helpers that you can use globally in your recipes

    # let's say attribute [:projects][:root] is set to /install 
    project_path('foreman') # => "/install/foreman"  

    # project_attributes('smart-proxy', { :custom => 'option' }) # => returns an array for 
    # constructing hash like this
    [ 
      'smart_proxy',                                             # converts dash to underscore
      {
        :gem_name => "smart-proxy",
        :name => "smart-proxy",
        :path => "/install/smart-proxy",                         # uses project_path("smart_proxy")
        :custom => 'option'
      }
    ]

## Custom resources


### github_project

To clone a project from github you can use *github_project* resource. It will clone it using
https://github.com/$project_owner/$name url but it will change it to use git@github.com:$project_owner/$name
afterwards so you can easily push back. It will also setup remote with name upstream (theforeman) by default.
It can be customized by *upstream* property. Therefore you could easily do *git pull upstream master* later
to keep in sync. If you set *maintain_upstream* property to true it will add second clone, this time
of the upstream repository. It will also change it's url to use SSH. This is useful if you also have
write permissions on upstream project. Note that it will be created in specified path named with
'_upstream' suffix (e.g. /install/foreman_upstream).

    github_project 'foreman' do
      path project_path('foreman')
      project_owner 'ares'
      user 'root'
      branch 'develop'
    end

### bundle_install

This resource will run bundle install under specified user in specified path. It will skip the run if
bundle check says that nothing needs to be updated.

    bundle_install project_path('foreman') do
      user 'ares' # or node[:user] if you use user cookbook
    end

### rake_db_migrate

This resource will run db migrations under specified user in specified path. It will skip the run if
there's a file $path/log/init_migrate.log present. This means migrations are usually run only once during
first run. To rerun migrations you can simply delete this file.

    rake_db_migrate project_path('foreman') do
      user 'ares'
    end

### rake_db_seed

This resource will run db seed rake task under specified user in specified path. It will skip the run if
there's a file $path/log/init_seed.log present. This means seed is usually run only once during
first run. To rerun seed you can simply delete this file. This resource can also set ENV variables
that might be used in this seed task.

    rake_db_seed project_path('foreman') do
      user node[:user]
      env({ :SEED_ADMIN_PASSWORD => 'changeme' })
    end

### bundled_plugin

This resource allows you to simply add other subprojects installed from git into your bundle if your
Gemfile includes gemfiles from $path/bundler.d/. It will use github_project resource to install
the plugin from git and then create a Gemfile for it.

    bundled_plugin 'foreman_chef' do
      plugin project_attributes('foreman_chef') 
      main_project_path project_path('foreman')
    end
