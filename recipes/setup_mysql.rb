mysql2_chef_gem 'default' do
  action :install
end

mysql_service 'default' do
  port '3306'
  initial_root_password 'changeme'
  action [:create, :start]
end
