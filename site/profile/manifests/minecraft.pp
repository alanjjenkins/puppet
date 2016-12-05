class profile::minecraft {
    class {'docker':
        version => 'latest',
        docker_users => ['alan'],
    } ->
    user { 'minecraft':
        ensure => present,
        system => true,
    } ->
    file { '/home/minecraft':
        ensure => directory,
        owner => 'minecraft',
        group => 'minecraft',
        mode => '0700'
    } ->
    file { '/srv/minecraft/':
        ensure => directory,
        owner => 'minecraft',
        group => 'minecraft',
        mode => '0775',
    } ->
    file { '/srv/minecraft/direwolf20':
        ensure => directory,
        owner => 'minecraft',
        group => 'minecraft',
        mode => '0775',
    } ->
    file { '/srv/minecraft/direwolf20/world':
        ensure => directory,
        owner => 'minecraft',
        group => 'minecraft',
        mode => '0775',
    } ->
    file { '/srv/minecraft/direwolf20/logs':
        ensure => directory,
        owner => 'minecraft',
        group => 'minecraft',
        mode => '0775',
    } ->
    file { '/srv/minecraft/direwolf20/crash-reports':
        ensure => directory,
        owner => 'minecraft',
        group => 'minecraft',
        mode => '0775',
    } ->
    file { '/srv/minecraft/direwolf20/config/':
        ensure => directory,
        owner => 'minecraft',
        group => 'minecraft',
        mode => '0775',
    } ->
    file { '/srv/minecraft/direwolf20/config.override/':
        ensure => directory,
        owner => 'minecraft',
        group => 'minecraft',
        mode => '0775',
    } ->
    file { '/srv/minecraft/direwolf20/mods.override/':
        ensure => directory,
        owner => 'minecraft',
        group => 'minecraft',
        mode => '0775',
    } ->
    file { '/srv/minecraft/direwolf20/backups/':
        ensure => directory,
        owner => 'minecraft',
        group => 'minecraft',
        mode => '0775',
    } ->
    file { '/srv/minecraft/direwolf20/config/JourneyMapServer':
        ensure => directory,
        owner => 'minecraft',
        group => 'minecraft',
        mode => '0775',
    } ->
    file { '/srv/minecraft/direwolf20/banned-ips.json':
        ensure => file,
        owner => 'minecraft',
        group => 'minecraft',
        mode => '0775',
    } ->
    file { '/srv/minecraft/direwolf20/banned-players.json':
        ensure => file,
        owner => 'minecraft',
        group => 'minecraft',
        mode => '0775',
    } ->
    file { '/srv/minecraft/direwolf20/ops.json':
        ensure => file,
        owner => 'minecraft',
        group => 'minecraft',
        mode => '0775',
    } ->
    file { '/srv/minecraft/direwolf20/usercache.json':
        ensure => file,
        owner => 'minecraft',
        group => 'minecraft',
        mode => '0775',
    } ->
    file { '/srv/minecraft/direwolf20/whitelist.json':
        ensure => file,
        owner => 'minecraft',
        group => 'minecraft',
        mode => '0775',
    } ->
    file { '/srv/minecraft/direwolf20/server.properties':
        ensure => file,
        owner => 'minecraft',
        group => 'minecraft',
        mode => '0775',
    }->
    file {'/usr/lib/systemd/system/direwolf20.service':
        ensure => file,
        owner  => 'root',
        group  => 'root',
        source => "https://raw.githubusercontent.com/demon012/docker-minecraft-direwolf20/master/direwolf20.service",
        notify => Exec['systemctl-daemon-reload'],
    } ->
    service { 'direwolf20':
        ensure => running,
        enable  => true,
        hasrestart => false,
        hasstatus => false,
    }
}
