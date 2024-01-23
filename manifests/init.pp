# afs class
#
# @summary This module manages OpenAFS
#
# @example Declaring the class
#   include ::afs
#
# @param afs_cellserverdb
#   String defining CellServDB. Content of file $afs_config_path/CellServDB.
#   This file will be ignored if the default value is not changed.
#
# @param afs_cell
#   String defining ThisCell. Content of the file $afs_config_path/ThisCell.
#   This file will be ignored if the default value is not changed.
#
# @param afs_config_path
#   Path to the OpenAFS config directory.
#
# @param afs_cron_job_content
#   String with OpenAFS cron job command. Example: '[ -x /afs_maintenance.sh ] && /afs_maintenance.sh'
#   Do not use multi line content when $afs_cron_job_interval is set to 'specific'.
#
# @param afs_cron_job_hour
#   The hour at which to run the cron job.
#   If set to <undef> it will become '*' at creation time.
#
# @param afs_cron_job_interval
#   String to specify when to run the cron job.
#   Set to 'specific' to create cron jobs. It uses $afs_cron_job_minute/hour/weekday/month/monthday
#   to specify when to run the cron job.
#   On systems that support fragment files in /etc/cron.(hourly|daily|weekly|monthly) you can use
#   This module can only create or change cron jobs, there is no housekeeping support to delete them.
#
# @param afs_cron_job_minute
#   Integer within specific boundaries. The minute at which to run the cron job.
#   ACHTUNG: If set to <undef> it will become '*' at creation time.
#
# @param afs_cron_job_monthday
#   Integer within specific boundaries. The day of the month on which to run the cron job.
#   If set to <undef> it will become '*' at creation time.
#
# @param afs_cron_job_month
#   Integer within specific boundaries. The month of the year in which to run the cron job.
#   If set to <undef> it will become '*' at creation time.
#
# @param afs_cron_job_weekday
#   Integer within specific boundaries. The weekday on which to run the cron job. 0 and 7 are both for Sundays.
#   If set to <undef> it will become '*' at creation time.
#
# @param afs_suidcells
#   Array of strings with content of the file $afs_config_path/SuidCells.
#   This file will be ignored if the default value is not changed.
#
# @param cache_path
#   Path to cache storage when using disk cache.
#   Recommended: use a dedicated partition as disk cache.
#
# @param cache_size
#   Cache size in kb.
#   '1000000' = 1GB is a good value for single user systems
#   '4000000' = 4GB is a good value for terminal servers
#   ACHTUNG!: real occupied space can be 5% larger, due to metadata
#
# @param config_client_args
#   AFSD_ARGS / parameters to be passed to AFS daemon while starting.
#   Since 1.6.x the afs-client has integrated auto-tuning.
#   Specifying more options for tuning should only be applied after monitoring the system.
#   Candidates for tuning: -stat, -volumes
#
# @param config_client_clean_cache_on_start
#   Boolean trigger for the cleaning of the client cache on start.
#   If set to true, client cache will be cleaned when starting the service.
#   Please check openafs-client config file for supported OS families.
#
# @param config_client_dkms
#   Boolean to control the AFS kernel module handling via DKMS or the openafs start-script.
#   At the moment only available on RHEL platform. It will be ignored on other platforms.
#
# @param config_client_path
#   Path to the openafs-client configuration file.
#
# @param config_client_update
#   Boolean trigger for the selfupdating routine in the start script.
#   If set to true, checks for updated AFS packages in the available repositories and installs them.
#
# @param create_symlinks
#   Create symlinks for convenient access to AFS structure. Path and target are taken from hash in $links.
#
# @param links
#   Hash of path and target to create symlinks from if $create_links is true.
#
# @param package_adminfile
#   Solaris specific: string with adminfile.
#
# @param package_name
#   Array or string of needed OpenAFS packages.
#
# @param package_provider
#   Solaris specific: string with package source.
#
# @param package_source
#   Solaris specific: string with package source.
#
# @param service_provider
#   String of which service provider should be used
#
class afs (
  Optional[String]          $afs_cellserverdb                   = undef,
  Optional[String]          $afs_cell                           = undef,
  Stdlib::Unixpath          $afs_config_path                    = undef,
  Optional[String]          $afs_cron_job_content               = undef,
  Optional[Enum['hourly', 'daily', 'weekly', 'monthly', 'specific']] $afs_cron_job_interval = undef,
  Integer[0, 59]            $afs_cron_job_minute                = 42,
  Optional[Integer[0, 23]]  $afs_cron_job_hour                  = undef,
  Optional[Integer[1, 31]]  $afs_cron_job_monthday              = undef,
  Optional[Integer[1, 12]]  $afs_cron_job_month                 = undef,
  Optional[Integer[0, 7]]   $afs_cron_job_weekday               = undef,
  Variant[Array[String], String] $afs_suidcells                 = [],
  Stdlib::Unixpath          $cache_path                         = undef,
  Integer                   $cache_size                         = 1000000,
  String                    $config_client_args                 = '-dynroot -afsdb -daemons 6 -volumes 1000',
  Boolean                   $config_client_clean_cache_on_start = false,
  Boolean                   $config_client_dkms                 = undef,
  Stdlib::Unixpath          $config_client_path                 = undef,
  Boolean                   $config_client_update               = false,
  Boolean                   $create_symlinks                    = false,
  Hash                      $links                              = {},
  Optional[String]          $package_adminfile                  = undef,
  Variant[Array[String], String] $package_name                  = undef,
  Optional[String]          $package_provider                   = undef,
  Optional[String]          $package_source                     = undef,
  Optional[String]          $service_provider                   = undef,
) {
  $afs_suidcells_array = any2array($afs_suidcells)
  $config_client_dir = dirname($config_client_path)

  if $facts['os']['family'] == 'Solaris' and $facts['is_virtual'] == true and $facts['virtual'] == 'zone' {
    $solaris_container = true
  }
  else {
    $solaris_container = false
  }

  # TODO: Replace with Stdlib::Fqdn
  afs::validate_domain_names { $afs_suidcells_array: }

  $package_before = [
    File[afs_config_cacheinfo],
    File[afs_config_client],
  ]
  $service_require = [
    File[afs_config_cacheinfo],
    File[afs_config_client],
  ]

  if $package_adminfile != undef {
    Package {
      adminfile => $package_adminfile,
    }
  }

  if $package_provider != undef {
    Package {
      provider => $package_provider,
    }
  }

  if $package_source != undef {
    Package {
      source => $package_source,
    }
  }

  package { $package_name:
    ensure => installed,
    before => $package_before,
  }

  common::mkdir_p { $afs_config_path: }
  common::mkdir_p { $config_client_dir: }

  if $solaris_container == false {
    File {
      before => Service[afs_openafs_client_service],
    }
  }

  if ($facts['os']['family'] == 'Suse' and $facts['os']['release']['major'] =~ /12|15/) {
    # Since Suse 15.4 the file /etc/modprobe.d/10-unsupported-modules.conf isn't created automatically anymore.
    # So we need to create that file ourself. An alternative approach could be to use the kmod module.
    if versioncmp($facts['os']['release']['full'], '15.3') == 1 { # Suse version is greater than 15.3
      file { '/etc/modprobe.d/10-unsupported-modules.conf' :
        ensure => 'file',
        path   => '/etc/modprobe.d/10-unsupported-modules.conf',
        owner  => 'root',
        group  => 'root',
        mode   => '0644',
        before => 'File_line[allow_unsupported_modules]',
      }
    }

    file_line { 'allow_unsupported_modules':
      ensure => 'present',
      path   => '/etc/modprobe.d/10-unsupported-modules.conf',
      line   => 'allow_unsupported_modules 1',
      match  => '^allow_unsupported_modules 0$',
      before => 'Service[afs_openafs_client_service]',
    }
  }

  file { 'afs_config_cacheinfo' :
    ensure  => file,
    path    => "${afs_config_path}/cacheinfo",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('afs/cacheinfo.erb'),
    require => Common::Mkdir_p[$afs_config_path],
  }

  file { 'afs_config_client' :
    ensure  => file,
    path    => $config_client_path,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('afs/openafs-client.erb'),
    require => Common::Mkdir_p[$config_client_dir],
  }

  if empty($afs_suidcells_array) == false {
    file { 'afs_config_suidcells' :
      ensure  => file,
      path    => "${afs_config_path}/SuidCells",
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('afs/suidcells.erb'),
      require => Common::Mkdir_p[$afs_config_path],
    }
  }

  if $afs_cell != undef {
    file { 'afs_config_thiscell' :
      ensure  => file,
      path    => "${afs_config_path}/ThisCell",
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => "${afs_cell}\n",
      require => Common::Mkdir_p[$afs_config_path],
    }
  }

  if $afs_cellserverdb != undef {
    file { 'afs_config_cellserverdb' :
      ensure  => file,
      path    => "${afs_config_path}/CellServDB",
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => "${afs_cellserverdb}\n",
      require => Common::Mkdir_p[$afs_config_path],
    }
  }

  if $service_provider {
    Service {
      provider => $service_provider,
    }
  }

  # Solaris containers must not start the service nor add setserverprefs cronjob.
  if $solaris_container == false {
    # THIS SERVICE SHOULD NOT BE RESTARTED
    # Restarting it may cause AFS module and kernel problems.
    service { 'afs_openafs_client_service':
      ensure     => 'running',
      enable     => true,
      name       => 'openafs-client',
      hasstatus  => false,
      hasrestart => false,
      restart    => '/bin/true',
      status     => '/bin/ps -ef | /bin/grep -i "afsd" | /bin/grep -v "grep"',
      require    => $service_require,
    }

    if ($afs_cron_job_content != undef) and ($afs_cron_job_interval != undef) {
      if $afs_cron_job_interval == 'specific' {
        cron { 'afs_cron_job':
          ensure   => present,
          command  => $afs_cron_job_content,
          user     => 'root',
          minute   => $afs_cron_job_minute,
          hour     => $afs_cron_job_hour,
          month    => $afs_cron_job_month,
          weekday  => $afs_cron_job_weekday,
          monthday => $afs_cron_job_monthday,
        }
      }
      else {
        file { 'afs_cron_job' :
          ensure  => file,
          path    => "/etc/cron.${afs_cron_job_interval}/afs_cron_job",
          owner   => 'root',
          group   => 'root',
          mode    => '0755',
          content => $afs_cron_job_content,
        }
      }
    }
  }

  if $create_symlinks == true {
    $afs_create_link_defaults = {
      'ensure' => 'link',
      'owner'  => 'root',
      'group'  => 'root',
      'mode'   => '0755',
    }

    create_resources(file, $links, $afs_create_link_defaults)
  }
}
