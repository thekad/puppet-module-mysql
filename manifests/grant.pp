#!/usr/bin/env puppet
#
# -*- mode:puppet; sh-basic-offset:4; indent-tabs-mode:nil; coding:utf-8 -*-
# vim:set tabstop=4 softtabstop=4 expandtab shiftwidth=4 fileencoding=utf-8:
#

define mysql::grant($on, $user='', $password='', $ensure='present', $grant='USAGE', $host='localhost') {

    $username = $user ? {
        ''      => $name,
        default => $user,
    }

    $mysql_line = $password ? {
        ''      => shellquote("GRANT ${grant} ON ${on} TO '${username}'@'${host}';"),
        default => shellquote("GRANT ${grant} ON ${on} TO '${username}'@'${host}' IDENTIFIED BY '${password}';"),
    }

    exec {
        "mysql::grant::${title}":
            command   => "echo ${mysql_line} | ${mysql::params::exec_cmd}",
            logoutput => on_failure;
    }
}
