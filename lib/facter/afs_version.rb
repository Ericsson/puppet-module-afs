# afs_version.rb

Facter.add('afs_version') do
  confine :kernel => 'SunOS'

    setcode do
      begin
        pkg_exists = "pkginfo EISopenafs >/dev/null 2>&1 ; echo $?"
      if Facter::Util::Resolution.exec(pkg_exists) == '0'
        cmd = "pkginfo -l EISopenafs | grep VERSION | awk '{print $NF}'"
        response = Facter::Util::resolution.exec(cmd)
      end
    end
  end
end

Facter.add('afs_version') do
  confine :kernel => 'Linux'

    setcode do
      begin
        rpm_test_exists = "rpm -q openafs 2>&1 >/dev/null ; echo $?"
        dpkg_test_exists = "dpkg-query -W --showformat='${version}' openafs-client 2>&1 >/dev/null ; echo $?"
      if Facter::Util::Resolution.exec(rpm_test_exists) == '0'
        cmd = "rpm -q --queryformat='%{VERSION}' openafs"
        response = Facter::Util::Resolution.exec(cmd)
      elsif Facter::Util::Resolution.exec(dpkg_test_exists) == '0'
        cmd = "dpkg-query -W --showformat='${version}' openafs-client"
        response = Facter::Util::Resolution.exec(cmd)
      end
    end
  end
end
