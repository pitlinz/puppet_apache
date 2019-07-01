# install letsencrypt
#
# @see https://serverfault.com/questions/768509/lets-encrypt-with-an-nginx-reverse-proxy
#
class pitlinz_apache::letsencrypt (

)  {
  pitlinz_servicestools::ppa{'python-certbot-apache':
    ppaname => 'certbot/certbot'
  }

}
