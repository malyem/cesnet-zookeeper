# == Class zookeeper::params
#
# This class is meant to be called from zookeeper.
# It sets variables according to platform.
#
class zookeeper::params {
  case "${::osfamily}-${::operatingsystem}" {
    /RedHat-Fedora|Debian/: {
      $packages = [ 'zookeeper' ]
      $daemon = 'zookeeper'
      $confdir = '/etc/zookeeper'
      $datadir = '/var/lib/zookeeper/data'
    }
    /RedHat/: {
      $packages = [ 'zookeeper-server' ]
      $daemon = 'zookeeper-server'
      $confdir = '/etc/zookeeper/conf'
      $datadir = '/var/lib/zookeeper'
    }
    default: {
      fail("${::osfamily} (${::operatingsystem}) not supported")
    }
  }

  $alternatives = "${::osfamily}-${::operatingsystem}" ? {
    /RedHat-Fedora/ => undef,
    /Debian/        => undef,
    # https://github.com/puppet-community/puppet-alternatives/issues/18
    /RedHat/        => '',
  }

  $hostnames = undef

  $features = {
  }
}
