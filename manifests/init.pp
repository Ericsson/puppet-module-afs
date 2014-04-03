# == Class: afs
#
# Manage OpenAFS

class afs (
  $afs_cell             = undef,
  $afs_cellserverdb     = undef,
  $afs_config_path      = 'USE_DEFAULTS',
  $afs_suidcells        = undef,
  $cache_path           = 'USE_DEFAULTS',
  $cache_size           = '1000000',
  $config_client_args   = '-dynroot -afsdb -daemons 6 -volumes 1000',
  $config_client_dkms   = 'USE_DEFAULTS',
  $config_client_path   = 'USE_DEFAULTS',
  $config_client_update = false,
  $create_symlinks      = false,
  $init_script          = 'USE_DEFAULTS',
  $init_template        = 'USE_DEFAULTS',
  $links                = undef,
  $packages             = 'USE_DEFAULTS',
) {

  # <define USE_DEFAULTS>
  case $::osfamily {
    'RedHat': {
      $afs_config_path_default    = '/usr/vice/etc'
      $cache_path_default         = '/usr/vice/cache'
      $config_client_dkms_default = 'true'
      $config_client_path_default = '/etc/sysconfig/openafs-client'
      $init_script_default        = '/etc/init.d/openafs-client'
      $init_template_default      = 'openafs-client-RedHat'
      $packages_default           = [ 'openafs', 'openafs-client', 'openafs-docs', 'openafs-compat', 'openafs-krb5', 'dkms', 'dkms-openafs' ]
    }
    'Suse': {
      $afs_config_path_default    = '/etc/openafs'
      $cache_path_default         = '/var/cache/openafs'
      $config_client_dkms_default = 'false'
      $config_client_path_default = '/etc/sysconfig/openafs-client'
      $init_script_default        = '/etc/init.d/openafs-client'
      $init_template_default      = 'openafs-client-Suse'
      $packages_default           = [ 'openafs', 'openafs-client', 'openafs-docs', 'openafs-kernel-source', 'openafs-krb5-mit' ]
    }
# Placeholders only, untested
#    'Debian': {
#      $afs_config_path_default    = '/etc/openafs'
#      $cache_path_default         = '/var/cache/openafs'
#      $config_client_dkms_default = 'false'
#      $config_client_path_default = '/etc/sysconfig/openafs-client'
#      $init_script_default        = '/etc/init.d/openafs-client'
#      $init_template_default      = 'openafs-client-Debian'
#      $packages_default           = [ 'openafs', 'openafs-client', 'openafs-docs', 'openafs-kernel-source', 'openafs-krb5' ]
#    }
#    'Solaris': {
#      $afs_config_path_default    = '/etc/openafs'
#      $cache_path_default         = '/usr/vice/cache'
#      $config_client_dkms_default = 'false'
#      $config_client_path_default = '/usr/vice/etc/sysconfig/openafs-client'
#      $init_script_default        = '/etc/init.d/openafs-client'
#      $init_template_default      = 'openafs-client-Solaris'
#      $packages_default           = [ 'openafs', 'openafs-client', 'openafs-docs', 'openafs-compat', 'openafs-krb5' ]
#    }
    default: {
      fail("afs supports osfamilies RedHat, Suse and Solaris. Detected osfamily is <${::osfamily}>.")
    }
  }
  # </define USE_DEFAULTS>


  # <USE_DEFAULTS ?>

  $afs_cell_real = $afs_cell

  $afs_cellserverdb_real = $afs_cellserverdb

  $afs_config_path_real = $afs_config_path ? {
    'USE_DEFAULTS' => $afs_config_path_default,
    default        => $afs_config_path
  }

  $afs_suidcells_real = $afs_suidcells

  $cache_path_real = $cache_path ? {
    'USE_DEFAULTS' => $cache_path_default,
    default        => $cache_path
  }

  $cache_size_real = $cache_size

  $config_client_args_real = $config_client_args

  $config_client_dkms_real = $config_client_dkms ? {
    'USE_DEFAULTS' => $config_client_dkms_default,
    default        => $config_client_dkms
  }

  $config_client_path_real = $config_client_path ? {
    'USE_DEFAULTS' => $config_client_path_default,
    default        => $config_client_path
  }

  $config_client_update_real = $config_client_update

  $init_script_real = $init_script ? {
    'USE_DEFAULTS' => $init_script_default,
    default        => $init_script
  }

  $init_template_real = $init_template ? {
    'USE_DEFAULTS' => $init_template_default,
    default        => $init_template
  }

  $packages_real = $packages ? {
    'USE_DEFAULTS' => $packages_default,
    default        => $packages
  }
  # </USE_DEFAULTS ?>


  # <validating variables>
  # </validating variables>


  # <Install & Config>
  package { 'OpenAFS_packages':
    ensure => installed,
    name   => $packages_real,
  }

  common::mkdir_p { $afs_config_path_real: }

  file  { 'afs_init_script' :
    ensure  => file,
    path    => $init_script_real,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    source  => "puppet:///modules/afs/${init_template_real}",
    require => Package['OpenAFS_packages'],
  }

  file  { 'afs_config_cacheinfo' :
    ensure  => file,
    path    => "${afs_config_path_real}/cacheinfo",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('afs/cacheinfo.erb'),
    require => Common::Mkdir_p[$afs_config_path_real],
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

  if $afs_suidcells_real != undef {
    file  { 'afs_config_suidcells' :
      ensure  => file,
      path    => "${afs_config_path_real}/SuidCells",
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => "$afs_suidcells_real\n",
      require => Common::Mkdir_p[$afs_config_path_real],
    }
  }

  if $afs_cell_real != undef {
    file  { 'afs_config_thiscell' :
      ensure  => file,
      path    => "${afs_config_path_real}/ThisCell",
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => "$afs_cell_real\n",
      require => Common::Mkdir_p[$afs_config_path_real],
    }
  }

  if $afs_cellserverdb_real != undef {
    file  { 'afs_config_cellserverdb' :
      ensure  => file,
      path    => "${afs_config_path_real}/CellServDB",
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => "$afs_cellserverdb_real\n",
      require => Common::Mkdir_p[$afs_config_path_real],
    }
  }

  # THIS SERVICE SHOULD NOT BE RESTARTED
  # Restarting it may cause AFS module and kernel problems.
  service { 'afs_openafs_client_service':
    ensure     => 'running',
    enable     => true,
    name       => 'openafs-client',
    hasstatus  => true,
    hasrestart => false,
    restart    => '/bin/true',
    require => Package['OpenAFS_packages'],
  }

  # <Install & Config>


  # <create symlinks>
  if $create_symlinks == true {

    $afs_create_link_defaults = {
      'ensure' => 'link',
      'owner'  => 'root',
      'group'  => 'root',
      'mode'   => '0755',
    }

    create_resources(file, $links, $afs_create_link_defaults)

  }
  # </create symlinks>

}
