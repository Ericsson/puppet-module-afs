# A facter fact to determine the installed version of OpenAFS.
module Facter
  module Util
    # Check if the package is installed and read the version if present.
    module AfsVersion
      class << self
        def read_afs_version
          rpm_exists = Facter::Util::Resolution.exec('rpm -q openafs >/dev/null 2>&1 ; echo $?')
          dpkg_exists = Facter::Util::Resolution.exec('dpkg-query -W --showformat=\'${version}\' openafs-client >/dev/null 2>&1 ; echo $?')

          if rpm_exists == '0'
            Facter::Util::Resolution.exec('rpm -q --queryformat=\'%{VERSION}\' openafs')
          elsif dpkg_exists == '0'
            Facter::Util::Resolution.exec('dpkg-query -W --showformat=\'${version}\' openafs-client')
          end
        end
      end
    end
  end
end

Facter.add(:afs_version) do
  setcode { Facter::Util::AfsVersion.read_afs_version }
end
