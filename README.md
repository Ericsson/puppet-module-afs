[![Build Status](https://travis-ci.org/Phil-Friderici/puppet-module-afs.png?branch=master)](https://travis-ci.org/Phil-Friderici/puppet-module-afs)

# puppet-module-afs #
===

Puppet Module to manage OpenAFS

The module installs and configures OpenAFS.

# Compatability #

This module has been tested to work on the following systems.

 * RHEL 6
 * Suse 11

# Parameters #

cache_path
----------
Path to cache storage when using disk cache.
Recommended: use a dedicated partition as disk cache.


- *Default*: 'USE_DEFAULTS', based on OS platform


cache_size
----------
Cache size in kb.
'1000000' = 1GB is a good value for single user systems
'4000000' = 4GB is a good value for terminal servers
ACHTUNG!: real occupied space can be 5% larger, due to metadata

- *Default*: '1000000'


config_cache_path
-----------------
Path to the cacheinfo configuration file.

- *Default*: 'USE_DEFAULTS', based on OS platform


config_client_args
------------------
AFSD_ARGS / parameters to be passed to AFS daemon while starting.
Since 1.6.x the afs-client has integrated auto-tuning. So specifying more options for tuning should only be applied after monitoring the system.
candidates for tuning: -stat, -volumes

- *Default*: '-dynroot -afsdb -daemons 6 -volumes 1000'


config_client_path
------------------
Path to the openafs-client configuration file.

- *Default*: 'USE_DEFAULTS', based on OS platform


packages
--------
Array of needed OpenAFS packages

- *Default*: 'USE_DEFAULTS', based on OS platform


update
------
Trigger for the selfupdating routine in the init script.
If set to true, the init skript checks for updated AFS packages in the available repositories and installs them.

- *Default*: false
