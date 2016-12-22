#
# acregmin  3  Minimum lifetime for file attributes
# acregmax  60  Maximum lifetime for file attributes
# acdirmin  30  Minimum lifetime for directory attributes
# acdirmax  60  Maximum lifetime for directory attributes
#
define nfs::nfsmount (
                          $nfsdevice,
                          $mount         = $name,
                          $nfsrw         = true,
                          $ensure        = 'mounted',
                          $opts          = 'vers=3,_netdev',
                          $timeo         = '600',
                          $rsize         = '65536',
                          $wsize         = '65536',
                          $recovery      = 'hard',
                          $protocol      = 'tcp',
                          $ac            = true,
                          $acregmin      = '3',
                          $acregmax      = '60',
                          $acdirmin      = '30',
                          $acdirmax      = '60',
                          $mkdir_mount   = true,
                          $mount_owner   = 'root',
                          $mount_group   = 'root',
                          $mount_mode    = '0755',
                          $check_file    = 'is.mounted',
                          $check_content = "OK\n",
                          $bind_mounts   = undef,
                        ) {

  Exec {
    path => '/bin:/sbin:/usr/bin:/usr/sbin',
  }

  validate_re($ensure, [ 'mounted', 'absent' ], 'ensure not valid: mounted/absent')

  validate_re($recovery, [ 'hard', 'soft' ], 'recovery not valid: hard/soft')

  #udp, udp6,  tcp, tcp6,  and  rdma
  validate_re($protocol, [ 'udp', 'udp6', 'tcp', 'tcp6', 'rdma' ], 'protocol not valid - available values are udp, udp6,  tcp, tcp6,  and  rdma')

  if($ac)
  {
    $nfs_general_options="ac,acregmin=${acregmin},acregmax=${acregmax},acdirmin=${acdirmin},acdirmax=${acdirmax},proto=${protocol},${recovery},timeo=${timeo},rsize=${rsize},wsize=${wsize},${opts}"
  }
  else
  {
    $nfs_general_options="noac,proto=${protocol},${recovery},timeo=${timeo},rsize=${rsize},wsize=${wsize},${opts}"
  }

  if($nfsrw)
  {
    $nfsoptions="rw,${nfs_general_options}"

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
    $nfsoptions="ro,${nfs_general_options}"
  }

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

      $require_mount= [
                        Exec["mkdir p ${mount}"],
                        File[$mount],
                        Class['nfs::service'],
                      ]
    }
    else
    {
      $require_mount= [
                        Class['nfs::service']
                      ]
    }

  }
  else
  {
    $require_mount=Class['nfs::service']
  }

  mount { $mount:
        ensure   => $ensure,
        atboot   => true,
        device   => $nfsdevice,
        fstype   => 'nfs',
        options  => $nfsoptions,
        remounts => true,
        require  => $require_mount,
  }

  #bind_mounts
  if($bind_mounts!=undef)
  {
    validate_array($bind_mounts)

    # plain_mounts:
    #   '/shared_fs/%{::ntteam_environment_uppercase}':
    #     ensure: 'mounted'
    #     device: '/opt/informatica/shared_lcih'
    #     fstype: 'none'
    #     options: 'rw,bind'


    mount { $bind_mounts
      ensure  => 'mounted',
      device  => $mount,
      fstype  => 'none',
      options => 'rw,bind',
      atboot  => false,
      require => Mount[$mount],
    }
  }

}
