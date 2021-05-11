define suricata::updates (
  Enum['present','absent']      $ensure = 'present',
) {

  if ! defined(Class['suricata']) {
    fail('You must include the suricata base class before using any suricata defined resources')
  }

  $config_dir = lookup('suricata::updates::config_dir')

  $update_source_filename = regsubst($name, '/', '-', 'G')

  file { "${config_dir}/${update_source_filename}.yaml":
    ensure => $ensure,
    owner  => 'root',
    group  => $::suricata::group,
    mode   => '0600',
    content => "source: ${name}\n",
  }
}
