#!/usr/bin/env puppet
#
# -*- mode:puppet; sh-basic-offset:4; indent-tabs-mode:nil; coding:utf-8 -*-
# vim:set tabstop=4 softtabstop=4 expandtab shiftwidth=4 fileencoding=utf-8:
#

class mysql::base {

    package {
        'mysql-libs':
            ensure => $mysql::params::install_version,
        'mysql-test':
            ensure => $mysql::params::install_version,
            require => Package['mysql-libs'];
    }
}

