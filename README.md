# puppet-module-afs

#### Table of Contents

1. [Module Description - What the module does and why it is useful](#module-description)
1. [Setup - The basics of getting started with afs](#setup)
   * [What afs affects](#what-afs-affects)
   * [Setup requirements](#setup-requirements)
   * [Beginning with afs](#beginning-with-afs)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Module description

This module manages OpenAFS

## Setup

### What afs affects

Manages the packages and files regarding OpenAFS. Location of these files vary
by platform and packages being used to install OpenAFS.

### Setup requirements

This module requires `stdlib`,`cron_core` and `common` (see metadata.json).

### Beginning with afs

Include the main `::afs` class. Default values for supported operating systems
are specified in the module's Hiera.

#### Basic usage

There are a few parameters that are required for the AFS module to configure
OpenAFS correctly.
afs::cell
afs::afs_cellserverdb

```yaml
afs::cell: afs.domain.tld
afs::afs_cellserverdb: |
  >afs.domain.tld
```

OpenAFS will be configured with ThisCell `afs.domain.tld` with CellServDB
`afs.domain.tld`.

#### Manage symlinks for AFS

Symlinks can be created if required.

```yaml
afs::links:
  'app':
    path:   '/app'
    target: '/afs/some/path/app'
  'env':
    path:   '/env'
    target: '/afs/some/path/env'
  'etc_home':
     path:   '/etc/home'
     target: '/env/site/profiles/home'
```

This would create the following symlinks:

```
/app -> /afs/some/path/app
/env -> /afs/some/path/env
/etc/home -> /env/site/profiles/home
```

## Limitations

This module has been tested to work on the following systems with Puppet
versions 5 and 6 with the Ruby version associated with those releases.
Please see `.travis.yml` for a full matrix of supported versions.
This module aims to support the current and previous major Puppet versions.

 * EL 5
 * EL 6
 * EL 7
 * EL 8
 * EL 9
 * Suse 10
 * Suse 11
 * Suse 12
 * Suse 15
 * Ubuntu 12.04
 * Ubuntu 14.04
 * Ubuntu 16.04
 * Ubuntu 18.04
 * Ubuntu 20.04
 * Ubuntu 22.04

Other operating systems might be supported by configuring the module with the
correct parameters.
