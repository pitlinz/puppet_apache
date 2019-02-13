# class to install apache webserver
#
class pitlinz_apache(
	$minorversion = $::apache2minorversion
) {

	if !defined(Package['apache2']) {
		package{'apache2':
			ensure => latest
		}
	}

	if !defined(Service['apache2']) {
		service{'apache2':
			ensure => running
		}
	}

	file_line{"logformat_proxy":
		path 	=> "/etc/apache2/apache2.conf",
		line 	=> 'LogFormat "%{X-Forwarded-For}i %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" proxy',
		match  	=> '^LogFormat (.)* proxy$',
		after	=> 'LogFormat "%{User-agent}i" agent',
		require	=> Package['apache2'],
		notify 	=> Service['apache2']
	}

	file_line{"logformat_vhost_proxy":
		path 	=> "/etc/apache2/apache2.conf",
		line 	=> 'LogFormat "%v:%p %{X-Forwarded-For}i %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" vhost_proxy',
		match  	=> '^LogFormat (.)* vhost_proxy$',
		after	=> 'LogFormat "%{User-agent}i" agent',
		require	=> Package['apache2'],
		notify 	=> Service['apache2']
	}
}
