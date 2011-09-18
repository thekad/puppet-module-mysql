# -*- mode: puppet; sh-basic-offset: 4; indent-tabs-mode: nil; coding: utf-8 -*-
# vim: tabstop=4 softtabstop=4 expandtab shiftwidth=4 fileencoding=utf-8

class mysql::base {

    package {
        'mysql-libs':
            ensure => $system_mysql_version ? {
                ''      => installed,
                default => $system_mysql_version
            };
        'mysql-test':
            ensure  => $system_mysql_version ? {
                ''      => installed,
                default => $system_mysql_version
            },
            require => Package['mysql-libs'];
    }
}

