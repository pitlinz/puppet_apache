define pitlinz_apache::letsencrypt::vhostssl(
  $servername 	   = $::fqdn,
  $aliases         = '',
  $rediraliases    = '',
  $serveradmin 	   = "webmaster@${::fqdn}",
  $docroot		     = "/srv/www/${::fqdn}",
  $directoryindex	 = "index.php index.html",
  $port			       = 443,
  $logname         = '',
	$modssl          = 'gnutls',
  $sslinclude      = 'include /etc/letsencrypt/options-ssl-apache.conf',
	$prio            = 100,

	$confincludes	   = undef,
	$envsettings	   = undef,

	$ensureenabled 	= 'link',
) {

  include ::pitlinz_apache
  include pitlinz_apache::letsencrypt

  if !defined(Class["pitlinz_apache::module::$modssl"]) {
    class{"pitlinz_apache::module::$modssl":
      ensure => present
    }
  }

  exec{"certbot $servername":
    command => "/usr/bin/certbot certonly --webroot -w $docroot -d $servername",
    creates => "/etc/letsencrypt/live/$servername"
  }

  $conffile = "/etc/apache2/sites-available/${name}-ssl.conf"
  $sslcrt   = "/etc/letsencrypt/live/${servername}"
  $target   = "${name}-ssl"
  $sslcert  = "/etc/letsencrypt/live/${servername}/fullchain.pem"
  $sslkey   = "/etc/letsencrypt/live/${servername}/privkey.pem"

  if $serveradmin == '' {
    $_serveradmin = "webmaster@${servername}"
	} else {
    $_serveradmin = $serveradmin
	}

  $_port    = $port

  concat{"$target":
    path  => $conffile,
    owner => 'root',
    group => 'root',
    mode  => '0644',
		require => Package["apache2"],
		notify	=> Service["apache2"],
	}

  concat::fragment{"${target}_head":
    target 	=> $target,
    content	=> template("pitlinz_apache/vhost/head.conf.erb"),
    order	=> 0,
	}

  if !defined(::Pitlinz_apache::Directory["${target}_${docroot}"]) {
    ::pitlinz_apache::directory{"${target}_${docroot}":
      path 	  => $docroot,
      target 	=> $target
    }
	}

  if $modssl == 'ssl' {
    concat::fragment{"${target}_ssl":
      target 	=> $target,
      content	=> template("pitlinz_apache/vhost/modssl.erb"),
      order	=> "50",
		}
	}

  if is_array($envsettings) {
    concat::fragment{"${target}_envsettings":
      target 	=> $target,
      content	=> template("pitlinz_apache/vhost/envsettings.conf.erb"),
      order	=> "50",
		}
	}

	if is_array($confincludes) {
    concat::fragment{"${target}_includes":
      target 	=> $target,
      content	=> template("pitlinz_apache/vhost/includes.conf.erb"),
      order	=> "51",
		}
	}

  concat::fragment{"${target}_close":
    target 	=> $target,
		content => "\n</VirtualHost>\n",
		order	=> 90,
	}

  concat::fragment{"${target}_httpredir":
    target 	=> $target,
    content	=> template("pitlinz_apache/vhost/httpsredirict.erb"),
    order	=> 99,
  }

  file {"/etc/apache2/sites-enabled/${prio}-${name}.conf":
    ensure => $ensureenabled,
    target => $conffile,
    require => Package["apache2"],
		notify	=> Service["apache2"]
	}

}
