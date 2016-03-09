include_recipe 'projects::setup_directories'

node.force_default[:selinux][:state] = 'disabled'
include_recipe 'selinux'
