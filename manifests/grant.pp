define mysql::grant($on, $user='', $password='', $ensure='present', $grant='USAGE', $host='localhost') {

    $username = $user ? {
        ''      => $name,
        default => $user,
    }

    $mysql_cmd = 'mysql -A -uroot -hlocalhost'

    $mysql_line = $password ? {
        ''      => shellquote("GRANT ${grant} ON ${on} TO '${username}'@'${host}';"),
        default => shellquote("GRANT ${grant} ON ${on} TO '${username}'@'${host}' IDENTIFIED BY '${password}';"),
    }

    exec {
        "mysql::grant::${title}":
            command   => "/bin/echo ${mysql_line} | ${mysql_cmd}",
            logoutput => on_failure;
    }
}

