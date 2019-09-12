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
            /^1[468].*$/:
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
    'Suse':
    {
      $package_name=[ 'nfs-client', 'nfs-kernel-server' ]
      $rpcbind_ipv6_fix=false
      case $::operatingsystem
      {
        'SLES':
        {
          case $::operatingsystemrelease
          {
            '11.3':
            {
              $nfs_server = 'nfs-kernel-server'
              $nfslock = undef
            }
            default: { fail("Unsupported operating system ${::operatingsystem} ${::operatingsystemrelease}") }
          }
        }
        default: { fail("Unsupported operating system ${::operatingsystem}") }
      }
    }
    default: { fail('Unsupported OS!')  }
  }
}
