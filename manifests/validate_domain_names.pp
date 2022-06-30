# == Define: afs::validate_domain_names
# iteration in Puppet 3 style
#
define afs::validate_domain_names {
  validate_domain_name($name)
}
