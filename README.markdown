Overview
========

Module to manage mysql server and client setups. Also
manages several mysql-specific objects as puppet resources:

* databases
* users
* grants

Currently tested only in Fedora. Should work without many 
(if at all) modifications with CentOS and RedHat

Defines should work without problems with almost any distro
as long as it has mysql client installed


Install
-------

Install in `<module_path>/mysql`


Mysql::Database
---------------

Example usage:

    mysql::database {
        'test':
            ensure => absent;
        'catalog':
            ensure => present;
    }


Mysql::User
-----------

Example usage:

    mysql::user {
        'maint':
            ensure   => present,
            host     => 'localhost',
            password => 'youzderf';
        'test':
            ensure   => absent,
            host     => '%';
        'read':
            ensure   => present,
            host     => '%',
            password => 'readonly';
        'write::local':
            user     => 'write',
            ensure   => present,
            host     => 'localhost',
            password => 'locality';
        'write::remote':
            user     => 'write',
            ensure   => present,
            host     => '%',
            password => 'remotely';
    }


Mysql::Grant
------------

Example usage:

    mysql::user {
        'backups':
            ensure => present;
    }

    mysql::grant {
        'backups':
            ensure  => present,
            grant   => 'SELECT, LOCK TABLES',
            on      => '*.*',
            host    => 'backups.company.com',
            require => Mysql::User['backups'];
        'rogue':
            ensure   => present,
            grant    => 'INSERT, UPDATE, DELETE',
            on       => 'scratch.*',
            host     => '%',
            password => 'moulin';
    }


Disclaimer
==========

This program is free software. It comes without any warranty, to
the extent permitted by applicable law. You can redistribute it
and/or modify it under the terms of the MIT License. For more
details see the LICENSE file or <http://www.opensource.org/licenses/mit-license.php>

