define pitlinz_apache::letsencrypt::vhostssl(
  $servername 	   = $::fqdn,
  $serveradmin 	   = "webmaster@${::fqdn}",
  $docroot		     = "/srv/www/${::fqdn}",
  $directoryindex	 = "index.php index.html",
  $port			       = 443,
  $logname         = '',
	$modssl          = 'gnutls',
	$prio            = 100,

	$confincludes	   = undef,
	$envsettings	   = undef,

	$ensureenabled 	= 'link',
) {

  include pitlinz_apache::letsencrypt

  class{"pitlinz_apache::module::$modssl":
    ensure => present
  }

  exec{"certbot $servername":
    command => "/usr/bin/certbot certonly --webroot -w $docroot -d $servername"
    creates => "/etc/letsencrypt/live/$servername"
  }


}
