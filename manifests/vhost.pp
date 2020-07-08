define pitlinz_apache::vhost(
  $servername 	= $::fqdn,
  $serveradmin 	= '',
  $docroot		  = "/srv/www/${::fqdn}",
  $directoryindex	= "index.php index.html",
  $port			    = undef,
  $aliases		  = [],
  $logname      = '',
  $sslcrt			   = '',
	$sslkey        = '',
	$sslintermed   = '',
	$modssl        = 'gnutls',
	$prio          = 100,

	$confincludes	= undef,
	$envsettings	= undef,

	$proxyloc		= "",
	$proxydest		= "",
	$proxyhtmlurlmap= [],

	$ensureenabled 	= 'link',
) {

  include ::pitlinz_apache

	$conffile = "/etc/apache2/sites-available/${name}.conf"

	concat{"${name}":
    path  => $conffile,
    owner => 'root',
    group => 'root',
    mode  => '0644',
		require => Package["apache2"],
		notify	=> Service["apache2"],
	}

	if $port == undef {
    if $sslcrt != '' {
      $_port = 443
    } else {
      $_port = 80
    }
	} else {
    $_port = $port
	}

	if $serveradmin == '' {
    $_serveradmin = "webmaster@${servername}"
	} else {
    $_serveradmin = $serveradmin
	}

	concat::fragment{"${name}_head":
    target 	=> "${name}",
    content	=> template("pitlinz_apache/vhost/head.conf.erb"),
    order	=> "00",
	}


	if !defined(::Pitlinz_apache::Directory["${name}_${docroot}"]) {
    ::pitlinz_apache::directory{"${name}_${docroot}":
      path 	=> $docroot,
      target 	=> $name
    }
	}

	if is_array($envsettings) {
    concat::fragment{"${name}_envsettings":
      target 	=> "${name}",
      content	=> template("pitlinz_apache/vhost/envsettings.conf.erb"),
      order	=> "50",
		}
	}


	if is_array($confincludes) {
    concat::fragment{"${name}_includes":
      target 	=> "${name}",
      content	=> template("pitlinz_apache/vhost/includes.conf.erb"),
      order	=> "51",
		}
	}


  concat::fragment{"${name}_close":
    target 	=> "${name}",
		content => "\n</VirtualHost>\n",
		order	=> 90
	}

	file {"/etc/apache2/sites-enabled/${prio}-${name}.conf":
    ensure => $ensureenabled,
    target => $conffile
	}

}
