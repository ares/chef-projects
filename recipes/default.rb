include_recipe 'projects::setup_directories'
include_recipe 'ruby_build'
include_recipe 'rbenv::user'

node.force_default[:selinux][:state] = 'disabled'
include_recipe 'selinux'
