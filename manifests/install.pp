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

}
