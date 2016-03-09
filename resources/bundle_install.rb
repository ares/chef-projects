resource_name :bundle_install

property :path, :kind_of => String, :name_property => true
property :user, :kind_of => String

default_action :install

action :install do
  execute "su - #{new_resource.user} -c 'cd #{new_resource.path}; bundle install'" do
    cwd path
    not_if "su - #{new_resource.user} -c 'cd #{new_resource.path}; bundle check'"
  end
end
