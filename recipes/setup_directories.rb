directory node[:projects][:root] do
  owner node[:user]
  group node[:user]
  recursive true
end

link "/home/#{node[:user]}/z" do
  to node[:projects][:root]
end
