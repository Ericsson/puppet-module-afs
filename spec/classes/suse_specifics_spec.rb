# For SLED/SLES we need individual tests for each affected minor release.
# Since this is not possible with rspec-puppet-facts, explicit tests are
# necessary here.
#
# With SLES 15.4 the path to the modprobe.d directory got changed from
# /etc/modprobe.d to /lib/modprobe.d.

require 'spec_helper'
describe 'afs' do
  platforms = {
    'SLES-15.2 x86_64' => {
      os: {
        family: 'Suse',
        name: 'SLES',
        release: {
          full: '15.2',
          major: '15',
        }
      }
    },
    'SLES-15.3 x86_64' => {
      os: {
        family: 'Suse',
        name: 'SLES',
        release: {
          full: '15.3',
          major: '15',
        }
      }
    },
    'SLES-15.4 x86_64' => {
      os: {
        family: 'Suse',
        name: 'SLES',
        release: {
          full: '15.4',
          major: '15',
        }
      }
    },
    'SLES-15.5 x86_64' => {
      os: {
        family: 'Suse',
        name: 'SLES',
        release: {
          full: '15.5',
          major: '15',
        }
      }
    },
  }

  describe 'with default values for parameters' do
    platforms.sort.each do |_k, v|
      context "where [os][name] is <#{v[:os][:name]}-#{v[:os][:release][:full]}>" do
        let :facts do
          {
            os: {
              family:  v[:os][:family],
              name:    v[:os][:name],
              release: {
                full:  v[:os][:release][:full],
                major: v[:os][:release][:major],
              }
            }
          }
        end

        it { is_expected.to compile.with_all_deps }

        if v[:os][:release][:full].to_f >= 15.4
          it do
            is_expected.to contain_file('/etc/modprobe.d/10-unsupported-modules.conf').with(
              'ensure' => 'file',
              'path'   => '/etc/modprobe.d/10-unsupported-modules.conf',
              'owner'  => 'root',
              'group'  => 'root',
              'mode'   => '0644',
              'before' => 'File_line[allow_unsupported_modules]',
            )
          end
        end
      end
    end
  end
end
