# A facter fact to determine the installed version of OpenAFS.
# Check if the package is installed and read the version if present.
module Facter::Util::AfsVersion
  class << self
    def read_afs_version
      # on_fail: nil preserves the previous Facter::Util::Resolution.exec
      # behaviour of returning nil instead of raising when a command is
      # missing or fails (e.g. rpm/dpkg not present on the platform).
      rpm_exists = Facter::Core::Execution.execute('rpm -q openafs >/dev/null 2>&1 ; echo $?', on_fail: nil)
      dpkg_exists = Facter::Core::Execution.execute('dpkg-query -W --showformat=\'${version}\' openafs-client >/dev/null 2>&1 ; echo $?', on_fail: nil)

      if rpm_exists == '0'
        Facter::Core::Execution.execute('rpm -q --queryformat=\'%{VERSION}\' openafs', on_fail: nil)
      elsif dpkg_exists == '0'
        Facter::Core::Execution.execute('dpkg-query -W --showformat=\'${version}\' openafs-client', on_fail: nil)
      end
    end
  end
end

Facter.add(:afs_version) do
  setcode { Facter::Util::AfsVersion.read_afs_version }
end
