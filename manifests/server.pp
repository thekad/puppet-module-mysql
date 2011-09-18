class mysql::server inherits mysql::base {

    include mysql::client

    group {
        'mysql':
            ensure => present;
    }

    user {
        'mysql':
            ensure     => present,
            gid        => 'mysql',
            comment    => 'MySQL System User',
            home       => '/var/lib/mysql',
            managehome => false,
            shell      => '/bin/false';
    }

    file {
        '/var/lib/mysql':
            ensure  => directory,
            owner   => 'mysql',
            group   => 'mysql',
            mode    => 0755,
            require => User['mysql'];
        '/var/log/mysql':
            ensure  => directory,
            owner   => 'mysql',
            group   => 'mysql',
            mode    => 0755,
            require => User['mysql'];
        '/etc/mysql':
            ensure  => directory,
            mode    => 0775;
        '/etc/my.cnf':
            content => template('mysql/my.cnf.erb');
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

