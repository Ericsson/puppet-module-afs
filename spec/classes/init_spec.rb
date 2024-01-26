require 'spec_helper'
describe 'afs' do
  on_supported_os.each do |os, os_facts|
    os_data = if platforms["#{os_facts[:os]['family']}-#{os_facts[:os]['release']['major']}-#{os_facts[:os]['architecture']}"]
                platforms["#{os_facts[:os]['family']}-#{os_facts[:os]['release']['major']}-#{os_facts[:os]['architecture']}"]
              else
                platforms["#{os_facts[:os]['name']}-#{os_facts[:os]['release']['major']}-#{os_facts[:os]['architecture']}"]
              end

    package_before = [
      'File[afs_config_cacheinfo]',
      'File[afs_config_client]',
    ]
    service_require = [
      'File[afs_config_cacheinfo]',
      'File[afs_config_client]',
    ]

    context "on #{os}" do
      describe 'with default values for parameters' do
        let(:facts) { os_facts }

        it { is_expected.to compile.with_all_deps }

        os_data[:package_name].each do |package|
          it {
            is_expected.to contain_package(package).with(
              'ensure' => 'installed',
              'before' => package_before,
            )
          }
        end

        # common::mkdir_p { ...: }
        it {
          is_expected.to contain_common__mkdir_p(os_data[:afs_config_path])
        }

        it {
          is_expected.to contain_common__mkdir_p(File.dirname(os_data[:config_client_path]))
        }

        # file { 'afs_config_cacheinfo' :}
        it {
          is_expected.to contain_file('afs_config_cacheinfo').with(
            'ensure'  => 'file',
            'path'    => "#{os_data[:afs_config_path]}/cacheinfo",
            'owner'   => 'root',
            'group'   => 'root',
            'mode'    => '0644',
            'content' => "/afs:#{os_data[:cache_path]}:1000000\n",
            'require' => "Common::Mkdir_p[#{os_data[:afs_config_path]}]",
            'before'  => 'Service[afs_openafs_client_service]',
          )
        }

        # file { 'afs_config_client' :}
        it {
          is_expected.to contain_file('afs_config_client').with(
            'ensure' => 'file',
            'path'    => (os_data[:config_client_path]).to_s,
            'owner'   => 'root',
            'group'   => 'root',
            'mode'    => '0644',
            'require' => "Common::Mkdir_p[#{File.dirname(os_data[:config_client_path])}]",
            'before'  => 'Service[afs_openafs_client_service]',
          )
        }
        it { is_expected.to contain_file('afs_config_client').with_content(%r{^AFSD_ARGS=\"-dynroot -afsdb -daemons 6 -volumes 1000\"$}) }
        it { is_expected.to contain_file('afs_config_client').with_content(%r{^UPDATE=\"false\"$}) }
        it { is_expected.to contain_file('afs_config_client').with_content(%r{^DKMS=\"#{os_data[:config_client_dkms]}\"$}) }
        it { is_expected.to contain_file('afs_config_client').with_content(%r{^CLEANCACHE=\"false\"$}) }

        # file { 'afs_config_suidcells': }
        it { is_expected.not_to contain_file('afs_config_suidcells') }

        # service { 'afs_openafs_client_service':}
        it {
          is_expected.to contain_service('afs_openafs_client_service').with(
            'ensure' => 'running',
            'enable'     => 'true',
            'name'       => 'openafs-client',
            'hasstatus'  => 'false',
            'hasrestart' => 'false',
            'restart'    => '/bin/true',
            'status'     => '/bin/ps -ef | /bin/grep -i "afsd" | /bin/grep -v "grep"',
            'require'    => service_require,
          )
        }

        if os_data[:allow_unsupported_modules] == true
          it {
            is_expected.to contain_file_line('allow_unsupported_modules').with(
              'ensure' => 'present',
              'path'   => '/etc/modprobe.d/10-unsupported-modules.conf',
              'line'   => 'allow_unsupported_modules 1',
              'match'  => '^allow_unsupported_modules 0$',
              'before' => 'Service[afs_openafs_client_service]',
            )
          }
        end
      end

      describe 'with optional parameters set' do
        let(:facts) { os_facts }
        let(:params) do
          {
            afs_suidcells: 'sunset.github.com',
            afs_cell: 'sunset.github.com',
            afs_cellserverdb: '>sunset.github.com\t#Sunset'
          }
        end

        context 'where afs_cell is <sunset.github.com>' do
          # file { 'afs_config_thiscell' :}
          it {
            is_expected.to contain_file('afs_config_thiscell').with(
              'ensure'  => 'file',
              'path'    => "#{os_data[:afs_config_path]}/ThisCell",
              'owner'   => 'root',
              'group'   => 'root',
              'mode'    => '0644',
              'require' => "Common::Mkdir_p[#{os_data[:afs_config_path]}]",
              'before'  => 'Service[afs_openafs_client_service]',
            )
          }
          it { is_expected.to contain_afs__validate_domain_names('sunset.github.com') }
          it { is_expected.to contain_file('afs_config_thiscell').with_content(%r{^sunset.github.com$}) }
        end

        context "where afs_cellserverdb is <>sunset.github.com\t#Sunset>" do
          # file { 'afs_config_cellserverdb' :}
          it {
            is_expected.to contain_file('afs_config_cellserverdb').with(
              'ensure'  => 'file',
              'path'    => "#{os_data[:afs_config_path]}/CellServDB",
              'owner'   => 'root',
              'group'   => 'root',
              'mode'    => '0644',
              'require' => "Common::Mkdir_p[#{os_data[:afs_config_path]}]",
              'before'  => 'Service[afs_openafs_client_service]',
            )
          }
          it { is_expected.to contain_afs__validate_domain_names('sunset.github.com') }
          it { is_expected.to contain_file('afs_config_cellserverdb').with_content(%r{^>sunset.github.com\\t#Sunset$}) }
        end

        context 'where afs_suidcells is <sunset.github.com>' do
          # file { 'afs_config_suidcells' :}
          it {
            is_expected.to contain_file('afs_config_suidcells').with(
              'ensure'  => 'file',
              'path'    => "#{os_data[:afs_config_path]}/SuidCells",
              'owner'   => 'root',
              'group'   => 'root',
              'mode'    => '0644',
              'require' => "Common::Mkdir_p[#{os_data[:afs_config_path]}]",
              'before'  => 'Service[afs_openafs_client_service]',
            )
          }

          it { is_expected.to contain_afs__validate_domain_names('sunset.github.com') }
          it { is_expected.to contain_file('afs_config_suidcells').with_content(%r{^sunset.github.com\n$}) }
        end

        context 'where afs_suidcells is [sunset.github.com, sunset.gitlab.com]' do
          let(:params) do
            {
              afs_suidcells: ['sunset.github.com', 'sunset.gitlab.com'],
            }
          end

          # file { 'afs_config_suidcells' :}
          it {
            is_expected.to contain_file('afs_config_suidcells').with(
              'ensure'  => 'file',
              'path'    => "#{os_data[:afs_config_path]}/SuidCells",
              'owner'   => 'root',
              'group'   => 'root',
              'mode'    => '0644',
              'require' => "Common::Mkdir_p[#{os_data[:afs_config_path]}]",
              'before'  => 'Service[afs_openafs_client_service]',
            )
          }
          it { is_expected.to contain_afs__validate_domain_names('sunset.github.com') }
          it { is_expected.to contain_afs__validate_domain_names('sunset.gitlab.com') }
          it { is_expected.to contain_file('afs_config_suidcells').with_content(%r{^sunset.github.com\nsunset.gitlab.com\n$}) }
        end

        context 'where afs_suidcells is <domain.c0m> as string' do
          let(:params) do
            {
              afs_suidcells: 'domain.c0m',
            }
          end

          it 'fails' do
            expect { is_expected.to contain_class(:subject) }.to raise_error(Puppet::Error, %r{is not a syntactically correct domain name})
          end
        end

        context 'where afs_suidcells is [-invalid domain.c0m] as array' do
          let(:params) do
            {
              afs_suidcells: ['-invalid', 'domain.c0m'],
            }
          end

          it 'fails' do
            expect { is_expected.to contain_class(:subject) }.to raise_error(Puppet::PreformattedError, %r{})
          end
        end
      end

      describe 'with cronjob' do
        let(:facts) { os_facts }

        ['hourly', 'daily', 'weekly', 'monthly'].each do |value|
          context "where afs_cron_job_interval is <#{value}>" do
            let(:params) do
              {
                afs_cron_job_content: '#!/bin/sh\n/sw/RedHat/afs_setserverprefs.sh',
                afs_cron_job_interval: value.to_s
              }
            end

            # file { 'afs_cron_job' :}
            it {
              is_expected.to contain_file('afs_cron_job').with(
                'ensure' => 'file',
                'path'    => "/etc/cron.#{value}/afs_cron_job",
                'owner'   => 'root',
                'group'   => 'root',
                'mode'    => '0755',
                'content' => '#!/bin/sh\\n/sw/RedHat/afs_setserverprefs.sh',
              )
            }
          end
        end

        context 'where afs_cron_job_interval is <specific>' do
          let(:params) do
            {
              afs_cron_job_content: '#!/bin/sh\n/sw/RedHat/afs_setserverprefs.sh',
              afs_cron_job_interval: 'specific',
              afs_cron_job_hour: 2,
              afs_cron_job_month: 2,
              afs_cron_job_weekday: 4,
              afs_cron_job_monthday: 2
            }
          end

          # file { 'afs_cron_job' :}
          it {
            is_expected.to contain_cron('afs_cron_job').with(
              'ensure' => 'present',
              'command'  => '#!/bin/sh\\n/sw/RedHat/afs_setserverprefs.sh',
              'user'     => 'root',
              'minute'   => '42',
              'hour'     => '2',
              'month'    => '2',
              'weekday'  => '4',
              'monthday' => '2',
            )
          }
        end
      end

      describe 'with symlink' do
        let(:facts) { os_facts }
        let(:params) do
          {
            create_symlinks: true,
            links: {
              'test-app' => {
                'path'   => '/tmp/app',
                'target' => "/sw/#{os_facts[:os]['name']}/app",
              },
            }
          }
        end

        # create_resources(file, $links, $afs_create_links)
        it {
          is_expected.to contain_file('test-app').with(
            'ensure' => 'link',
            'owner'   => 'root',
            'group'   => 'root',
            'mode'    => '0755',
            'path'    => '/tmp/app',
            'target'  => "/sw/#{os_facts[:os]['name']}/app",
          )
        }
      end

      describe 'with config_client_clean_cache_on_start set to valid boolean true' do
        let(:facts) { os_facts }
        let(:params) do
          {
            config_client_clean_cache_on_start: true,
          }
        end

        it { is_expected.to contain_file('afs_config_client').with_content(%r{^CLEANCACHE=\"true\"$}) }
      end
    end
  end
end
