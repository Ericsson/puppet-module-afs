# == Class: afs
#
# Manage OpenAFS

class afs (
  $cache_path         = 'USE_DEFAULTS',
  $cache_size         = '1000000',
  $config_cache_path  = 'USE_DEFAULTS',
  $config_client_args = '-dynroot -afsdb -daemons 6 -volumes 1000',
  $config_client_path = 'USE_DEFAULTS',
  $packages           = 'USE_DEFAULTS',
  $update             = false,
) {

  # <define USE_DEFAULTS>
  case $::osfamily {
    'RedHat': {
      $cache_path_default         = '/usr/vice/cache'
      $config_cache_path_default  = '/usr/vice/etc/cacheinfo'
      $config_client_path_default = '/etc/sysconfig/openafs-client'
      $packages_default           = [ 'openafs', 'openafs-client', 'openafs-compat', 'openafs-docs', 'openafs-krb5', 'dkms', 'dkms-openafs' ]
    }
    'Suse': {
      $cache_path_default         = '/var/cache/openafs'
      $config_cache_path_default  = '/etc/openafs/cacheinfo'
      $config_client_path_default = '/etc/sysconfig/openafs-client'
      $packages_default           = [ 'openafs', 'openafs-client', 'openafs-compat', 'openafs-docs', 'openafs-krb5' ]
    }
    'Solaris': {
      $cache_path_default         = '/usr/vice/cache'
      $config_cache_path_default  = '/usr/vice/etc/cacheinfo'
      $config_client_path_default = '/usr/vice/etc/sysconfig/openafs-client'
      $packages_default           = [ 'openafs', 'openafs-client', 'openafs-compat', 'openafs-docs', 'openafs-krb5' ]
    }
    default: {
      fail("afs supports osfamilies RedHat, Suse and Solaris. Detected osfamily is <${::osfamily}>.")
    }
  }
  # </define USE_DEFAULTS>


  # <USE_DEFAULTS ?>
  $cache_path_real = $cache_path ? {
    'USE_DEFAULTS' => $cache_path_default,
    default        => $cache_path
  }

  $cache_size_real = $cache_size

  $config_cache_path_real = $config_cache_path ? {
    'USE_DEFAULTS' => $config_cache_path_default,
    default        => $config_cache_path
  }

  $config_client_args_real = $config_client_args

  $config_client_path_real = $config_client_path ? {
    'USE_DEFAULTS' => $config_client_path_default,
    default        => $config_client_path
  }

  $packages_real = $packages ? {
    'USE_DEFAULTS' => $packages_default,
    default        => $packages
  }
  $update_real             = $update
  # </USE_DEFAULTS ?>


  # <validating variables>
  # </validating variables>


  # <Install & Config>
  package { 'OpenAFS_packages':
    ensure => installed,
    name   => $packages_real,
  }

  file  { 'afs_config_cache' :
    ensure  => file,
    path    => $config_cache_path_real,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('afs/cacheinfo.erb'),
    require => Package['OpenAFS_packages'],
  }

  file  { 'afs_config_client' :
    ensure  => file,
    path    => $config_client_path_real,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('afs/openafs-client.erb'),
    require => Package['OpenAFS_packages'],
  }

  service { 'afs_openafs_client_service':
    ensure     => 'running',
    enable     => true,
    name       => 'openafs-client',
    hasrestart => true,
    hasstatus  => true,
  }

  # <Install & Config>

}
