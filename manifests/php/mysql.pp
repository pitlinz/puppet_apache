# install and configure mysql support

class pitlinz_apache::php::mysql(

) {
  if !defined(Package['php-mysql']) {
    package{'php-mysql':
      ensure  => latest,
      require => Package['php'],
      notify  => Service['apache2']
    }
  }
}
