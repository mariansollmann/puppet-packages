node default {

  class {'jenkins':
    hostname => 'example.com'
  }

  class {'jenkins::plugin::embeddable_build_status':
  }
}
