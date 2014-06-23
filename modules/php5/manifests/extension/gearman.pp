class php5::extension::gearman (
  $version = '1.1.0'
) {

  require 'build'
  require 'php5'
  require 'gearman::library'

  helper::script {'install php5::extension::gearman':
    content => template('php5/extension/gearman/install.sh'),
    unless => "php --re gearman | grep -w 'gearman version ${version}'",
    require => Class['php5'],
  }
  ->

  php5::config_extension {'gearman':
    content => template('php5/extension/gearman/conf.ini'),
  }

}
