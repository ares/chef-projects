resource_name :rake_db_seed

property :path, :kind_of => String, :name_property => true
property :user, :kind_of => String
property :env, :kind_of => Hash

default_action :seed

action :seed do
  if new_resource.env.empty?
    env = ''
  else
    env = new_resource.env.map { |key, value| "export #{key.upcase}=#{value};"}.join(' ')
  end

  execute "su - #{new_resource.user} -c '#{env} cd #{new_resource.path}; rake db:seed > #{new_resource.path}/log/init_seed.log'" do
    not_if { ::File.exists?("#{new_resource.path}/log/init_seed.log") }
  end
end
