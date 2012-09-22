#!/usr/bin/env puppet
#
# -*- mode:puppet; sh-basic-offset:4; indent-tabs-mode:nil; coding:utf-8 -*-
# vim:set tabstop=4 softtabstop=4 expandtab shiftwidth=4 fileencoding=utf-8:
#

class mysql::params {

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
}
