require 'spec_helper'
describe 'afs' do
  describe 'with default values for parameters' do
    platforms.sort.each do |k, v|
      context "where osfamily is <#{k}>" do
        let :facts do
          v[:facts_hash].merge(
            is_virtual: nil,
            virtual: nil,
          )
        end

        it { is_expected.to compile.with_all_deps }

        v[:package_name].each do |package|
          it {
            is_expected.to contain_package(package).with('ensure' => 'installed',
                                                         'before' => [
                                                           'File[afs_init_script]',
                                                           'File[afs_config_cacheinfo]',
                                                           'File[afs_config_client]',
                                                         ])
          }
        end

        # common::mkdir_p { $afs_config_path: }
        it {
          is_expected.to contain_exec("mkdir_p-#{v[:afs_config_path]}").with('command' => "mkdir -p #{v[:afs_config_path]}",
                                                                             'unless' => "test -d #{v[:afs_config_path]}")
        }

        # file { 'afs_init_script' :}
        it {
          is_expected.to contain_file('afs_init_script').with('ensure' => 'file',
                                                              'path'    => v[:init_script],
                                                              'owner'   => 'root',
                                                              'group'   => 'root',
                                                              'mode'    => '0755',
                                                              'source'  => "puppet:///modules/afs/#{v[:init_template]}",
                                                              'before'  => 'Service[afs_openafs_client_service]')
        }

        # file { 'afs_config_cacheinfo' :}
        it {
          is_expected.to contain_file('afs_config_cacheinfo').with('ensure' => 'file',
                                                                   'path'    => "#{v[:afs_config_path]}/cacheinfo",
                                                                   'owner'   => 'root',
                                                                   'group'   => 'root',
                                                                   'mode'    => '0644',
                                                                   'content' => "/afs:#{v[:cache_path]}:1000000\n",
                                                                   'require' => "Common::Mkdir_p[#{v[:afs_config_path]}]",
                                                                   'before'  => 'Service[afs_openafs_client_service]')
        }

        # common::mkdir_p { $config_client_dir: } # Hint: need to extract the dirname from the file path
        it {
          is_expected.to contain_exec("mkdir_p-#{File.dirname(v[:config_client_path])}").with('command' => "mkdir -p #{File.dirname(v[:config_client_path])}",
                                                                                              'unless' => "test -d #{File.dirname(v[:config_client_path])}")
        }

        # file { 'afs_config_client' :}
        it {
          is_expected.to contain_file('afs_config_client').with('ensure' => 'file',
                                                                'path'    => (v[:config_client_path]).to_s,
                                                                'owner'   => 'root',
                                                                'group'   => 'root',
                                                                'mode'    => '0644',
                                                                'require' => "Common::Mkdir_p[#{File.dirname(v[:config_client_path])}]",
                                                                'before'  => 'Service[afs_openafs_client_service]')
        }
        it { is_expected.to contain_file('afs_config_client').with_content(%r{^AFSD_ARGS=\"-dynroot -afsdb -daemons 6 -volumes 1000\"$}) }
        it { is_expected.to contain_file('afs_config_client').with_content(%r{^UPDATE=\"false\"$}) }
        it { is_expected.to contain_file('afs_config_client').with_content(%r{^DKMS=\"#{v[:config_client_dkms]}\"$}) }
        it { is_expected.to contain_file('afs_config_client').with_content(%r{^CLEANCACHE=\"false\"$}) }

        # file { 'afs_config_suidcells': }
        it { is_expected.not_to contain_file('afs_config_suidcells') }

        # service { 'afs_openafs_client_service':}
        it {
          is_expected.to contain_service('afs_openafs_client_service').with('ensure' => 'running',
                                                                            'enable'     => 'true',
                                                                            'name'       => 'openafs-client',
                                                                            'hasstatus'  => 'false',
                                                                            'hasrestart' => 'false',
                                                                            'restart'    => '/bin/true',
                                                                            'status'     => '/bin/ps -ef | /bin/grep -i "afsd" | /bin/grep -v "grep"',
                                                                            'require'    => [
                                                                              'File[afs_init_script]',
                                                                              'File[afs_config_cacheinfo]',
                                                                              'File[afs_config_client]',
                                                                            ])
        }
      end

      next unless v[:allow_supported_modules] == true
      it {
        is_expected.to contain_file_line('allow_unsupported_modules').with('ensure' => 'present',
                                                                           'path'   => '/etc/modprobe.d/10-unsupported-modules.conf',
                                                                           'line'   => 'allow_unsupported_modules 1',
                                                                           'match'  => '^allow_unsupported_modules 0$',
                                                                           'before' => 'Service[afs_openafs_client_service]')
      }
    end
  end

  context 'where osfamily is <Solaris> running in a container' do
    let :facts do
      platforms['solaris-10-i86pc'][:facts_hash].merge(
        virtual: 'zone',
        is_virtual: true,
      )
    end
    let :params do
      { afs_suidcells: 'sunset.github.com',
        afs_cell: 'sunset.github.com',
        afs_cellserverdb: '>sunset.github.com\t#Sunset' }
    end

    it { is_expected.to contain_file('afs_init_script').with_before(nil) }
    it { is_expected.to contain_file('afs_config_cacheinfo').with_before(nil) }
    it { is_expected.to contain_file('afs_config_client').with_before(nil) }
    it { is_expected.to contain_file('afs_config_suidcells').with_before(nil) }
    it { is_expected.to contain_file('afs_config_thiscell').with_before(nil) }
    it { is_expected.to contain_file('afs_config_cellserverdb').with_before(nil) }
    it { is_expected.not_to contain_service('afs_openafs_client_service') }
    it { is_expected.not_to contain_cron('afs_cron_job') }
    it { is_expected.not_to contain_file('afs_cron_job') }
  end

  describe 'with optional parameters set' do
    let :facts do
      platforms['redhat-7-x86_64'][:facts_hash].merge(
        is_virtual: nil,
      )
    end
    let :params do
      { afs_suidcells: 'sunset.github.com',
        afs_cell: 'sunset.github.com',
        afs_cellserverdb: '>sunset.github.com\t#Sunset' }
    end

    context 'where afs_cell is <sunset.github.com>' do
      # file { 'afs_config_thiscell' :}
      it {
        is_expected.to contain_file('afs_config_thiscell').with('ensure' => 'file',
                                                                'path'   => '/usr/vice/etc/ThisCell',
                                                                'owner'  => 'root',
                                                                'group'  => 'root',
                                                                'mode'   => '0644',
                                                                'require' => 'Common::Mkdir_p[/usr/vice/etc]',
                                                                'before'  => 'Service[afs_openafs_client_service]')
      }
      it { is_expected.to contain_file('afs_config_thiscell').with_content(%r{^sunset.github.com$}) }
    end

    context "where afs_cellserverdb is <>sunset.github.com\t#Sunset>" do
      # file { 'afs_config_cellserverdb' :}
      it {
        is_expected.to contain_file('afs_config_cellserverdb').with('ensure' => 'file',
                                                                    'path'   => '/usr/vice/etc/CellServDB',
                                                                    'owner'  => 'root',
                                                                    'group'  => 'root',
                                                                    'mode'   => '0644',
                                                                    'require' => 'Common::Mkdir_p[/usr/vice/etc]',
                                                                    'before'  => 'Service[afs_openafs_client_service]')
      }
      it { is_expected.to contain_file('afs_config_cellserverdb').with_content(%r{^>sunset.github.com\\t#Sunset$}) }
    end

    context 'where afs_suidcells is <sunset.github.com>' do
      # file { 'afs_config_suidcells' :}
      it {
        is_expected.to contain_file('afs_config_suidcells').with('ensure' => 'file',
                                                                 'path'   => '/usr/vice/etc/SuidCells',
                                                                 'owner'  => 'root',
                                                                 'group'  => 'root',
                                                                 'mode'   => '0644',
                                                                 'require' => 'Common::Mkdir_p[/usr/vice/etc]',
                                                                 'before'  => 'Service[afs_openafs_client_service]')
      }
      it { is_expected.to contain_file('afs_config_suidcells').with_content(%r{^sunset.github.com\n$}) }
    end

    context 'where afs_suidcells is [sunset.github.com, sunset.gitlab.com]' do
      let :params do
        {
          afs_suidcells: ['sunset.github.com', 'sunset.gitlab.com'],
        }
      end

      # file { 'afs_config_suidcells' :}
      it {
        is_expected.to contain_file('afs_config_suidcells').with('ensure' => 'file',
                                                                 'path'   => '/usr/vice/etc/SuidCells',
                                                                 'owner'  => 'root',
                                                                 'group'  => 'root',
                                                                 'mode'   => '0644',
                                                                 'require' => 'Common::Mkdir_p[/usr/vice/etc]',
                                                                 'before'  => 'Service[afs_openafs_client_service]')
      }
      it { is_expected.to contain_file('afs_config_suidcells').with_content(%r{^sunset.github.com\nsunset.gitlab.com\n$}) }
    end

    context 'where afs_suidcells is <domain.c0m> as string' do
      let :params do
        {
          afs_suidcells: 'domain.c0m',
        }
      end

      it 'fails' do
        expect { is_expected.to contain_class(:subject) }.to raise_error(Puppet::Error, %r{is not a syntactically correct domain name})
      end
    end

    context 'where afs_suidcells is [-invalid domain.c0m] as array' do
      let :params do
        {
          afs_suidcells: ['-invalid', 'domain.c0m'],
        }
      end

      it 'fails' do
        expect { is_expected.to contain_class(:subject) }.to raise_error(Puppet::PreformattedError, %r{})
      end
    end
  end

  describe 'with Solaris specific parameters set' do
    let :facts do
      platforms['solaris-10-i86pc'][:facts_hash].merge(
        is_virtual: nil,
        virtual: nil,
      )
    end
    let :params do
      { package_adminfile: '/sw/Solaris/Sparc/noask',
        package_provider: 'sun',
        package_source: '/sw/Solaris/Sparc/EISopenafs',
        service_provider: 'init',
        package_name: ['EISopenafs'] }
    end

    context 'where adminfile is </sw/Solaris/Sparc/noask>' do
      it {
        is_expected.to contain_package('EISopenafs').with('adminfile' => '/sw/Solaris/Sparc/noask')
      }
    end

    context 'where package_provider is <sun>' do
      it {
        is_expected.to contain_package('EISopenafs').with('provider'  => 'sun')
      }
    end

    context 'where source is </sw/Solaris/Sparc/EISopenafs>' do
      it {
        is_expected.to contain_package('EISopenafs').with('source'    => '/sw/Solaris/Sparc/EISopenafs')
      }
    end

    context 'where service_provider is <init>' do
      # service { 'afs_openafs_client_service':}
      it {
        is_expected.to contain_service('afs_openafs_client_service').with('provider' => 'init')
      }
    end
  end

  describe 'with cronjob' do
    let :facts do
      platforms['redhat-7-x86_64'][:facts_hash].merge(
        is_virtual: nil,
      )
    end

    ['hourly', 'daily', 'weekly', 'monthly'].each do |value|
      context "where afs_cron_job_interval is <#{value}>" do
        let :params do
          { afs_cron_job_content: '#!/bin/sh\n/sw/RedHat/afs_setserverprefs.sh',
            afs_cron_job_interval: value.to_s }
        end

        # file { 'afs_cron_job' :}
        it {
          is_expected.to contain_file('afs_cron_job').with('ensure' => 'file',
                                                           'path'    => "/etc/cron.#{value}/afs_cron_job",
                                                           'owner'   => 'root',
                                                           'group'   => 'root',
                                                           'mode'    => '0755',
                                                           'content' => '#!/bin/sh\\n/sw/RedHat/afs_setserverprefs.sh',
                                                           'require' => 'File[afs_init_script]')
        }
      end
    end

    context 'where afs_cron_job_interval is <specific>' do
      let :params do
        { afs_cron_job_content: '#!/bin/sh\n/sw/RedHat/afs_setserverprefs.sh',
          afs_cron_job_interval: 'specific',
          afs_cron_job_hour: 2,
          afs_cron_job_month: 2,
          afs_cron_job_weekday: 4,
          afs_cron_job_monthday: 2 }
      end

      # file { 'afs_cron_job' :}
      it {
        is_expected.to contain_cron('afs_cron_job').with('ensure' => 'present',
                                                         'command'  => '#!/bin/sh\\n/sw/RedHat/afs_setserverprefs.sh',
                                                         'user'     => 'root',
                                                         'minute'   => '42',
                                                         'hour'     => '2',
                                                         'month'    => '2',
                                                         'weekday'  => '4',
                                                         'monthday' => '2',
                                                         'require' => 'File[afs_init_script]')
      }
    end
  end

  describe 'with symlink' do
    let :facts do
      platforms['redhat-7-x86_64'][:facts_hash].merge(
        is_virtual: nil,
      )
    end
    let :params do
      { create_symlinks: true,
        links: {
          'test-app' => {
            'path'   => '/tmp/app',
            'target' => '/sw/RedHat/app',
          },
        } }
    end

    # create_resources(file, $links, $afs_create_links)
    it {
      is_expected.to contain_file('test-app').with('ensure' => 'link',
                                                   'owner'   => 'root',
                                                   'group'   => 'root',
                                                   'mode'    => '0755',
                                                   'path'    => '/tmp/app',
                                                   'target'  => '/sw/RedHat/app')
    }
  end

  describe 'with config_client_clean_cache_on_start set to valid boolean true' do
    let :facts do
      platforms['redhat-7-x86_64'][:facts_hash].merge(
        is_virtual: nil,
      )
    end
    let(:params) { { config_client_clean_cache_on_start: true } }

    it { is_expected.to contain_file('afs_config_client').with_content(%r{^CLEANCACHE=\"true\"$}) }
  end

  describe 'variable type and content validations' do
    # set needed custom facts and variables
    let(:facts) do
      platforms['redhat-7-x86_64'][:facts_hash].merge(
        is_virtual: nil,
      )
    end
    let(:mandatory_params) do
      {
        #:param => 'value',
      }
    end

    validations = {
      'boolean' => {
        name: ['config_client_clean_cache_on_start', 'config_client_dkms', 'config_client_update', 'create_symlinks'],
        valid: [true, false],
        invalid: ['string', ['array'], { 'ha' => 'sh' }, 3, 2.42, 'false', nil],
        message: 'expects a Boolean value',
      },
      'array / string (domain)' => {
        name: ['afs_suidcells'],
        valid: ['domain', ['multiple', 'domains']],
        invalid: ['-invalid', { 'ha' => 'sh' }, 3, 2.42, false],
        message: '(is not an array nor a string|is not a syntactically correct domain name|of type Array or String)',
      },
    }

    validations.sort.each do |type, var|
      var[:name].each do |var_name|
        var[:params] = {} if var[:params].nil?
        var[:valid].each do |valid|
          context "when #{var_name} (#{type}) is set to valid #{valid} (as #{valid.class})" do
            let(:params) { [mandatory_params, var[:params], { :"#{var_name}" => valid }].reduce(:merge) }

            it { is_expected.to compile }
          end
        end

        var[:invalid].each do |invalid|
          context "when #{var_name} (#{type}) is set to invalid #{invalid} (as #{invalid.class})" do
            let(:params) { [mandatory_params, var[:params], { :"#{var_name}" => invalid }].reduce(:merge) }

            it 'fails' do
              expect { is_expected.to contain_class(:subject) }.to raise_error(Puppet::Error, %r{#{var[:message]}})
            end
          end
        end
      end # var[:name].each
    end # validations.sort.each
  end # describe 'variable type and content validations'
end
