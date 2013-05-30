# User-per-service, multiple users in group,
# group-per-puppetmodule.
#
# create a debian, rhel service with infra:
# - user for svc
# - group for svc
# - upstart for debian
# - initv for rhel (currently)
# - exec: binary to execute
define svcutils::mixsvc(
  $ensure               = 'running',
  $enable               = true,
  $config_file          = undef,
  $config_file_template = undef,
  $user                 = undef,
  $group                = undef,
  $home                 = undef,
  $respawn              = true,
  $stopsignal           = 'INT',
  $environment          = undef,
  $log_dir,
  $exec,
  $description
) {
  $service_provider = $::osfamily ? {
    'Linux' => 'redhat',
    'RedHat' => 'redhat',
    'Debian' => 'upstart',
    default  => 'upstart'
  }
  $manage_user = $name ? {
    ''      => $title,
    undef   => $title,
    default => $name,
  }

  supervisor::service { $title:
    ensure      => present,
    enable      => $enable,
    command     => "$exec",
    user        => $user,
    group       => $group,
    directory   => $home,
    stopsignal  => $stopsignal,
    environment => $environment,
    redirect_stderr => true,
  }

  if ! defined(File[$log_dir]) {
    file { $log_dir:
      ensure => 'directory',
      mode   => '0755',
      owner  => 'root',
      group  => 'root',
    }
  }
}