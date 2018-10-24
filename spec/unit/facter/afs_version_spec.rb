require 'spec_helper'
require 'facter/afs_version'

describe 'Facter::Util::AfsVersion (afs_version)' do
  if RUBY_VERSION > '1.8.7'
    context 'when openafs-1.6.16-1.1 is installed as RPM' do
      it 'should return <1.6.16>' do
        allow(Facter::Util::Resolution).to receive(:exec).with('rpm -q openafs >/dev/null 2>&1 ; echo $?').and_return('0')
        allow(Facter::Util::Resolution).to receive(:exec).with('dpkg-query -W --showformat=\'${version}\' openafs-client >/dev/null 2>&1 ; echo $?').and_return('1')
        allow(Facter::Util::Resolution).to receive(:exec).with('rpm -q --queryformat=\'%{VERSION}\' openafs').and_return('1.6.16')
        expect(Facter::Util::AfsVersion.read_afs_version).to eq('1.6.16')
      end
    end

    context 'when openafs-1.6.2-4.2 is installed as DEB' do
      it 'should return <1.6.2>' do
        allow(Facter::Util::Resolution).to receive(:exec).with('rpm -q openafs >/dev/null 2>&1 ; echo $?').and_return('1')
        allow(Facter::Util::Resolution).to receive(:exec).with('dpkg-query -W --showformat=\'${version}\' openafs-client >/dev/null 2>&1 ; echo $?').and_return('0')
        allow(Facter::Util::Resolution).to receive(:exec).with('dpkg-query -W --showformat=\'${version}\' openafs-client').and_return('1.6.2')
        expect(Facter::Util::AfsVersion.read_afs_version).to eq('1.6.2')
      end
    end

    context 'when openafs is not installed' do
      it 'should be undef' do
        allow(Facter::Util::Resolution).to receive(:exec).with('rpm -q openafs >/dev/null 2>&1 ; echo $?').and_return('1')
        allow(Facter::Util::Resolution).to receive(:exec).with('dpkg-query -W --showformat=\'${version}\' openafs-client >/dev/null 2>&1 ; echo $?').and_return('1')
        expect(Facter::Util::AfsVersion.read_afs_version).to be_nil
      end
    end
  # on Ruby <= 1.8.7 we need to use old puppetlabs_spec_helper v2.0.2 which does not support the allow method used above
  else
    context 'when openafs-1.6.16-1.1 is installed as RPM' do
      it 'should return <1.6.16>' do
        Facter::Util::Resolution.expects(:exec).with('rpm -q openafs >/dev/null 2>&1 ; echo $?').returns('0')
        Facter::Util::Resolution.expects(:exec).with('dpkg-query -W --showformat=\'${version}\' openafs-client >/dev/null 2>&1 ; echo $?').returns('1')
        Facter::Util::Resolution.expects(:exec).with('rpm -q --queryformat=\'%{VERSION}\' openafs').returns('1.6.16')
        expect(Facter::Util::AfsVersion.read_afs_version).to eq('1.6.16')
      end
    end

    context 'when openafs-1.6.2-4.2 is installed as DEB' do
      it 'should return <1.6.2>' do
        Facter::Util::Resolution.expects(:exec).with('rpm -q openafs >/dev/null 2>&1 ; echo $?').returns('1')
        Facter::Util::Resolution.expects(:exec).with('dpkg-query -W --showformat=\'${version}\' openafs-client >/dev/null 2>&1 ; echo $?').returns('0')
        Facter::Util::Resolution.expects(:exec).with('dpkg-query -W --showformat=\'${version}\' openafs-client').returns('1.6.2')
        expect(Facter::Util::AfsVersion.read_afs_version).to eq('1.6.2')
      end
    end

    context 'when openafs is not installed' do
      it 'should be undef' do
        Facter::Util::Resolution.expects(:exec).with('rpm -q openafs >/dev/null 2>&1 ; echo $?').returns('1')
        Facter::Util::Resolution.expects(:exec).with('dpkg-query -W --showformat=\'${version}\' openafs-client >/dev/null 2>&1 ; echo $?').returns('1')
        expect(Facter::Util::AfsVersion.read_afs_version).to be_nil
      end
    end
  end
end
