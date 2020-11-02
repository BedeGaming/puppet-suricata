class suricata::custom_rules {

    file { '/etc/suricata/rules/custom.rules':
      content => $::suricata::custom_rules,
    }
}
