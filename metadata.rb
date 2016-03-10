name             'projects'
maintainer       'Ares'
maintainer_email 'ar3s.cz@gmail.cz'
license          'All rights reserved'
description      'Installs/Configures my projects'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.4.1'

depends 'git'
depends	'user', '>= 0.1.0'
depends 'postgresql'
depends 'database'
depends 'selinux'

attribute 'projects',
          :display_name => 'Projects cookbook setup',
          :description => 'The hash containing global projects params as well as specific projects params',
          :type => 'hash',
          :required => 'recommended',
          :default => 'Marek Hulan'
