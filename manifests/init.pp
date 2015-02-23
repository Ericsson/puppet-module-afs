# == Class: afs
#
# Manage OpenAFS

class afs (
  $afs_cellserverdb      = undef,
  $afs_cell              = undef,
  $afs_config_path       = 'USE_DEFAULTS',
  $afs_cron_job_content  = undef,
  $afs_cron_job_hour     = undef,
  $afs_cron_job_interval = undef,
  $afs_cron_job_minute   = 42,
  $afs_cron_job_monthday = undef,
  $afs_cron_job_month    = undef,
  $afs_cron_job_weekday  = undef,
  $afs_suidcells         = undef,
  $cache_path            = 'USE_DEFAULTS',
  $cache_size            = '1000000',
  $config_client_args    = '-dynroot -afsdb -daemons 6 -volumes 1000 -nosettime',
  $config_client_dkms    = 'USE_DEFAULTS',
  $config_client_path    = 'USE_DEFAULTS',
  $config_client_update  = false,
  $create_symlinks       = false,
  $init_script           = 'USE_DEFAULTS',
  $init_template         = 'USE_DEFAULTS',
  $links                 = undef,
  $package_adminfile     = undef,
  $package_name          = 'USE_DEFAULTS',
  $package_provider      = undef,
  $package_source        = undef,
  $service_provider      = undef,
) {

  # <define os default values>
  # Set $os_defaults_missing to true for unspecified osfamilies
  case $::osfamily {
    'RedHat': {
      $afs_config_path_default    = '/usr/vice/etc'
      $cache_path_default         = '/usr/vice/cache'
      $config_client_dkms_default = true
      $config_client_path_default = '/etc/sysconfig/openafs-client'
      $init_script_default        = '/etc/init.d/openafs-client'
      $init_template_default      = 'openafs-client-RedHat'
      $package_name_default       = [ 'openafs', 'openafs-client', 'openafs-docs', 'openafs-compat', 'openafs-krb5', 'dkms', 'dkms-openafs' ]
    }
    'Suse': {
      $afs_config_path_default    = '/etc/openafs'
      $cache_path_default         = '/var/cache/openafs'
      $config_client_dkms_default = false
      $config_client_path_default = '/etc/sysconfig/openafs-client'
      $init_script_default        = '/etc/init.d/openafs-client'
      $init_template_default      = 'openafs-client-Suse'
      $package_name_default       = [ 'openafs', 'openafs-client', 'openafs-docs', 'openafs-kernel-source', 'openafs-krb5-mit' ]
    }
    'Solaris': {
      $afs_config_path_default    = '/usr/vice/etc'
      $cache_path_default         = '/usr/vice/cache'
      $config_client_dkms_default = false
      $config_client_path_default = '/usr/vice/etc/sysconfig/openafs-client'
      $init_script_default        = '/etc/init.d/openafs-client'
      $init_template_default      = 'openafs-client-Solaris'
      $package_name_default       = [ 'EISopenafs' ]
    }
    'Debian': {
      $afs_config_path_default    = '/etc/openafs'
      $cache_path_default         = '/var/cache/openafs'
      $config_client_dkms_default = true
      $config_client_path_default = '/etc/default/openafs-client'
      $init_script_default        = '/etc/init.d/openafs-client'
      $init_template_default      = 'openafs-client-Ubuntu'
      $package_name_default       = [ 'openafs-modules-dkms', 'openafs-modules-source', 'openafs-client', 'openafs-doc', 'openafs-krb5', 'dkms' ]
    }
    default: {
      $os_defaults_missing = true
    }
  }
  # </define os default values>


  # <USE_DEFAULT vs OS defaults>
  # Check if 'USE_DEFAULTS' is used anywhere without having OS default value
  if (
    ($afs_config_path == 'USE_DEFAULTS') or
    ($cache_path == 'USE_DEFAULTS') or
    ($config_client_dkms == 'USE_DEFAULTS') or
    ($config_client_path == 'USE_DEFAULTS') or
    ($init_script == 'USE_DEFAULTS') or
    ($init_template == 'USE_DEFAULTS') or
    ($package_name == 'USE_DEFAULTS')
  ) and $os_defaults_missing == true {
      fail("Sorry, I don't know default values for ${::osfamily} yet :( Please provide specific values to the afs module.")
  }
  # </USE_DEFAULT vs OS defaults>


  # <assign variables>
  # Change 'USE_DEFAULTS' to OS specific default values
  # Convert strings with booleans to real boolean, if needed
  # Create *_real variables for the rest too

  $afs_cellserverdb_real = $afs_cellserverdb

  $afs_cell_real = $afs_cell

  $afs_config_path_real = $afs_config_path ? {
    'USE_DEFAULTS' => $afs_config_path_default,
    default        => $afs_config_path
  }

  $afs_cron_job_content_real = $afs_cron_job_content

  $afs_cron_job_hour_real = $afs_cron_job_hour

  $afs_cron_job_interval_real = $afs_cron_job_interval

  $afs_cron_job_minute_real = $afs_cron_job_minute

  $afs_cron_job_monthday_real = $afs_cron_job_monthday

  $afs_cron_job_month_real = $afs_cron_job_month

  $afs_cron_job_weekday_real = $afs_cron_job_weekday

  $afs_suidcells_real = $afs_suidcells

  $cache_path_real = $cache_path ? {
    'USE_DEFAULTS' => $cache_path_default,
    default        => $cache_path
  }

  $cache_size_real = $cache_size

  $config_client_args_real = $config_client_args

  if is_bool($config_client_dkms) == true {
    $config_client_dkms_real = $config_client_dkms
  } else {
    $config_client_dkms_real = $config_client_dkms ? {
      'USE_DEFAULTS' => $config_client_dkms_default,
      default        => str2bool($config_client_dkms)
    }
  }

  $config_client_path_real = $config_client_path ? {
    'USE_DEFAULTS' => $config_client_path_default,
    default        => $config_client_path
  }

  if is_bool($config_client_update) == true {
    $config_client_update_real = $config_client_update
  } else {
    $config_client_update_real = str2bool($config_client_update)
  }

  if is_bool($create_symlinks) == true {
    $create_symlinks_real = $create_symlinks
  } else {
    $create_symlinks_real = str2bool($create_symlinks)
  }

  $init_script_real = $init_script ? {
    'USE_DEFAULTS' => $init_script_default,
    default        => $init_script
  }

  $init_template_real = $init_template ? {
    'USE_DEFAULTS' => $init_template_default,
    default        => $init_template
  }

  $package_adminfile_real = $package_adminfile

  $package_name_real = $package_name ? {
    'USE_DEFAULTS' => $package_name_default,
    default        => $package_name
  }

  $package_source_real = $package_source

  $package_provider_real = $package_provider

  $service_provider_real = $service_provider

  if ($::osfamily == 'Solaris') and ($::is_virtual == 'true') and ($::virtual == 'zone') {
    $solaris_container_real = true
  }

  # </assign variables>


  # <validating variables>
  if $afs_cellserverdb_real != undef {
    validate_string($afs_cellserverdb_real)
  }

  if ($afs_cell_real != undef) and (is_domain_name($afs_cell_real) != true) {
    fail('Only domain names are allowed in the afs::afs_cell param.')
  }

  validate_absolute_path($afs_config_path_real)

  if $afs_cron_job_content_real != undef {
    validate_string($afs_cron_job_content_real)
  }

  if ($afs_cron_job_hour_real != undef) and (is_numeric($afs_cron_job_hour_real) != true) {
    fail('Only numbers are allowed in the afs::afs_cron_job_hour param.')
  }

  if $afs_cron_job_interval_real != undef {
    validate_re($afs_cron_job_interval_real, '^(hourly)|(daily)|(weekly)|(monthly)|(specific)$', 'Only <hourly>, <daily>, <weekly>, <monthly> and <specific> are allowed in the afs::afs_cron_job_interval param.')
  }

  if ($afs_cron_job_minute_real != undef) and (is_numeric($afs_cron_job_minute_real) != true) {
    fail('Only numbers are allowed in the afs::afs_cron_job_minute param.')
  }

  if ($afs_cron_job_monthday_real != undef) and (is_numeric($afs_cron_job_monthday_real) != true) {
    fail('Only numbers are allowed in the afs::afs_cron_job_monthday param.')
  }

  if ($afs_cron_job_month_real != undef) and (is_numeric($afs_cron_job_month_real) != true) {
    fail('Only numbers are allowed in the afs::afs_cron_job_month param.')
  }

  if ($afs_cron_job_weekday_real != undef) and (is_numeric($afs_cron_job_weekday_real) != true) {
    fail('Only numbers are allowed in the afs::afs_cron_job_weekday param.')
  }

  if ($afs_suidcells_real != undef) and (is_domain_name($afs_suidcells_real) != true) {
    fail('Only domain names are allowed in the afs::afs_suidcells param.')
  }

  validate_absolute_path($cache_path_real)

  if !is_integer($cache_size_real) {
    fail('Only integers are allowed in the afs::cache_size param.')
  }

  validate_string($config_client_args_real)

  validate_bool($config_client_dkms_real)

  validate_absolute_path($config_client_path_real)

  validate_bool($config_client_update_real)

  validate_bool($create_symlinks_real)

  validate_absolute_path($init_script_real)

  validate_string($init_template_real)


  if $afs_cron_job_content_real != undef {
    validate_string($afs_cron_job_content_real)
  }

  validate_string($package_adminfile_real)

  validate_array($package_name_real)

  if $package_source_real != undef {
    validate_string($package_source_real)
  }

  if $package_provider_real != undef {
    validate_string($package_provider_real)
  }

  if $service_provider_real != undef {
    validate_string($service_provider_real)
  }

  if $solaris_container_real != undef {
    validate_bool($solaris_container_real)
  }

  # </validating variables>


  # <Install & Config>

  if $package_adminfile_real != undef {
    Package {
      adminfile => $package_adminfile_real,
    }
  }

  if $package_provider_real != undef {
    Package {
      provider => $package_provider_real,
    }
  }

  if $package_source_real != undef {
    Package {
      source => $package_source_real,
    }
  }

  package { $package_name_real:
    ensure => installed,
  }

  common::mkdir_p { $afs_config_path_real: }

  file { 'afs_init_script' :
    ensure  => file,
    path    => $init_script_real,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    source  => "puppet:///modules/afs/${init_template_real}",
    require => Package[$package_name_real],
  }

  file { 'afs_config_cacheinfo' :
    ensure  => file,
    path    => "${afs_config_path_real}/cacheinfo",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('afs/cacheinfo.erb'),
    require => Common::Mkdir_p[$afs_config_path_real],
  }

  $config_client_dir_real = dirname($config_client_path_real)

  common::mkdir_p { $config_client_dir_real: }

  file { 'afs_config_client' :
    ensure  => file,
    path    => $config_client_path_real,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('afs/openafs-client.erb'),
    require => [ Package[$package_name_real], Common::Mkdir_p[$config_client_dir_real], ],
  }

  if $afs_suidcells_real != undef {
    file { 'afs_config_suidcells' :
      ensure  => file,
      path    => "${afs_config_path_real}/SuidCells",
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => "${afs_suidcells_real}\n",
      require => Common::Mkdir_p[$afs_config_path_real],
    }
  }

  if $afs_cell_real != undef {
    file { 'afs_config_thiscell' :
      ensure  => file,
      path    => "${afs_config_path_real}/ThisCell",
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => "${afs_cell_real}\n",
      require => Common::Mkdir_p[$afs_config_path_real],
    }
  }

  if $afs_cellserverdb_real != undef {
    file { 'afs_config_cellserverdb' :
      ensure  => file,
      path    => "${afs_config_path_real}/CellServDB",
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => "${afs_cellserverdb_real}\n",
      require => Common::Mkdir_p[$afs_config_path_real],
    }
  }

  # Solaris containers must not start the setserverprefs cronjob.
  if $solaris_container_real != true {
    if ($afs_cron_job_content_real != undef) and ($afs_cron_job_interval_real != undef) {
      if $afs_cron_job_interval_real == 'specific' {
        cron { 'afs_cron_job':
          ensure   => present,
          command  => $afs_cron_job_content_real,
          user     => 'root',
          minute   => $afs_cron_job_minute_real,
          hour     => $afs_cron_job_hour_real,
          month    => $afs_cron_job_month_real,
          weekday  => $afs_cron_job_weekday_real,
          monthday => $afs_cron_job_monthday_real,
          require  => Package[$package_name_real],
        }
      }
      else {
        file { 'afs_cron_job' :
          ensure  => file,
          path    => "/etc/cron.${afs_cron_job_interval_real}/afs_cron_job",
          owner   => 'root',
          group   => 'root',
          mode    => '0755',
          content => $afs_cron_job_content_real,
          require => Package[$package_name_real],
        }
      }
    }
  }

  if $service_provider_real != undef {
    Service {
      provider => $service_provider_real,
    }
  }

  # THIS SERVICE SHOULD NOT BE RESTARTED
  # Restarting it may cause AFS module and kernel problems.
  # Solaris containers must not start the service.
  if $solaris_container_real != true {
    service { 'afs_openafs_client_service':
      ensure     => 'running',
      enable     => true,
      name       => 'openafs-client',
      hasstatus  => false,
      hasrestart => false,
      restart    => '/bin/true',
      require    => Package[$package_name_real],
      status     => '/bin/ps -ef | /bin/grep -i "afsd" | /bin/grep -v "grep"',
    }
  }
  # <Install & Config>


  # <create symlinks>
  if $create_symlinks_real == true {

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
