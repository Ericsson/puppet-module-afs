# puppet-module-afs

#### Table of Contents

1. [Module Description - What the module does and why it is useful](#module-description)
1. [Setup - The basics of getting started with afs](#setup)
   * [What afs affects](#what-afs-affects)
   * [Setup requirements](#setup-requirements)
   * [Beginning with afs](#beginning-with-afs)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - Parameter reference](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Module description

This module manages the OpenAFS client: it installs the required packages and
manages the configuration files (`ThisCell`, `CellServDB`, `cacheinfo`, the
openafs-client config and optional `SuidCells`, symlinks and cron jobs).
Package names and file locations vary by platform and are driven by the
module's Hiera data for RedHat/EL, Suse and Ubuntu.

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
OpenAFS correctly:

* `afs::afs_cell`
* `afs::afs_cellserverdb`

```yaml
afs::afs_cell: afs.domain.tld
afs::afs_cellserverdb: |
  >afs.domain.tld
```

OpenAFS will be configured with ThisCell `afs.domain.tld` with CellServDB
`afs.domain.tld`.

On Enterprise Linux (RedHat family) the CellServDB content is written to
`/usr/vice/etc/CellServDB.local` instead of the active `/usr/vice/etc/CellServDB`.
The openafs-client start script merges `CellServDB.local` and `CellServDB.dist`
into the active `CellServDB`, so the active file is only regenerated when the
cell content changes and is not overwritten on every client restart. On other
platforms the active `CellServDB` is managed directly.

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

## Reference

This module is documented via [puppet-strings](https://github.com/puppetlabs/puppet-strings).
See [REFERENCE.md](REFERENCE.md) for the full list of classes, defined types
and all of their parameters.

## Limitations

This module supports Puppet 8 (see `metadata.json` for the exact requirement).
It is tested against the operating systems listed below. The supported OS
matrix is defined in `metadata.json`, and CI runs `pdk validate` and
`pdk test unit` on Puppet 8 via GitHub Actions (see `.github/workflows/`).

 * RedHat / CentOS / OracleLinux / Scientific (EL) 5, 6, 7, 8, 9
 * RedHat (EL) 10
 * SLES / SLED 10, 11, 12, 15
 * Ubuntu 12.04, 14.04, 16.04, 18.04, 20.04, 22.04, 24.04

Note: CentOS, OracleLinux and Scientific follow the EL releases listed in
`metadata.json`; EL 10 is currently RedHat only. Other operating systems might
be supported by configuring the module with the correct parameters.

## Development

Contributions are welcome. This module is managed with
[PDK](https://www.puppet.com/docs/pdk). Before submitting changes, run the
validators and unit tests:

```bash
pdk validate
pdk test unit
```

Please keep `REFERENCE.md` in sync by regenerating it from the class
documentation when parameters change:

```bash
pdk bundle exec puppet strings generate --format markdown
```
