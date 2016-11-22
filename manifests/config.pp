# == Class: nfs
#
# === nfs::config documentation
#
class nfs::config inherits nfs {

  if($is_server)
  {
    concat { '/etc/exports':
      ensure => 'present',
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
    }

    concat::fragment{ '/etc/exports header':
      target  => '/etc/exports',
      content => "#\n# puppet managed file\n#\n\n",
      order   => '00',
    }
  }

}
