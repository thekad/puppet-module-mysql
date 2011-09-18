class mysql::base {

    package {
        'mysql-libs':
            ensure => $system_mysql_version ? {
                ''      => installed,
                default => $system_mysql_version
            };
        'mysql-test':
            ensure => $system_mysql_version ? {
                ''      => installed,
                default => $system_mysql_version
            },
            require => Package['mysql-libs'];
    }
}

