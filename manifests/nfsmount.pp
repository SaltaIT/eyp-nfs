define nfs::nfsmount (
                          $nfsdevice,
                          $mount         = $name,
                          $nfsrw         = true,
                          $ensure        = 'mounted',
                          $opts          = 'vers=3,tcp,timeo=600,rsize=65536,wsize=65536,hard,noac,_netdev',
                          $mkdir_mount   = true,
                          $mount_owner   = 'root',
                          $mount_group   = 'root',
                          $mount_mode    = '0755',
                          $check_file    = 'is.mounted',
                          $check_content = "OK\n",
                        ) {

  Exec {
		path => '/bin:/sbin:/usr/bin:/usr/sbin',
	}

  if($nfsrw)
  {
    $nfsoptions="rw,${opts}"

    if($check_file!=undef)
    {
      if($ensure=='mounted')
      {
        file { "${mount}/${check_file}":
          ensure  => 'present',
          owner   => 'root',
          group   => 'root',
          mode    => '0644',
          content => $check_content,
          require => Mount[$mount],
        }
      }
    }
  }
  else
  {
    $nfsoptions="ro,${opts}"
  }

  validate_re($ensure, [ 'mounted', 'absent' ], "not valid: mounted/absent")

  if($mkdir_mount)
  {
    if($ensure=='mounted')
    {
      exec { "mkdir p ${mount}":
        command => "mkdir -p ${mount}",
        creates => $mount,
      }

      file { $mount:
        ensure  => 'present',
        owner   => $mount_owner,
        group   => $mount_group,
        mode    => $mount_mode,
        require => Exec["mkdir p ${mount}"],
      }
    }

    $require_mount= [
                      Exec["mkdir p ${mount}"],
                      File[$mount],
                      Class['nfs::service'],
                      File[$mount]
                    ]
  }
  else
  {
    $require_mount=Class['nfs::service']
  }

  mount { "$mount $ensure":
        ensure   => $ensure,
        name     => $mount,
        atboot   => true,
        device   => $nfsdevice,
        fstype   => 'nfs',
        options  => $nfsoptions,
        remounts => true,
        require  => $require_mount,
  }

}
