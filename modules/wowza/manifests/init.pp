class wowza (
  $version = '4.0.3',
  $license = 'EDEV4-HNGXC-T3rK3-axKB3-ncwW6-aHhB6-KQJRHWV3hHA',
  $admin_user = 'root',
  $admin_password = 'root'
) {

  require 'java'
  require 'ffmpeg'

  include 'wowza::service'

  user {'wowza':
    ensure => present,
  }

  helper::script {'install wowza':
    content => template("${module_name}/install.sh"),
    unless => "dpkg -l | grep -q '^ii.* wowzastreamingengine-${version}'",
    timeout => 900,
    require => User['wowza'],
  }
  ->

  file {
    '/usr/local/WowzaStreamingEngine/lib/lib-versions':
      ensure => directory,
      owner => 'wowza',
      group => 'wowza',
      mode => '0755';

    '/usr/local/WowzaStreamingEngine/conf/admin.password':
      ensure =>file,
      content => template("${module_name}/admin.password"),
      owner => '0',
      group => '0',
      mode => '0644',
      notify => Service['wowza'];

    '/usr/local/WowzaStreamingEngine/conf/Server.license':
      ensure => file,
      content => $license,
      owner => '0',
      group => '0',
      mode => '0644',
      notify => Service['wowza'];

    '/etc/init.d/wowza':
      ensure => file,
      content => template("${module_name}/init"),
      owner => '0',
      group => '0',
      mode => '0755',
      notify => Service['wowza'];
  }
  ->

  helper::service{'wowza':}

  @monit::entry {'wowza':
    content => template("${module_name}/monit"),
  }

}
