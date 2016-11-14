class nfs::service inherits nfs {

  #
  validate_bool($nfs::manage_docker_service)
  validate_bool($nfs::manage_service)
  validate_bool($nfs::service_enable)

  validate_re($nfs::service_ensure, [ '^running$', '^stopped$' ], "Not a valid daemon status: ${nfs::service_ensure}")

  $is_docker_container_var=getvar('::eyp_docker_iscontainer')
  $is_docker_container=str2bool($is_docker_container_var)

  if( $is_docker_container==false or
      $nfs::manage_docker_service)
  {
    if($nfs::manage_service)
    {
      if($is_server)
      {
        service { $nfs::params::nfs_server:
          ensure => $nfs::service_ensure,
          enable => $nfs::service_enable,
        }
      }

      service { 'rpcbind':
        ensure => $nfs::service_ensure,
        enable => $nfs::service_enable,
      }

      if($nfs::params::nfslock!=undef)
      {
        service { $nfs::params::nfslock:
          ensure => $nfs::service_ensure,
          enable => $nfs::service_enable,
        }        
      }
    }
  }
}
