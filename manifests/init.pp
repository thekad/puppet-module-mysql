#!/usr/bin/env puppet
#
# -*- mode:puppet; sh-basic-offset:4; indent-tabs-mode:nil; coding:utf-8 -*-
# vim:set tabstop=4 softtabstop=4 expandtab shiftwidth=4 fileencoding=utf-8:
#

class mysql::base {

    include mysql::params

    @package {
        'mysql-libs':
            tag     => 'mysql',
            ensure  => $mysql::params::install_version;
        'MariaDB-common':
            tag     => 'mariadb',
            ensure  => $mysql::params::install_version;
        'MariaDB-shared':
            tag     => 'mariadb',
            require => Package['MariaDB-common'],
            ensure  => $mysql::params::install_version;
        'MariaDB-compat':
            tag     => 'mariadb',
            require => Package['MariaDB-common'],
            ensure  => $mysql::params::install_version;
    }

    Package <| tag == $mysql::params::install_flavor |>
}
