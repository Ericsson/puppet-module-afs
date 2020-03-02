def platforms
  {
    'redhat-5-x86_64' =>
      {
        facts_hash: {
          os: {
            family: 'RedHat',
            name: 'RedHat',
            release: {
              major: '5',
              full: '5.0',
            },
          },
        },
        afs_config_path: '/usr/vice/etc',
        cache_path: '/usr/vice/cache',
        config_client_dkms: true,
        config_client_path: '/etc/sysconfig/openafs-client',
        init_script: '/etc/init.d/openafs-client',
        init_template: 'openafs-client-RedHat-init',
        package_name: ['openafs', 'openafs-client', 'openafs-docs', 'openafs-compat', 'openafs-krb5', 'dkms', 'dkms-openafs', 'glibc-devel', 'libgcc.i386'],
        allow_unsupported_modules: false,
      },
    'redhat-6-x86_64' =>
      {
        facts_hash: {
          os: {
            family: 'RedHat',
            name: 'RedHat',
            release: {
              major: '6',
              full: '6.0',
            },
          },
        },
        afs_config_path: '/usr/vice/etc',
        cache_path: '/usr/vice/cache',
        config_client_dkms: true,
        config_client_path: '/etc/sysconfig/openafs-client',
        init_script: '/etc/init.d/openafs-client',
        init_template: 'openafs-client-RedHat-init',
        package_name: ['openafs', 'openafs-client', 'openafs-docs', 'openafs-compat', 'openafs-krb5', 'dkms', 'dkms-openafs', 'glibc-devel', 'libgcc.i686'],
        allow_unsupported_modules: false,
      },
    'redhat-7-x86_64' =>
      {
        facts_hash: {
          os: {
            family: 'RedHat',
            name: 'RedHat',
            release: {
              major: '7',
              full: '7.0',
            },
          },
        },
        afs_config_path: '/usr/vice/etc',
        cache_path: '/usr/vice/cache',
        config_client_dkms: true,
        config_client_path: '/etc/sysconfig/openafs-client',
        init_script: '/etc/init.d/openafs-client',
        init_template: 'openafs-client-RedHat-init',
        systemd_unit_template: 'openafs-client-RedHat-systemd-sysv.service',
        package_name: ['openafs', 'openafs-client', 'openafs-docs', 'openafs-compat', 'openafs-krb5', 'dkms', 'dkms-openafs', 'glibc-devel', 'libgcc.i686'],
        allow_unsupported_modules: false,
      },
    'redhat-8-x86_64' =>
      {
        facts_hash: {
          os: {
            family: 'RedHat',
            name: 'RedHat',
            release: {
              major: '8',
              full: '8.0',
            },
          },
        },
        kernel: 'Linux',
        afs_config_path: '/usr/vice/etc',
        cache_path: '/usr/vice/cache',
        config_client_dkms: true,
        config_client_path: '/etc/sysconfig/openafs-client',
        service_provider: 'systemd',
        init_script: '/etc/init.d/openafs-client',
        systemd_script_template: 'openafs-client-RedHat-systemd-exec',
        systemd_unit_template: 'openafs-client-RedHat-systemd-exec.service',
        package_name: ['openafs', 'openafs-client', 'openafs-docs', 'openafs-compat', 'openafs-krb5', 'dkms', 'dkms-openafs', 'glibc-devel', 'libgcc.i686'],
        allow_unsupported_modules: false,
      },
    'centos-5-x86_64' =>
      {
        facts_hash: {
          os: {
            family: 'RedHat',
            name: 'RedHat',
            release: {
              major: '5',
              full: '5.0',
            },
          },
        },
        afs_config_path: '/usr/vice/etc',
        cache_path: '/usr/vice/cache',
        config_client_dkms: true,
        config_client_path: '/etc/sysconfig/openafs-client',
        init_script: '/etc/init.d/openafs-client',
        init_template: 'openafs-client-RedHat-init',
        package_name: ['openafs', 'openafs-client', 'openafs-docs', 'openafs-compat', 'openafs-krb5', 'dkms', 'dkms-openafs', 'glibc-devel', 'libgcc.i386'],
        allow_unsupported_modules: false,
      },
    'centos-6-x86_64' =>
      {
        facts_hash: {
          os: {
            family: 'RedHat',
            name: 'CentOS',
            release: {
              major: '6',
              full: '6.0',
            },
          },
        },
        afs_config_path: '/usr/vice/etc',
        cache_path: '/usr/vice/cache',
        config_client_dkms: true,
        config_client_path: '/etc/sysconfig/openafs-client',
        init_script: '/etc/init.d/openafs-client',
        init_template: 'openafs-client-RedHat-init',
        package_name: ['openafs', 'openafs-client', 'openafs-docs', 'openafs-compat', 'openafs-krb5', 'dkms', 'dkms-openafs', 'glibc-devel', 'libgcc.i686'],
        allow_unsupported_modules: false,
      },
    'centos-7-x86_64' =>
      {
        facts_hash: {
          os: {
            family: 'RedHat',
            name: 'CentOS',
            release: {
              major: '7',
              full: '7.0',
            },
          },
        },
        afs_config_path: '/usr/vice/etc',
        cache_path: '/usr/vice/cache',
        config_client_dkms: true,
        config_client_path: '/etc/sysconfig/openafs-client',
        init_script: '/etc/init.d/openafs-client',
        init_template: 'openafs-client-RedHat-init',
        systemd_unit_template: 'openafs-client-RedHat-systemd-sysv.service',
        package_name: ['openafs', 'openafs-client', 'openafs-docs', 'openafs-compat', 'openafs-krb5', 'dkms', 'dkms-openafs', 'glibc-devel', 'libgcc.i686'],
        allow_unsupported_modules: false,
      },
    'centos-8-x86_64' =>
      {
        facts_hash: {
          os: {
            family: 'RedHat',
            name: 'CentOS',
            release: {
              major: '8',
              full: '8.0',
            },
          },
        },
        kernel: 'Linux',
        afs_config_path: '/usr/vice/etc',
        cache_path: '/usr/vice/cache',
        config_client_dkms: true,
        config_client_path: '/etc/sysconfig/openafs-client',
        service_provider: 'systemd',
        init_script: '/etc/init.d/openafs-client',
        systemd_script_template: 'openafs-client-RedHat-systemd-exec',
        systemd_unit_template: 'openafs-client-RedHat-systemd-exec.service',
        package_name: ['openafs', 'openafs-client', 'openafs-docs', 'openafs-compat', 'openafs-krb5', 'dkms', 'dkms-openafs', 'glibc-devel', 'libgcc.i686'],
        allow_unsupported_modules: false,
      },
    'oraclelinux-5-x86_64' =>
      {
        facts_hash: {
          os: {
            family: 'RedHat',
            name: 'OracleLinux',
            release: {
              major: '5',
              full: '5.0',
            },
          },
        },
        afs_config_path: '/usr/vice/etc',
        cache_path: '/usr/vice/cache',
        config_client_dkms: true,
        config_client_path: '/etc/sysconfig/openafs-client',
        init_script: '/etc/init.d/openafs-client',
        init_template: 'openafs-client-RedHat-init',
        package_name: ['openafs', 'openafs-client', 'openafs-docs', 'openafs-compat', 'openafs-krb5', 'dkms', 'dkms-openafs', 'glibc-devel', 'libgcc.i386'],
        allow_unsupported_modules: false,
      },
    'oraclelinux-6-x86_64' =>
      {
        facts_hash: {
          os: {
            family: 'RedHat',
            name: 'OracleLinux',
            release: {
              major: '6',
              full: '6.0',
            },
          },
        },
        afs_config_path: '/usr/vice/etc',
        cache_path: '/usr/vice/cache',
        config_client_dkms: true,
        config_client_path: '/etc/sysconfig/openafs-client',
        init_script: '/etc/init.d/openafs-client',
        init_template: 'openafs-client-RedHat-init',
        package_name: ['openafs', 'openafs-client', 'openafs-docs', 'openafs-compat', 'openafs-krb5', 'dkms', 'dkms-openafs', 'glibc-devel', 'libgcc.i686'],
        allow_unsupported_modules: false,
      },
    'oraclelinux-7-x86_64' =>
      {
        facts_hash: {
          os: {
            family: 'RedHat',
            name: 'OracleLinux',
            release: {
              major: '7',
              full: '7.0',
            },
          },
        },
        afs_config_path: '/usr/vice/etc',
        cache_path: '/usr/vice/cache',
        config_client_dkms: true,
        config_client_path: '/etc/sysconfig/openafs-client',
        init_script: '/etc/init.d/openafs-client',
        init_template: 'openafs-client-RedHat-init',
        systemd_unit_template: 'openafs-client-RedHat-systemd-sysv.service',
        package_name: ['openafs', 'openafs-client', 'openafs-docs', 'openafs-compat', 'openafs-krb5', 'dkms', 'dkms-openafs', 'glibc-devel', 'libgcc.i686'],
        allow_unsupported_modules: false,
      },
    'oraclelinux-8-x86_64' =>
      {
        facts_hash: {
          os: {
            family: 'RedHat',
            name: 'OracleLinux',
            release: {
              major: '8',
              full: '8.0',
            },
          },
        },
        kernel: 'Linux',
        afs_config_path: '/usr/vice/etc',
        cache_path: '/usr/vice/cache',
        config_client_dkms: true,
        config_client_path: '/etc/sysconfig/openafs-client',
        service_provider: 'systemd',
        init_script: '/etc/init.d/openafs-client',
        systemd_script_template: 'openafs-client-RedHat-systemd-exec',
        systemd_unit_template: 'openafs-client-RedHat-systemd-exec.service',
        package_name: ['openafs', 'openafs-client', 'openafs-docs', 'openafs-compat', 'openafs-krb5', 'dkms', 'dkms-openafs', 'glibc-devel', 'libgcc.i686'],
        allow_unsupported_modules: false,
      },
    'scientific-5-x86_64' =>
      {
        facts_hash: {
          os: {
            family: 'RedHat',
            name: 'Scientific',
            release: {
              major: '5',
              full: '5.0',
            },
          },
        },
        afs_config_path: '/usr/vice/etc',
        cache_path: '/usr/vice/cache',
        config_client_dkms: true,
        config_client_path: '/etc/sysconfig/openafs-client',
        init_script: '/etc/init.d/openafs-client',
        init_template: 'openafs-client-RedHat-init',
        package_name: ['openafs', 'openafs-client', 'openafs-docs', 'openafs-compat', 'openafs-krb5', 'dkms', 'dkms-openafs', 'glibc-devel', 'libgcc.i386'],
        allow_unsupported_modules: false,
      },
    'scientific-6-x86_64' =>
      {
        facts_hash: {
          os: {
            family: 'RedHat',
            name: 'Scientific',
            release: {
              major: '6',
              full: '6.0',
            },
          },
        },
        afs_config_path: '/usr/vice/etc',
        cache_path: '/usr/vice/cache',
        config_client_dkms: true,
        config_client_path: '/etc/sysconfig/openafs-client',
        init_script: '/etc/init.d/openafs-client',
        init_template: 'openafs-client-RedHat-init',
        package_name: ['openafs', 'openafs-client', 'openafs-docs', 'openafs-compat', 'openafs-krb5', 'dkms', 'dkms-openafs', 'glibc-devel', 'libgcc.i686'],
        allow_unsupported_modules: false,
      },
    'scientific-7-x86_64' =>
      {
        facts_hash: {
          os: {
            family: 'RedHat',
            name: 'Scientific',
            release: {
              major: '7',
              full: '7.0',
            },
          },
        },
        afs_config_path: '/usr/vice/etc',
        cache_path: '/usr/vice/cache',
        config_client_dkms: true,
        config_client_path: '/etc/sysconfig/openafs-client',
        init_script: '/etc/init.d/openafs-client',
        init_template: 'openafs-client-RedHat-init',
        systemd_unit_template: 'openafs-client-RedHat-systemd-sysv.service',
        package_name: ['openafs', 'openafs-client', 'openafs-docs', 'openafs-compat', 'openafs-krb5', 'dkms', 'dkms-openafs', 'glibc-devel', 'libgcc.i686'],
        allow_unsupported_modules: false,
      },
    'scientific-8-x86_64' =>
      {
        facts_hash: {
          os: {
            family: 'RedHat',
            name: 'Scientific',
            release: {
              major: '8',
              full: '8.0',
            },
          },
        },
        kernel: 'Linux',
        afs_config_path: '/usr/vice/etc',
        cache_path: '/usr/vice/cache',
        config_client_dkms: true,
        config_client_path: '/etc/sysconfig/openafs-client',
        service_provider: 'systemd',
        init_script: '/etc/init.d/openafs-client',
        systemd_script_template: 'openafs-client-RedHat-systemd-exec',
        systemd_unit_template: 'openafs-client-RedHat-systemd-exec.service',
        package_name: ['openafs', 'openafs-client', 'openafs-docs', 'openafs-compat', 'openafs-krb5', 'dkms', 'dkms-openafs', 'glibc-devel', 'libgcc.i686'],
        allow_unsupported_modules: false,
      },
    'sles-11-x86_64' =>
      {
        facts_hash: {
          os: {
            family: 'Suse',
            name: 'SLES',
            release: {
              major: '11',
              full: '11.0',
            },
          },
        },
        afs_config_path: '/etc/openafs',
        cache_path: '/var/cache/openafs',
        config_client_dkms: false,
        config_client_path: '/etc/sysconfig/openafs-client',
        init_script: '/etc/init.d/openafs-client',
        init_template: 'openafs-client-Suse-init',
        package_name: ['openafs', 'openafs-client', 'openafs-docs', 'openafs-kernel-source', 'openafs-krb5-mit'],
        allow_unsupported_modules: false,
      },
    'sles-12-x86_64' =>
      {
        facts_hash: {
          os: {
            family: 'Suse',
            name: 'SLES',
            release: {
              major: '12',
              full: '12.0',
            },
          },
        },
        afs_config_path: '/etc/openafs',
        cache_path: '/var/cache/openafs',
        config_client_dkms: false,
        config_client_path: '/etc/sysconfig/openafs-client',
        init_script: '/etc/init.d/openafs-client',
        init_template: 'openafs-client-Suse-init',
        systemd_unit_template: 'openafs-client-Suse-systemd-sysv.service',
        package_name: ['openafs', 'openafs-client', 'openafs-docs', 'openafs-kernel-source', 'openafs-krb5-mit'],
        allow_unsupported_modules: true,
      },
    'sles-15-x86_64' =>
      {
        facts_hash: {
          os: {
            family: 'Suse',
            name: 'SLES',
            release: {
              major: '15',
              full: '15.0',
            },
          },
        },
        afs_config_path: '/etc/openafs',
        cache_path: '/var/cache/openafs',
        config_client_dkms: false,
        config_client_path: '/etc/sysconfig/openafs-client',
        init_script: '/etc/init.d/openafs-client',
        systemd_script_template: 'openafs-client-Suse-systemd-exec',
        systemd_unit_template: 'openafs-client-Suse-systemd-exec.service',
        package_name: ['openafs', 'openafs-client', 'openafs-docs', 'openafs-kernel-source', 'openafs-krb5-mit'],
        allow_unsupported_modules: true,
      },
    'sled-11-x86_64' =>
      {
        facts_hash: {
          os: {
            family: 'Suse',
            name: 'SLED',
            release: {
              major: '11',
              full: '11.0',
            },
          },
        },
        afs_config_path: '/etc/openafs',
        cache_path: '/var/cache/openafs',
        config_client_dkms: false,
        config_client_path: '/etc/sysconfig/openafs-client',
        init_script: '/etc/init.d/openafs-client',
        init_template: 'openafs-client-Suse-init',
        package_name: ['openafs', 'openafs-client', 'openafs-docs', 'openafs-kernel-source', 'openafs-krb5-mit'],
        allow_unsupported_modules: false,
      },
    'sled-12-x86_64' =>
      {
        facts_hash: {
          os: {
            family: 'Suse',
            name: 'SLED',
            release: {
              major: '12',
              full: '12.0',
            },
          },
        },
        afs_config_path: '/etc/openafs',
        cache_path: '/var/cache/openafs',
        config_client_dkms: false,
        config_client_path: '/etc/sysconfig/openafs-client',
        init_script: '/etc/init.d/openafs-client',
        init_template: 'openafs-client-Suse-init',
        systemd_unit_template: 'openafs-client-Suse-systemd-sysv.service',
        package_name: ['openafs', 'openafs-client', 'openafs-docs', 'openafs-kernel-source', 'openafs-krb5-mit'],
        allow_unsupported_modules: true,
      },
    'sled-15-x86_64' =>
      {
        facts_hash: {
          os: {
            family: 'Suse',
            name: 'SLED',
            release: {
              major: '15',
              full: '15.0',
            },
          },
        },
        afs_config_path: '/etc/openafs',
        cache_path: '/var/cache/openafs',
        config_client_dkms: false,
        config_client_path: '/etc/sysconfig/openafs-client',
        init_script: '/etc/init.d/openafs-client',
        systemd_script_template: 'openafs-client-Suse-systemd-exec',
        systemd_unit_template: 'openafs-client-Suse-systemd-exec.service',
        package_name: ['openafs', 'openafs-client', 'openafs-docs', 'openafs-kernel-source', 'openafs-krb5-mit'],
        allow_unsupported_modules: true,
      },
    'ubuntu-12.04-x86_64' =>
      {
        facts_hash: {
          os: {
            family: 'Debian',
            name: 'Ubuntu',
            release: {
              major: '12.04',
              full: '12.04',
            },
          },
        },
        afs_config_path: '/etc/openafs',
        cache_path: '/var/cache/openafs',
        config_client_dkms: true,
        config_client_path: '/etc/default/openafs-client',
        init_script: '/etc/init.d/openafs-client',
        init_template: 'openafs-client-Ubuntu-init',
        package_name: ['openafs-modules-dkms', 'openafs-modules-source', 'openafs-client', 'openafs-doc', 'openafs-krb5', 'dkms'],
        allow_unsupported_modules: false,
      },
    'ubuntu-14.04-x86_64' =>
      {
        facts_hash: {
          os: {
            family: 'Debian',
            name: 'Ubuntu',
            release: {
              major: '14.04',
              full: '14.04',
            },
          },
        },
        afs_config_path: '/etc/openafs',
        cache_path: '/var/cache/openafs',
        config_client_dkms: true,
        config_client_path: '/etc/default/openafs-client',
        init_script: '/etc/init.d/openafs-client',
        init_template: 'openafs-client-Ubuntu-init',
        package_name: ['openafs-modules-dkms', 'openafs-modules-source', 'openafs-client', 'openafs-doc', 'openafs-krb5', 'dkms'],
        allow_unsupported_modules: false,
      },
    'ubuntu-16.04-x86_64' =>
      {
        facts_hash: {
          os: {
            family: 'Debian',
            name: 'Ubuntu',
            release: {
              major: '16.04',
              full: '16.04',
            },
          },
        },
        afs_config_path: '/etc/openafs',
        cache_path: '/var/cache/openafs',
        config_client_dkms: true,
        config_client_path: '/etc/default/openafs-client',
        init_script: '/etc/init.d/openafs-client',
        init_template: 'openafs-client-Ubuntu-init',
        package_name: ['openafs-modules-dkms', 'openafs-modules-source', 'openafs-client', 'openafs-doc', 'openafs-krb5', 'dkms'],
        allow_unsupported_modules: false,
      },
    'ubuntu-18.04-x86_64' =>
      {
        facts_hash: {
          os: {
            family: 'Debian',
            name: 'Ubuntu',
            release: {
              major: '18.04',
              full: '18.04',
            },
          },
        },
        afs_config_path: '/etc/openafs',
        cache_path: '/var/cache/openafs',
        config_client_dkms: true,
        config_client_path: '/etc/default/openafs-client',
        init_script: '/etc/init.d/openafs-client',
        init_template: 'openafs-client-Ubuntu-init',
        package_name: ['openafs-modules-dkms', 'openafs-modules-source', 'openafs-client', 'openafs-doc', 'openafs-krb5', 'dkms'],
        allow_unsupported_modules: false,
      },
    'solaris-10-i86pc' =>
      {
        facts_hash: {
          os: {
            family: 'Solaris',
            name: 'Solaris',
            release: {
              major: '10',
              full: '10_u8',
            },
          },
        },
        afs_config_path: '/usr/vice/etc',
        cache_path: '/usr/vice/cache',
        config_client_dkms: false,
        config_client_path: '/usr/vice/etc/sysconfig/openafs-client',
        init_script: '/etc/init.d/openafs-client',
        init_template: 'openafs-client-Solaris',
        package_name: ['EISopenafs'],
        allow_unsupported_modules: false,
      },
  }
end
