define pitlinz_apache::letsencrypt::vhostssl(
  $servername 	   = $::fqdn,
<<<<<<< HEAD
  $aliases         = '',
=======
>>>>>>> 6dd6b5d807a8301e9c32b8764c2c70be7d916067
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

<<<<<<< HEAD

  exec{"certbot $servername":
    command => "/usr/bin/certbot certonly --webroot -w $docroot -d $servername",
=======
  exec{"certbot $servername":
    command => "/usr/bin/certbot certonly --webroot -w $docroot -d $servername"
>>>>>>> 6dd6b5d807a8301e9c32b8764c2c70be7d916067
    creates => "/etc/letsencrypt/live/$servername"
  }


}
