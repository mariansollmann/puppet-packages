class jenkins::plugin::github(
  $oauthAccessToken = undef,
  $username = undef,
  $password = undef,
  $apiUrl = undef
) {

  require 'jenkins::plugin::git'
  require 'jenkins::plugin::github_api'

  file {'/var/lib/jenkins/com.cloudbees.jenkins.GitHubPushTrigger.xml':
    ensure    => 'present',
    content   => template("${module_name}/plugin/github.xml"),
    owner     => 'jenkins',
    group     => 'nogroup',
    mode      => '0644',
  }
  ->

  jenkins::plugin {'github':
    version => '1.8',
  }

}
