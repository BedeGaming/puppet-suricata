define suricata::updates (
  Enum['present','absent']      $ensure = 'present',
) {

  if ! defined(Class['suricata']) {
    fail('You must include the suricata base class before using any suricata defined resources')
  }

  $update_source_filename = regsubst($name, '/', '-', 'G')

  file { "/var/lib/suricata/update/sources/${update_source_filename}.yaml":
    ensure => $ensure,
    owner  => $::suricata::user,
    group  => $::suricata::group,
    mode   => '0600',
    content => "source: ${name}\n",
  }
}
