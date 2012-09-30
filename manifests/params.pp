#!/usr/bin/env puppet
#
# -*- mode:puppet; sh-basic-offset:4; indent-tabs-mode:nil; coding:utf-8 -*-
# vim:set tabstop=4 softtabstop=4 expandtab shiftwidth=4 fileencoding=utf-8:
#

class mysql::params {

    case $node_mysql_install_flavor {
        '', 'mysql': {
            $install_flavor = 'mysql'
        }
        'mariadb': {
            $install_flavor = 'mariadb'
        }
        'percona50': {
            $install_flavor = 'percona50'
        }
        'percona51': {
            $install_flavor = 'percona51'
        }
        'percona55': {
            $install_flavor = 'percona55'
        }
        'percona56': {
            $install_flavor = 'percona56'
        }
        default: {
            err('Wrong mysql flavor specified')
            fail('Wrong mysql flavor specified')
        }
    }

#   If you want to fix the version, define this at the node level
    $install_version = $node_mysql_install_version ? {
        ''      => 'installed',
        default => $node_mysql_install_version,
    }

#   If you want to use a different call, define this at the node level
    $exec_cmd = $node_mysql_exec_cmd ? {
        ''      => 'mysql -uroot -hlocalhost',
        default => $node_mysql_exec_cmd,
    }

    $enable_service = $node_mysql_enable_service ? {
        ''      => undef,
        default => $node_mysql_enable_service,
    }

    $ensure_service = $node_mysql_ensure_service ? {
        ''      => undef,
        default => $node_mysql_ensure_service,
    }
}
