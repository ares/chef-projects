resource_name :rake_db_migrate

property :path, :kind_of => String, :name_property => true
property :user, :kind_of => String

default_action :migrate

action :migrate do
  execute "su - #{new_resource.user} -c 'cd #{new_resource.path}; rake db:migrate > #{new_resource.path}/log/init_migrate.log'" do
    not_if { ::File.exists?("#{new_resource.path}/log/init_migrate.log") }
  end
end
