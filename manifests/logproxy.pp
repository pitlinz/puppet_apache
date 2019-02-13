/**
 * logfile to log proxied access
 */
define pitlinz_apache::logproxy(
  $target	  = undef,
	$logname  = undef,
	$order	  = 10,
) {
  concat::fragment{"${target}_${name}_log_${logname}":
    target 	=> $target,
    content => template("pitlinz_apache/vhost/logproxy.conf.erb"),
    order	=> $order,
	}

}
