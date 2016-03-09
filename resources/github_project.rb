resource_name :github_project

property :name, :kind_of => String, :name_property => true
property :path, :kind_of => String
property :upstream, :kind_of => String, :default => 'theforeman'
property :user, :kind_of => String
property :project_owner, :kind_of => String
property :branch, :kind_of => String, :default => 'master'
property :maintain_upstream, :kind_of => [ FalseClass, TrueClass ], :default => false

default_action :create

action :create do
  git new_resource.path do
    action :checkout
    repository "https://github.com/#{new_resource.project_owner}/#{new_resource.name}"
    reference new_resource.branch
    enable_checkout false
    group new_resource.user
    user new_resource.user
    additional_remotes({ :upstream => "https://github.com/#{new_resource.upstream}/#{new_resource.name}" })
    notifies :run, "script[set_ssh_#{new_resource.name}]", :immediately
  end

  path = new_resource.path
  script "set_ssh_#{new_resource.name}" do
    interpreter 'bash'
    action :nothing
    cwd "#{path}/.git"
    code "sed -i s#https://github.com/#{new_resource.project_owner}#ssh://git@github.com/#{new_resource.project_owner}# #{path}/.git/config"
  end

  if new_resource.maintain_upstream
    git new_resource.path + '_upstream' do
      action :checkout
      repository "https://github.com/#{new_resource.upstream}/#{new_resource.name}"
      reference new_resource.branch
      enable_checkout false
      group new_resource.user
      user new_resource.user
      additional_remotes({ :ares => "https://github.com/#{new_resource.project_owner}/#{new_resource.name}" })
      notifies :run, "script[set_ssh_#{new_resource.name}_upstream]", :immediately
    end

    script "set_ssh_#{new_resource.name}_upstream" do
      interpreter 'bash'
      action :nothing
      cwd "#{path}_upstream/.git"
      code "sed -i s#https://github.com/#{new_resource.upstream}#ssh://git@github.com/#{new_resource.upstream}# #{path}_upstream/.git/config"
    end
  end
end

action :delete do
  directory project_path(new_resource.name) do
    action :delete
    recursive true
  end
end
