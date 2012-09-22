#!/usr/bin/env puppet
#
# -*- mode:puppet; sh-basic-offset:4; indent-tabs-mode:nil; coding:utf-8 -*-
# vim:set tabstop=4 softtabstop=4 expandtab shiftwidth=4 fileencoding=utf-8:
#

define mysql::user($user='', $host='localhost', $password='', $ensure='present') {

    $username = $user ? {
        ''      => $name,
        default => $user,
    }

    case $ensure {
        'present': {
            $mysql_line = shellquote("CREATE USER '${username}'@'${host}';")
        }
        /(absent|purged)/: {
            $mysql_line = shellquote("DROP USER '${username}'@'$host';")
        }
        default: {
            err("Invalid value for ensure: ${ensure}. Valid values: present, absent, purged")
            fail('Invalid value for ensure')
        }
    }

    $mysql_check = shellquote("SHOW GRANTS FOR '${username}'@'${host}';")

    exec {
        "mysql::user::${username}@${host}::${ensure}":
            command   => "echo '${mysql_line}' | ${mysql::params::exec_cmd}",
            logoutput => on_failure,
            unless    => $ensure ? {
                'present' => "echo '${mysql_check}' | ${mysql::params::exec_cmd}",
                default   => undef,
            },
            onlyif    => $ensure ? {
                /(absent|purged)/ => "echo '${mysql_check}' | ${mysql::params::exec_cmd}",
                default           => undef,
            };
    }

    if $ensure == 'present' and $password != '' {
        $mysql_pass = shellquote("SET PASSWORD FOR '${username}'@'${host}' = PASSWORD('${password}')")
        $mysql_check_pass = shellquote("SELECT COUNT(user) FROM user WHERE user = '${username}' \
            AND host = '${host}' AND password = PASSWORD('${password}');")

        exec {
            "mysql::user::${username}@${host}::password":
                command   => "echo '${mysql_pass}' | ${mysql::params::exec_cmd} mysql",
                logoutput => on_failure,
                onlyif    => "[ 0 -eq $( echo '${mysql_check_pass}' | ${mysql::params::exec_cmd} mysql | tail -1 ) ]",
                require   => Exec["mysql::user::${username}@${host}::${ensure}"];
        }
    }
}

