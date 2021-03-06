class pagespeed::package inherits pagespeed {

	if ! defined(Package['curl']) { 
		package { 'curl':
			ensure => latest,
			require => Exec['apt_update'],
		}
	}

	exec { "pagespeed-download":
		cwd		=> "/tmp",
		command => "curl -LO --silent 'https://dl-ssl.google.com/dl/linux/direct/mod-pagespeed-stable_current_amd64.deb'",
		path    => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ],
		require => [Package["curl"], Exec['apt_update']],
	} ->

	exec { "pagespeed-install":
		cwd		=> "/tmp",
		path    => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ],
		command => "dpkg -i mod-pagespeed-stable_current_amd64.deb; apt-get -f install",
		require => [Exec["pagespeed-download"]],
	} ->

	class { 'apache::mod::pagespeed': }
	
	/*exec { "pagespeed-enable":
		command => "a2enmod pagespeed",
		path    => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ],
		require => [ Exec["pagespeed-install"], Class["apache"] ],
		notify  => Class["apache::service"],
	}*/
}