class mysql::server inherits mysql::base {

    group {
        'mysql':
            ensure => present,
            system => true;
    }

    user {
        'mysql':
            ensure     => present,
            gid        => 'mysql',
            comment    => 'MySQL System User',
            home       => '/var/lib/mysql',
            managehome => false,
            shell      => '/bin/false',
            system     => true;
    }

    file {
        '/var/lib/mysql':
            ensure  => directory,
            owner   => 'mysql',
            group   => 'mysql',
            mode    => 07550,
            require => User['mysql'];
        '/var/log/mysql':
            ensure  => directory,
            owner   => 'mysql',
            group   => 'mysql',
            mode    => 07550,
            require => User['mysql'];
        '/etc/mysql':
            ensure  => directory,
            mode    => 0775;
        '/etc/my.cnf':
            content => template('modules/mysql/my.cnf.erb');
    }

    package {
        'mysql-server':
            ensure => $system_mysql_version ? {
                ''      => installed,
                default => $system_mysql_version
            },
            require => [
                Package['mysql-libs'],
                User['mysql'],
                File['/var/lib/mysql'],
                File['/var/log/mysql'],
                File['/etc/my.cnf'],
            ];
    }

    service {
        'mysqld':
            ensure  => running,
            require => Package['mysql-server'],
            enable  => true;
    }
}

