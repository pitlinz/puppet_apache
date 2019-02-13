/**
 * apache directory definition
 */
define pitlinz_apache::directory(
  $target	  = undef,
	$path	  = undef,

  $options 	= "Indexes FollowSymLinks",
  $override	= "All",
  $diralias	= '',

	$order		= "20",
  $minorver 	= $::pitlinz_apache2::minorversion
) {

  if !defined(Exec["mkdir_${path}"])  {
    exec{"mkdir_${path}":
      command => "/bin/mkdir -p ${path}",
      creates	=> "${path}"
    }
  }

	concat::fragment{"${target}_${name}_${path}":
    target 	=> $target,
    content => template("pitlinz_apache/vhost/directory.conf.erb"),
    order	=> $order,
	}
}
