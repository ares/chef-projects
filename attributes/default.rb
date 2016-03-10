default[:projects][:root] = "/home/#{node[:user]}/Projekty/Zdrojaky/"

default[:rbenv][:user_installs] = [
  :user => node[:user],
  :rubies => [ '2.2.2' ],
  :global => '2.2.2',
  :upgrade => 'sync',
  :gems => {
    '2.2.2' => [ { :name => 'bundler' } ]
  }
]
default[:ruby_build][:upgrade] = 'sync'
