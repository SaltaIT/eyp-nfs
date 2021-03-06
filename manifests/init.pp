class nfs (
            $manage_package        = true,
            $package_ensure        = 'installed',
            $manage_service        = true,
            $manage_docker_service = true,
            $service_ensure        = 'running',
            $service_enable        = true,
            $is_server             = false,
          ) inherits nfs::params{

  class { '::nfs::install': } ->
  class { '::nfs::config': } ~>
  class { '::nfs::service': } ->
  Class['::nfs']

}
