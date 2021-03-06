class lvm::install (
  $physicalDevice,
  $logicalVolumeName,
  $volumeGroupName = $lvm::params::volumeGroupName,
  $logicalVolumeSize = $lvm::params::logicalVolumeSize,
  $logicalVolumeFilesystem = $lvm::params::logicalVolumeFilesystem,
  $logicalVolumeMountpoint = $lvm::params::logicalVolumeMountpoint,
  $logicalVolumeMountOptions = $lvm::params::logicalVolumeMountOptions,
  $expandTools = $lvm::params::expandTools
)  inherits lvm::params {

  include 'lvm'

  class {'lvm::package': }

  case $logicalVolumeFilesystem {
    'xfs': {
      class {'lvm::base::xfs': }

      cron {'xfs-maintenance':
        ensure => absent,
        command => "/usr/sbin/xfs_fsr ${logicalVolumeMountpoint} >/dev/null",
        user => 'root',
        minute => 30,
        hour => 2,
        require => Class['lvm::base::xfs'],
      }

      if $expandTools == true {
        class {'lvm::expand::raid::adaptec':
          logicalVolumeName => $logicalVolumeName,
          volumeGroupName => $volumeGroupName,
        }
      }

      $mount_options = 'inode64,nobarrier'
    }
    default: {
      fail("Unknown filesystem ${logicalVolumeFilesystem}")
    }
  }

  if !$mount_options {
    $mount_options = $logicalVolumeMountOptions
  }

  helper::script {'install lvm':
    content => template("${module_name}/install"),
    unless => "lvs | grep -q ${logicalVolumeName}",
    require => Class['lvm::package'],
  }

  if $logicalVolumeMountpoint != undef {
    file {$logicalVolumeMountpoint:
      ensure => directory,
    }

    $mountOptions = $mount_options ? { undef => $logicalVolumeMountOptions,  default => $mount_options }
    mount::entry {'mount lvm':
      source => "/dev/${volumeGroupName}/${logicalVolumeName}",
      target => $logicalVolumeMountpoint,
      type => $logicalVolumeFilesystem,
      options => $mountOptions,
      mount_check => true,
    }

    $mountBasename = file_basename($logicalVolumeMountpoint)
    @monit::entry {"fs-check-${mountBasename}":
      content => template("${module_name}/monit"),
    }
  }

}
