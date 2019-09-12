# == Class: nfs
#
# === nfs::install documentation
#
class nfs::install inherits nfs {

  if($nfs::manage_package)
  {
    package { $nfs::params::package_name:
      ensure => $nfs::package_ensure,
    }
  }

  # # cat /usr/lib/systemd/system/rpcbind.socket
  # [Unit]
  # Description=RPCbind Server Activation Socket
  #
  # [Socket]
  # ListenStream=/var/run/rpcbind.sock
  # ListenStream=[::]:111
  # ListenStream=0.0.0.0:111
  # BindIPv6Only=ipv6-only
  #
  # [Install]
  # WantedBy=sockets.target

  if($nfs::params::rpcbind_ipv6_fix)
  {
    systemd::socket { 'rpcbind':
      description   => 'RPCbind Server Activation Socket',
      listen_stream => [ '/var/run/rpcbind.sock', '0.0.0.0:111' ],
      notify        => Exec['systemd-tmpfiles create rpcbind.conf'],
    }

    exec { 'systemd-tmpfiles create rpcbind.conf':
      command     => '/usr/bin/systemd-tmpfiles --create rpcbind.conf',
      path        => '/bin:/sbin:/usr/bin:/usr/sbin',
      refreshonly => true,
    }
  }

}
