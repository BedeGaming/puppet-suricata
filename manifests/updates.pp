define suricata::updates (
  Enum['present','absent']      $ensure = 'present',
) {

  if ! defined(Class['suricata']) {
    fail('You must include the suricata base class before using any suricata defined resources')
  }

  $config_root = lookup('suricata::updates::config_root')

  $update_source_filename = regsubst($name, '/', '-', 'G')

  file { "${config_root}/update", "${config_root}/update/sources":
    ensure => directory,
    owner  => 'root',
    group  => $::suricata::group,
    mode   => '0600',
  } ->

  file { "${config_root}/update/sources/${update_source_filename}.yaml":
    ensure => $ensure,
    owner  => 'root',
    group  => $::suricata::group,
    mode   => '0600',
    content => "source: ${name}\n",
  }
}
