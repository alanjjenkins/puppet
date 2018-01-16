class profile::minecraft_sprout (
    String $aws_id,
    String $aws_key,
    String $backup_bucket_path,
    String $backup_retention,
    String $minecraft_uid = '995',
    String $minecraft_gid = '994',
    Array $dirs = [
        '/home/minecraft',
        '/home/minecraft/sprout',
        '/home/minecraft/sprout/backups/',
        '/home/minecraft/sprout/config.override/',
        '/home/minecraft/sprout/config/',
        '/home/minecraft/sprout/config/JourneyMapServer',
        '/home/minecraft/sprout/crash-reports',
        '/home/minecraft/sprout/logs',
        '/home/minecraft/sprout/mods.override/',
        '/home/minecraft/sprout/world',
    ],
    Array $files = [
        '/home/minecraft/sprout/banned-ips.json',
        '/home/minecraft/sprout/banned-players.json',
        '/home/minecraft/sprout/ops.json',
        '/home/minecraft/sprout/server.properties',
        '/home/minecraft/sprout/usercache.json',
        '/home/minecraft/sprout/whitelist.json',
    ],
    String $world_path = '/home/minecraft/sprout/world',
    String $container_name = 'sprout',
    String $image_name = 'sprout',
    String $max_ram = '8192',
    String $minecraft_user_home = '/home/minecraft',
)
{
    include 'docker'

    group { 'minecraft':
        ensure => present,
        gid    => $minecraft_gid,
    }

    user { 'minecraft':
        ensure  => present,
        uid     => $minecraft_uid,
        system  => true,
        home    => $minecraft_user_home,
        require => Group['minecraft']
    }

    file { $dirs:
        ensure  => directory,
        owner   => 'minecraft',
        group   => 'minecraft',
        mode    => '0700',
        recurse => true,
        require => [
            User['minecraft'],
            Group['minecraft'],
        ]

    }

    file { $files:
        ensure  => file,
        force   => true,
        owner   => 'minecraft',
        group   => 'minecraft',
        mode    => '0700',
        require => [
            User['minecraft'],
            Group['minecraft'],
        ]
    }

    $sprout_vols = [
        '/home/minecraft/sprout/world:/home/minecraft/world',
        '/home/minecraft/sprout/banned-ips.json:/home/minecraft/banned-ips.json',
        '/home/minecraft/sprout/banned-players.json:/home/minecraft/banned-players.json',
        '/home/minecraft/sprout/logs:/home/minecraft/logs',
        '/home/minecraft/sprout/crash-reports:/home/minecraft/crash-reports',
        '/home/minecraft/sprout/ops.json:/home/minecraft/ops.json',
        '/home/minecraft/sprout/usercache.json:/home/minecraft/usercache.json',
        '/home/minecraft/sprout/whitelist.json:/home/minecraft/whitelist.json',
        '/home/minecraft/sprout/server.properties:/home/minecraft/server.properties',
        '/home/minecraft/sprout/config/JourneyMapServer:/home/minecraft/config/JourneyMapServer',
        '/home/minecraft/sprout/backups:/home/minecraft/backups',
        '/home/minecraft/sprout/mods.override:/home/minecraft/mods.override',
        '/home/minecraft/sprout/config.override:/home/minecraft/config.override',
    ]

    docker::run { $container_name:
        image            => $image_name,
        ports            => [
            '25565:25565',
        ],
        expose           => [
            '25565/tcp',
        ],
        env              => [ "MCMEM=${max_ram}" ],
        volumes          => $sprout_vols,
        memory_limit     => "${max_ram}m", # (format: '<number><unit>', where unit = b, k, m or g)
        dns              => ['8.8.8.8', '8.8.4.4'],
        restart_service  => true,
        pull_on_start    => true,
        extra_parameters => ['--restart=always'],
    }

    duplicity { 'sprout_backup':
        directory         => $sprout_world_path,
        dest_id           => $aws_id,
        dest_key          => $aws_key,
        target            => $sprout_backup_bucket_path,
        remove_older_than => $sprout_backup_retention,
        require           => Package[$cron_service_package],
    }

    docker::run { 'skyfactory3':
        image            => 'demon012/minecraft-skyfactory3',
        ports            => [
            '25566:25565',
        ],
        expose           => [
            '25565/tcp',
        ],
        env              => [
            "MCUID=${minecraft_uid}",
            "MCGID=${minecraft_gid}",
            'MCMEM=4000',
        ],
        volumes          => $skyfactory3_vols,
        memory_limit     => '4096m', # (format: '<number><unit>', where unit = b, k, m or g)
        dns              => ['8.8.8.8', '8.8.4.4'],
        restart_service  => true,
        pull_on_start    => true,
        extra_parameters => ['--restart=always'],
    }

    duplicity { 'skyfactory3_backup':
        directory         => $skyfactory_world_path,
        dest_id           => $aws_id,
        dest_key          => $aws_key,
        target            => $skyfactory_backup_bucket_path,
        remove_older_than => $skyfactory_backup_retention,
        require           => Package[$cron_service_package],
    }
}
