class mysql::client inherits mysql::base {

    package {
        'mysql':
            ensure  => $system_mysql_version ? {
                ''      => installed,
                default => $system_mysql_version
            },
            require => Package['mysql-libs'];
    }
}

