# afs_version.rb

Facter.add("afs_version") do
  setcode do
    test_exists = "rpm -q openafs 2>&1 >/dev/null ; echo $?"
    if Facter::Util::Resolution.exec(test_exists) == '0'
      cmd = "rpm -q --queryformat='%{VERSION}' openafs"
      response = Facter::Util::Resolution.exec(cmd)
    end
  end
end
