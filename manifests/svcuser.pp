define svcutils::svcuser(
  $ensure = 'present',
  $home   = undef,
  $shell  = '/bin/bash',
  $group
) {
  $_name = $name ? {
    ''      => $title,
    undef   => $title,
    default => $name,
  }
  $_group = $group ? {
    ''      => $title,
    undef   => $title,
    default => $group,
  }
  $_home = $home ? {
    ''      => "/home/$title",
    undef   => "/home/$title",
    default => $home,
  }

  if $ensure == 'present' {
    user { $_name:
      ensure  => present,
      system  => true,
      gid     => $_group,
      home    => $_home,
      shell   => $shell,
    }
    if $_home != undef {
      file { $_home:
        ensure => directory,
        owner  => $_name,
        group  => $_group,
      }
    }
  } else {
    user { $_name:
      ensure => 'absent',
    }
  }

  Group <| title == $group |>
}