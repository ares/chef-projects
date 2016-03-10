include_recipe "database::postgresql"

node.default['postgresql']['pg_hba'] << { :type => 'local', :db => 'all', :user => 'all', :addr => nil, :method => 'peer map=mymap' }
# mymap configuration ^
template '/var/lib/pgsql/data/pg_ident.conf' do
  source 'pg_ident.conf.erb'
  mode '0600'
  owner 'postgres'
  group 'postgres'
  notifies :restart, 'service[postgresql]', :delayed
end
