class lvm::expand::raid::adaptec (
  $logicalVolumeName,
  $volumeGroupName
) {

  include '::raid::adaptec'

  file {'/root/bin/expand-raid.sh':
    ensure => file,
    content => template("${module_name}/expand/raid-adaptec"),
    require => Class['::raid::adaptec', 'lvm::package', 'lvm::base::xfs'],
  }
}
