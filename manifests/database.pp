# -*- mode: puppet; sh-basic-offset: 4; indent-tabs-mode: nil; coding: utf-8 -*-
# vim: tabstop=4 softtabstop=4 expandtab shiftwidth=4 fileencoding=utf-8

define mysql::database($db='', $ensure='present') {

    $database = $db ? {
        ''      => $name,
        default => $db,
    }

    $mysql_cmd = 'mysql -A -uroot -hlocalhost'
    $mysql_check = "USE '${database}'"

    case $ensure {
        'present': {
            $mysql_line = shellquote("CREATE DATABASE IF NOT EXISTS ${database};")
        }
        /(absent|purged)/: {
            $mysql_line = shellquote("DROP DATABASE IF EXISTS ${database};")
        }
        default: {
            err("Invalid value for ensure: ${ensure}. Valid values: present, absent, purged")
            fail('Invalid value for ensure')
        }
    }

    exec {
        "mysql::database::${database}::${ensure}":
            command   => "/bin/echo ${mysql_line} | ${mysql_cmd}",
            logoutput => on_failure,
            unless    => $ensure ? {
                'present' => "/bin/echo ${mysql_check} | ${mysql_cmd}",
                default   => undef,
            },
            onlyif    => $ensure ? {
                /(purged|absent)/ => "/bin/echo ${mysql_check} | ${mysql_cmd}",
                default           => undef,
            };
    }
}

