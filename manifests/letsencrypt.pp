# install letsencrypt
#
# @see https://certbot.eff.org/
# @see https://serverfault.com/questions/768509/lets-encrypt-with-an-nginx-reverse-proxy
#
class pitlinz_apache::letsencrypt (
  $cronensure = present
)  {

  case $::operatingsystem {
    'Ubuntu': {
        case $::lsbdistrelease {
          '14.04': {
              pitlinz_apache::letsencrypt::download{'/usr/bin/certbot':
              }
            }
          default: {
              pitlinz_servicestools::ppa{'python-certbot-apache':
                ppaname => 'certbot/certbot'
              }
            }
        }
      }
    default: {
        notify{"${::operatingsystem} not defined":
      }
    }
  }

  file {'/etc/cron.d/certbot':
    ensure => $cronensure,
    content => template('pitlinz_apache/cron/certbot.erb')
  }

}

define pitlinz_apache::letsencrypt::download(
  $url = "https://dl.eff.org/certbot-auto"
) {
  exec{'wget certbot-auto':
    command => "/usr/bin/wget $url",
    cwd     => "/usr/local/bin/",
    creates => "/usr/local/bin/certbot-auto"
  }

  file{'/usr/local/bin/certbot-auto':
    mode => '555',
    require => Exec['wget certbot-auto']
  }

  file{$name:
    ensure => link,
    target => '/usr/local/bin/certbot-auto'
  }

}
