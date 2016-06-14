require 'spec_helper'
require 'facter/afs_version'

describe 'Facter::Util::AfsVersion (afs_version)' do
  context 'when openafs-1.6.16-1.1 is installed as RPM' do
    it 'should return <1.6.16>' do
      Facter::Util::Resolution.expects(:exec).with('rpm -q openafs 2>&1 >/dev/null ; echo $?').returns('0')
      Facter::Util::Resolution.expects(:exec).with('dpkg-query -W --showformat=\'${version}\' openafs-client 2>&1 >/dev/null ; echo $?').returns('1')
      Facter::Util::Resolution.expects(:exec).with('rpm -q --queryformat=\'%{VERSION}\' openafs').returns('1.6.16')
      expect(Facter::Util::AfsVersion.read_afs_version).to eq('1.6.16')
    end
  end

  context 'when openafs-1.6.2-4.2 is installed as DEB' do
    it 'should return <1.6.2>' do
      Facter::Util::Resolution.expects(:exec).with('rpm -q openafs 2>&1 >/dev/null ; echo $?').returns('1')
      Facter::Util::Resolution.expects(:exec).with('dpkg-query -W --showformat=\'${version}\' openafs-client 2>&1 >/dev/null ; echo $?').returns('0')
      Facter::Util::Resolution.expects(:exec).with('dpkg-query -W --showformat=\'${version}\' openafs-client').returns('1.6.2')
      expect(Facter::Util::AfsVersion.read_afs_version).to eq('1.6.2')
    end
  end

  context 'when openafs is not installed' do
    it 'should be undef' do
      Facter::Util::Resolution.expects(:exec).with('rpm -q openafs 2>&1 >/dev/null ; echo $?').returns('1')
      Facter::Util::Resolution.expects(:exec).with('dpkg-query -W --showformat=\'${version}\' openafs-client 2>&1 >/dev/null ; echo $?').returns('1')
      expect(Facter::Util::AfsVersion.read_afs_version).to be_nil
    end
  end
end
