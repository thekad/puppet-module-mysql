class mysql::devel inherits mysql::base {

    package {
        'mysql-devel':
            ensure => $system_mysql_version ? {
                ''      => installed,
                default => $system_mysql_version
            };
            require => Package['mysql-libs'];
    }
}

