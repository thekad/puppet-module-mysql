#!/usr/bin/env puppet
#
# -*- mode:puppet; sh-basic-offset:4; indent-tabs-mode:nil; coding:utf-8 -*-
# vim:set tabstop=4 softtabstop=4 expandtab shiftwidth=4 fileencoding=utf-8:
#

class mysql::server inherits mysql::client {

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

    @package {
        'mysql-server':
            ensure  => $mysql::params::install_version,
            tag     => 'mysql',
            require => [
                User['mysql'],
                File['/var/lib/mysql'],
                File['/var/log/mysql'],
                File['/etc/my.cnf'],
            ];
        'MariaDB-server':
            ensure  => $mysql::params::install_version,
            tag     => 'mariadb',
            require => [
                User['mysql'],
                File['/var/lib/mysql'],
                File['/var/log/mysql'],
                File['/etc/my.cnf'],
            ];
    }

    Package <| tag == $mysql::params::install_flavor |>

    @service {
        'mysqld':
            tag     => 'mysql',
            ensure  => $mysql::params::ensure_service,
            enable  => $mysql::params::enable_service,
            require => Package['mysql-server'];
        'mysql':
            tag     => 'mariadb',
            ensure  => $mysql::params::ensure_service,
            enable  => $mysql::params::enable_service,
            require => Package['MariaDB-server'];
    }

    Service <| tag == $mysql::params::install_flavor |>
}

