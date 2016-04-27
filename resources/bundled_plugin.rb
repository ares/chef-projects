resource_name :bundled_plugin

property :id, :kind_of => String, :name_property => true
property :plugin, :kind_of => Hash
property :main_project_path, :kind_of => String

default_action :install

action :install do
  github_project new_resource.plugin[:name] do
    path project_path(new_resource.plugin[:name])
    project_owner node[:user]
    user node[:user]
    maintain_upstream new_resource.plugin[:maintain_upstream]
  end

  template "#{new_resource.main_project_path}/bundler.d/Gemfile.#{new_resource.plugin[:name]}.local.rb" do
    owner node[:user]
    group node[:user]
    mode '0644'
    source 'gemfile.erb'
    cookbook 'projects'
    variables :gems => { new_resource.id => new_resource.plugin }
  end
end
