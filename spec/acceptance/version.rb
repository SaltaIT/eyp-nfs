
_osfamily               = fact('osfamily')
_operatingsystem        = fact('operatingsystem')
_operatingsystemrelease = fact('operatingsystemrelease').to_f

case _osfamily
when 'RedHat'
  $examplevar = 'valrh'
  $nfsservice = 'nfs-server'

when 'Debian'
  $examplevar = 'valdeb'
  $nfsservice = 'nfs-kernel-server'

else
  $examplevar = '-_-'
  $nfsservice = '-_-'

end
