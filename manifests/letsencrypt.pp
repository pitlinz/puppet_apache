# install letsencrypt
#
# @see https://serverfault.com/questions/768509/lets-encrypt-with-an-nginx-reverse-proxy
#
class pitlinz_apache::letsencrypt (

)  {
  if !defined(Pitlinz_common::Ppa['python-certbot-apache']) {
    pitlinz_common::ppa{'python-certbot-apache':
      ppaname => 'certbot/certbot'
    }
  }

  if !defined(Package['certbot']) {
    package{'certbot':
      ensure => latest,
      require => Pitlinz_common::Ppa['python-certbot-apache']
    }
  }

  if !defined(Package['python-certbot-apache']) {
    package{'python-certbot-apache':
      ensure => latest,
      require => Package['certbot']
    }
  }
}
