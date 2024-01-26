def platforms
  {
    'RedHat-5-x86_64' =>
      {
        afs_config_path: '/usr/vice/etc',
        cache_path: '/usr/vice/cache',
        config_client_dkms: true,
        config_client_path: '/etc/sysconfig/openafs-client',
        package_name: ['openafs', 'openafs-client', 'openafs-docs', 'openafs-compat', 'openafs-krb5', 'dkms', 'dkms-openafs', 'glibc-devel', 'libgcc.i386'],
        allow_unsupported_modules: false,
      },
    'RedHat-6-x86_64' =>
      {
        afs_config_path: '/usr/vice/etc',
        cache_path: '/usr/vice/cache',
        config_client_dkms: true,
        config_client_path: '/etc/sysconfig/openafs-client',
        package_name: ['openafs', 'openafs-client', 'openafs-docs', 'openafs-compat', 'openafs-krb5', 'dkms', 'dkms-openafs', 'glibc-devel', 'libgcc.i686'],
        allow_unsupported_modules: false,
      },
    'RedHat-7-x86_64' =>
      {
        afs_config_path: '/usr/vice/etc',
        cache_path: '/usr/vice/cache',
        config_client_dkms: true,
        config_client_path: '/etc/sysconfig/openafs-client',
        package_name: ['openafs', 'openafs-client', 'openafs-docs', 'openafs-compat', 'openafs-krb5', 'dkms', 'dkms-openafs', 'glibc-devel', 'libgcc.i686'],
        allow_unsupported_modules: false,
      },
    'RedHat-8-x86_64' =>
      {
        afs_config_path: '/usr/vice/etc',
        cache_path: '/usr/vice/cache',
        config_client_dkms: true,
        config_client_path: '/etc/sysconfig/openafs-client',
        package_name: ['openafs', 'openafs-client', 'openafs-docs', 'openafs-compat', 'openafs-krb5', 'dkms', 'dkms-openafs', 'glibc-devel', 'libgcc.i686'],
        allow_unsupported_modules: false,
      },
    'RedHat-9-x86_64' =>
      {
        afs_config_path: '/usr/vice/etc',
        cache_path: '/usr/vice/cache',
        config_client_dkms: true,
        config_client_path: '/etc/sysconfig/openafs-client',
        package_name: ['openafs', 'openafs-client', 'openafs-docs', 'openafs-compat', 'openafs-krb5', 'dkms', 'dkms-openafs', 'glibc-devel', 'libgcc.i686'],
        allow_unsupported_modules: false,
      },
    'Suse-11-x86_64' =>
      {
        afs_config_path: '/etc/openafs',
        cache_path: '/var/cache/openafs',
        config_client_dkms: false,
        config_client_path: '/etc/sysconfig/openafs-client',
        package_name: ['openafs', 'openafs-client', 'openafs-docs', 'openafs-kernel-source', 'openafs-krb5-mit'],
        allow_unsupported_modules: false,
      },
    'Suse-12-x86_64' =>
      {
        afs_config_path: '/etc/openafs',
        cache_path: '/var/cache/openafs',
        config_client_dkms: false,
        config_client_path: '/etc/sysconfig/openafs-client',
        package_name: ['openafs', 'openafs-client', 'openafs-docs', 'openafs-kernel-source', 'openafs-krb5-mit'],
        allow_unsupported_modules: true,
      },
    'Suse-15-x86_64' =>
      {
        afs_config_path: '/etc/openafs',
        cache_path: '/var/cache/openafs',
        config_client_dkms: false,
        config_client_path: '/etc/sysconfig/openafs-client',
        package_name: ['openafs', 'openafs-client', 'openafs-docs', 'openafs-kernel-source', 'openafs-krb5-mit'],
        allow_unsupported_modules: true,
      },
    'Ubuntu-12.04-amd64' =>
      {
        afs_config_path: '/etc/openafs',
        cache_path: '/var/cache/openafs',
        config_client_dkms: true,
        config_client_path: '/etc/default/openafs-client',
        package_name: ['openafs-modules-dkms', 'openafs-modules-source', 'openafs-client', 'openafs-doc', 'openafs-krb5', 'dkms'],
        allow_unsupported_modules: false,
      },
    'Ubuntu-14.04-amd64' =>
      {
        afs_config_path: '/etc/openafs',
        cache_path: '/var/cache/openafs',
        config_client_dkms: true,
        config_client_path: '/etc/default/openafs-client',
        package_name: ['openafs-modules-dkms', 'openafs-modules-source', 'openafs-client', 'openafs-doc', 'openafs-krb5', 'dkms'],
        allow_unsupported_modules: false,
      },
    'Ubuntu-16.04-amd64' =>
      {
        afs_config_path: '/etc/openafs',
        cache_path: '/var/cache/openafs',
        config_client_dkms: true,
        config_client_path: '/etc/default/openafs-client',
        package_name: ['openafs-modules-dkms', 'openafs-modules-source', 'openafs-client', 'openafs-doc', 'openafs-krb5', 'dkms'],
        allow_unsupported_modules: false,
      },
    'Ubuntu-18.04-amd64' =>
      {
        afs_config_path: '/etc/openafs',
        cache_path: '/var/cache/openafs',
        config_client_dkms: true,
        config_client_path: '/etc/default/openafs-client',
        package_name: ['openafs-modules-dkms', 'openafs-modules-source', 'openafs-client', 'openafs-doc', 'openafs-krb5', 'dkms'],
        allow_unsupported_modules: false,
      },
    'Ubuntu-20.04-amd64' =>
      {
        afs_config_path: '/etc/openafs',
        cache_path: '/var/cache/openafs',
        config_client_dkms: true,
        config_client_path: '/etc/default/openafs-client',
        package_name: ['openafs-modules-dkms', 'openafs-modules-source', 'openafs-client', 'openafs-doc', 'openafs-krb5', 'dkms'],
        allow_unsupported_modules: false,
      },
    'Ubuntu-22.04-amd64' =>
      {
        afs_config_path: '/etc/openafs',
        cache_path: '/var/cache/openafs',
        config_client_dkms: true,
        config_client_path: '/etc/default/openafs-client',
        package_name: ['openafs-modules-dkms', 'openafs-modules-source', 'openafs-client', 'openafs-doc', 'openafs-krb5', 'dkms'],
        allow_unsupported_modules: false,
      },
  }
end
