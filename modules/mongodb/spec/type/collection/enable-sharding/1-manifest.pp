node default {

  mongodb::core::mongod {'config':
    config_server => true,
    port => 27019
  }
  ->

  mongodb::core::mongos {'router':
    port => 27017,
    config_servers => ['127.0.0.1:27019'],
  }
  ->

  class {'mongodb::role::shard':
    port => 27018,
    router => 'localhost:27017'
  }
  ->

  mongodb_collection {'mycollection':
    ensure => present,
    database => 'testdb',
    router => 'localhost:27017'
  }

}
