define nfs::export(
                    $path = $name,
                    $fsid = undef,
                    $rw = true,
                    $root_squash = false,
                    $from = '*'
                  ) {

  concat::fragment{ "/etc/exports ${path} ${from}":
    target  => '/etc/exports',
    content => template("${module_name}/nfsexport.erb"),
    order   => '01',
  }
}
