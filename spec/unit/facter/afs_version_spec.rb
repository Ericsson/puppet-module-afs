require 'spec_helper'
require 'facter/afs_version'

describe 'Facter::Util::AfsVersion (afs_version)' do
  context 'when openafs-1.8.13-1.1 is installed as RPM' do
    it 'returns <1.8.13>' do
      allow(Facter::Core::Execution).to receive(:execute).with('rpm -q openafs >/dev/null 2>&1 ; echo $?', on_fail: nil).and_return('0')
      allow(Facter::Core::Execution).to receive(:execute).with('dpkg-query -W --showformat=\'${version}\' openafs-client >/dev/null 2>&1 ; echo $?', on_fail: nil).and_return('1')
      allow(Facter::Core::Execution).to receive(:execute).with('rpm -q --queryformat=\'%{VERSION}\' openafs', on_fail: nil).and_return('1.8.13')
      expect(Facter::Util::AfsVersion.read_afs_version).to eq('1.8.13')
    end
  end

  context 'when openafs-1.8.13-4.2 is installed as DEB' do
    it 'returns <1.8.13>' do
      allow(Facter::Core::Execution).to receive(:execute).with('rpm -q openafs >/dev/null 2>&1 ; echo $?', on_fail: nil).and_return('1')
      allow(Facter::Core::Execution).to receive(:execute).with('dpkg-query -W --showformat=\'${version}\' openafs-client >/dev/null 2>&1 ; echo $?', on_fail: nil).and_return('0')
      allow(Facter::Core::Execution).to receive(:execute).with('dpkg-query -W --showformat=\'${version}\' openafs-client', on_fail: nil).and_return('1.8.13')
      expect(Facter::Util::AfsVersion.read_afs_version).to eq('1.8.13')
    end
  end

  context 'when openafs is not installed' do
    it 'is undef' do
      allow(Facter::Core::Execution).to receive(:execute).with('rpm -q openafs >/dev/null 2>&1 ; echo $?', on_fail: nil).and_return('1')
      allow(Facter::Core::Execution).to receive(:execute).with('dpkg-query -W --showformat=\'${version}\' openafs-client >/dev/null 2>&1 ; echo $?', on_fail: nil).and_return('1')
      expect(Facter::Util::AfsVersion.read_afs_version).to be_nil
    end
  end

  # The fact is loaded on every node, including ones without afs and without
  # rpm/dpkg. When a command is missing, on_fail: nil makes execute return nil
  # instead of raising, so the fact must resolve to nil (never error).
  context 'when neither rpm nor dpkg is available (command missing)' do
    it 'is undef and does not raise' do
      allow(Facter::Core::Execution).to receive(:execute).with('rpm -q openafs >/dev/null 2>&1 ; echo $?', on_fail: nil).and_return(nil)
      allow(Facter::Core::Execution).to receive(:execute).with('dpkg-query -W --showformat=\'${version}\' openafs-client >/dev/null 2>&1 ; echo $?', on_fail: nil).and_return(nil)
      expect { Facter::Util::AfsVersion.read_afs_version }.not_to raise_error
      expect(Facter::Util::AfsVersion.read_afs_version).to be_nil
    end
  end
end
