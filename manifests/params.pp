class nfs::params {

  case $::osfamily
  {
    'redhat':
    {
      $package_name=[ 'nfs-utils' ]

      case $::operatingsystemrelease
      {
        /^[56].*$/:
        {
          $nfs_server = 'nfs'
          $nfslock = 'nfslock'
          $rpcbind_ipv6_fix=false
        }
        /^7.*$/:
        {
          $nfs_server = 'nfs-server'
          $nfslock = undef
          $rpcbind_ipv6_fix=true
        }
        default: { fail("Unsupported RHEL/CentOS version! - ${::operatingsystemrelease}")  }
      }
    }
    'Debian':
    {
      $package_name=[ 'nfs-common', 'nfs-kernel-server' ]
      $rpcbind_ipv6_fix=false
      case $::operatingsystem
      {
        'Ubuntu':
        {
          case $::operatingsystemrelease
          {
            /^14.*$/:
            {
              $nfs_server = 'nfs-kernel-server'
              $nfslock = undef
            }
            default: { fail("Unsupported Ubuntu version! - ${::operatingsystemrelease}")  }
          }
        }
        'Debian': { fail('Unsupported')  }
        default: { fail('Unsupported Debian flavour!')  }
      }
    }
    default: { fail('Unsupported OS!')  }
  }
}
