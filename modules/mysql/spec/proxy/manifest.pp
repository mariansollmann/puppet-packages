node default {

  require 'monit'

  class {'mysql::proxy':
    backend_addresses => ['10.10.10.12:3306', '10.10.10.13:3306'],
  }
}
