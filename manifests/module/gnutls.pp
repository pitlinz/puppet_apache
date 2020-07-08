# enable/disable module gnutls
class pitlinz_apache::module::gnutls(
    $ensure = present
) {
  if $ensure == present {
    exec{'apache2mod gnutls':
      command => '/usr/sbin/a2enmod gnutls',
      creates => '/etc/apache2/mods-enabled/gnutls.load',
      notify  => Service['apache2']
    }
    class {'pitlinz_apache::moudule::ssl':
      ensure => absent
    }

  } elsif $ensure == absent {
    exec{'apache2mod gnutls':
      command => '/usr/sbin/a2dismod gnutls',
      unless  => '/usr/bin/test `ls /etc/apache2/mods-enabled/ | grep -c gnutls.load` -eq 0',
      notify  => Service['apache2']
    }
  }
}
