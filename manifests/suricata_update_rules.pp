class suricata::suricata_update_rules {

  if $::suricata::update_rules {
    file { "${::suricata::config_dir}/disable.conf":
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0600',
      content => "# This file is managed by Puppet. DO NOT EDIT.\n\n${::suricata::update_disabled_rules}",
    }

    if $::suricata::manage_user {
      file { "/var/run/suricata":
        ensure  => directory,
        owner   => $::suricata::user,
        group   => 'root',
        mode    => '0755',
        require => $usr_require,
      }

      file { ["/var/lib/suricata", "/var/lib/suricata/rules"]:
        ensure  => directory,
        owner   => $::suricata::user,
        group   => 'root',
        mode    => '0755',
        require => $usr_require,
      }
    }

    file { "/etc/cron.d/suricata-rules-updates":
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0600',
      content => "# This file is managed by Puppet. DO NOT EDIT.\n\n 0 1 * * *   root  suricata-update --reload-command='suricatasc -c ruleset-reload-nonblocking'",
    } 


    exec { 'run suricata-update manually on first install':
      command   => '/usr/bin/suricata-update --reload-command="suricatasc -c ruleset-reload-nonblocking"',
      subscribe => [ 
        File['/etc/cron.d/suricata-rules-updates'], 
      ],
      refreshonly => true,
    }
  }

}
