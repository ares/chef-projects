include_recipe "postgresql"
include_recipe "postgresql::client"
include_recipe "postgresql::server"
include_recipe "postgresql::ruby"
include_recipe "database::postgresql"
chef_gem 'pg'

service 'postgresql' do
  action :nothing
end

# workaround https://github.com/hw-cookbooks/postgresql/issues/340
node.force_override[:postgresql][:dir] = '/var/lib/pgsql/data'

# postgres 8.4-9.0 (el6) does not support peer map
if !node.platform_family?('centos', 'rhel') || node[:platform_version].to_i > 6
  node.default['postgresql']['pg_hba'] << { :type => 'local', :db => 'all', :user => 'all', :addr => nil, :method => 'peer map=mymap' }
  # mymap configuration ^
  template '/var/lib/pgsql/data/pg_ident.conf' do
    source 'pg_ident.conf.erb'
    mode '0600'
    owner 'postgres'
    group 'postgres'
    notifies :restart, 'service[postgresql]', :delayed
  end
end

