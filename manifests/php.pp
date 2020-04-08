# class to instal php
#

class pitlinz_apache::php (
  $version = undef
) {

  if !defined(Package['php']) {
    package{'php':
      ensure => latest,
      require => Package['apache2'],
      notify  => Service['apache2']
    }
  }

  file{'/var/www/html/info.php':
    ensure  => present,
    mode    => '0644',
    content => '<?php phpinfo();'
  }

}
