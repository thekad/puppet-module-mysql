class mysql::client inherits mysql::libs {

    package {
        'mysql-client':
            ensure => $system_mysql_version ? {
                ''      => installed,
                default => $system_mysql_version
            };
            require => Package['mysql-libs'];
    }
}

