class { 'nfs':
  is_server => true,
}

nfs::export { '/etc':
  fsid => '1',
}

->

nfs::nfsmount { '/mnt/etc':
  nfsdevice => '127.0.0.1:/etc',
}
