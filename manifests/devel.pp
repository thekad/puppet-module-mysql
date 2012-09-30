#!/usr/bin/env puppet
#
# -*- mode:puppet; sh-basic-offset:4; indent-tabs-mode:nil; coding:utf-8 -*-
# vim:set tabstop=4 softtabstop=4 expandtab shiftwidth=4 fileencoding=utf-8:
#

class mysql::devel inherits mysql::base {

    @package {
        'mysql-devel':
            tag     => 'mysql',
            require => Package['mysql-libs'],
            ensure  => $mysql::params::install_version;
        'MariaDB-devel':
            tag     => 'mariadb',
            require => Package['MariaDB-common'],
            ensure  => $mysql::params::install_version;
    }

    Package <| tag == $mysql::params::install_flavor |>
}

