# enable/disable module gnutls
class pitlinz_apache::moudule::ssl(
    $ensure => present
) {
  if $ensure == present {
    exec{'apache2mod ssl':
      command => '/usr/sbin/a2enmod ssl',
      creates => '/etc/apache2/mods-enabled/ssl.load',
      require => Package['apache2'],
      notify  => Service['apache2']
    }

    class {'pitlinz_apache::moudule::gnutls':
      ensure => absent
    }
    
  } elsif $ensure == absent {
    exec{'apache2mod ssl':
      command => '/usr/sbin/a2dismod ssl',
      unless  => '/usr/bin/test `ls /etc/apache2/mods-enabled/ | grep -c ssl.load` -eq 0'
      require => Package['apache2'],
      notify  => Service['apache2']
    }
  }


}
