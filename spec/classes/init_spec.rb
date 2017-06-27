require 'spec_helper'
describe 'afs' do

  platforms = {
    'RedHat5' =>
      { :osfamily                   => 'RedHat',
        :osrelease                  => '5',
        :afs_config_path_default    => '/usr/vice/etc',
        :cache_path_default         => '/usr/vice/cache',
        :config_client_dkms_default => true,
        :config_client_path_default => '/etc/sysconfig/openafs-client',
        :init_script_default        => '/etc/init.d/openafs-client',
        :init_template_default      => 'openafs-client-RedHat',
        :package_name_default       => [ 'openafs', 'openafs-client', 'openafs-docs', 'openafs-compat', 'openafs-krb5', 'dkms', 'dkms-openafs', 'glibc-devel', 'libgcc.i386' ],
      },
    'RedHat6' =>
      { :osfamily                   => 'RedHat',
        :osrelease                  => '6',
        :afs_config_path_default    => '/usr/vice/etc',
        :cache_path_default         => '/usr/vice/cache',
        :config_client_dkms_default => true,
        :config_client_path_default => '/etc/sysconfig/openafs-client',
        :init_script_default        => '/etc/init.d/openafs-client',
        :init_template_default      => 'openafs-client-RedHat',
        :package_name_default       => [ 'openafs', 'openafs-client', 'openafs-docs', 'openafs-compat', 'openafs-krb5', 'dkms', 'dkms-openafs', 'glibc-devel', 'libgcc.i686' ],
      },
    'Suse' =>
      { :osfamily                   => 'Suse',
        :osrelease                  => '11',
        :afs_config_path_default    => '/etc/openafs',
        :cache_path_default         => '/var/cache/openafs',
        :config_client_dkms_default => false,
        :config_client_path_default => '/etc/sysconfig/openafs-client',
        :init_script_default        => '/etc/init.d/openafs-client',
        :init_template_default      => 'openafs-client-Suse',
        :package_name_default       => [ 'openafs', 'openafs-client', 'openafs-docs', 'openafs-kernel-source', 'openafs-krb5-mit' ],
      },
    'Solaris' =>
      { :osfamily                   => 'Solaris',
        :osrelease                  => '10',
        :afs_config_path_default    => '/usr/vice/etc',
        :cache_path_default         => '/usr/vice/cache',
        :config_client_dkms_default => false,
        :config_client_path_default => '/usr/vice/etc/sysconfig/openafs-client',
        :init_script_default        => '/etc/init.d/openafs-client',
        :init_template_default      => 'openafs-client-Solaris',
        :package_name_default       => [ 'EISopenafs' ],
      },
    'Ubuntu' =>
      { :osfamily                   => 'Debian',
        :osrelease                  => '12',
        :afs_config_path_default    => '/etc/openafs',
        :cache_path_default         => '/var/cache/openafs',
        :config_client_dkms_default => true,
        :config_client_path_default => '/etc/default/openafs-client',
        :init_script_default        => '/etc/init.d/openafs-client',
        :init_template_default      => 'openafs-client-Ubuntu',
        :package_name_default       => [ 'openafs-modules-dkms', 'openafs-modules-source', 'openafs-client', 'openafs-doc', 'openafs-krb5', 'dkms' ],
      },
  }

  describe 'with default values for parameters' do
    platforms.sort.each do |k,v|
      context "where osfamily is <#{k}>" do
        let :facts do
          { :osfamily                  => v[:osfamily],
            :operatingsystemmajrelease => v[:osrelease],
            :operatingsystemrelease    => "#{v[:osrelease]}.0",
            :is_virtual                => nil,
            :virtual                   => nil,
          }
        end

        it { should compile.with_all_deps }

        v[:package_name_default].each do |package|
          it {
            should contain_package(package).with({
              'ensure' => 'installed',
              'before' => [
                            'File[afs_init_script]',
                            'File[afs_config_cacheinfo]',
                            'File[afs_config_client]',
                          ],
            })
          }
        end

        # common::mkdir_p { $afs_config_path_real: }
        it {
          should contain_exec("mkdir_p-#{v[:afs_config_path_default]}").with({
            'command' => "mkdir -p #{v[:afs_config_path_default]}",
            'unless'  => "test -d #{v[:afs_config_path_default]}",
          })
        }

        # file { 'afs_init_script' :}
        it {
          should contain_file('afs_init_script').with({
            'ensure'  => 'file',
            'path'    => v[:init_script_default],
            'owner'   => 'root',
            'group'   => 'root',
            'mode'    => '0755',
            'source'  => "puppet:///modules/afs/#{v[:init_template_default]}",
            'before'  => 'Service[afs_openafs_client_service]',
          })
        }

        # file { 'afs_config_cacheinfo' :}
        it {
          should contain_file('afs_config_cacheinfo').with({
            'ensure'  => 'file',
            'path'    => "#{v[:afs_config_path_default]}/cacheinfo",
            'owner'   => 'root',
            'group'   => 'root',
            'mode'    => '0644',
            'content' => "/afs:#{v[:cache_path_default]}:1000000\n",
            'require' => "Common::Mkdir_p[#{v[:afs_config_path_default]}]",
            'before'  => 'Service[afs_openafs_client_service]',
          })
        }

        # common::mkdir_p { $config_client_dir_real: } # Hint: need to extract the dirname from the file path
        it {
          should contain_exec("mkdir_p-#{File.dirname(v[:config_client_path_default])}").with({
            'command' => "mkdir -p #{File.dirname(v[:config_client_path_default])}",
            'unless'  => "test -d #{File.dirname(v[:config_client_path_default])}",
          })
        }

        # file { 'afs_config_client' :}
        it {
          should contain_file('afs_config_client').with({
            'ensure'  => 'file',
            'path'    => "#{v[:config_client_path_default]}",
            'owner'   => 'root',
            'group'   => 'root',
            'mode'    => '0644',
            'require' => "Common::Mkdir_p[#{File.dirname(v[:config_client_path_default])}]",
            'before'  => 'Service[afs_openafs_client_service]',
          })
        }
        it { should contain_file('afs_config_client').with_content(/^AFSD_ARGS=\"-dynroot -afsdb -daemons 6 -volumes 1000 -nosettime\"$/) }
        it { should contain_file('afs_config_client').with_content(/^UPDATE=\"false\"$/) }
        it { should contain_file('afs_config_client').with_content(/^DKMS=\"#{v[:config_client_dkms_default]}\"$/) }
        it { should contain_file('afs_config_client').with_content(/^CLEANCACHE=\"false\"$/) }

        # service { 'afs_openafs_client_service':}
        it {
          should contain_service('afs_openafs_client_service').with({
            'ensure'     => 'running',
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
                            ],
          })
        }
      end
    end

    context "where osfamily is <Solaris> running in a container" do
      let :facts do
        { :osfamily   => 'Solaris',
          :virtual    => 'zone',
          :is_virtual => 'true',
        }
      end
      let :params do
        { :afs_suidcells    => 'sunset.github.com',
          :afs_cell         => 'sunset.github.com',
          :afs_cellserverdb => '>sunset.github.com\t#Sunset',
        }
      end
      it { should contain_file('afs_init_script'        ).with_before(nil) }
      it { should contain_file('afs_config_cacheinfo'   ).with_before(nil) }
      it { should contain_file('afs_config_client'      ).with_before(nil) }
      it { should contain_file('afs_config_suidcells'   ).with_before(nil) }
      it { should contain_file('afs_config_thiscell'    ).with_before(nil) }
      it { should contain_file('afs_config_cellserverdb').with_before(nil) }
      it { should_not contain_service('afs_openafs_client_service') }
      it { should_not contain_cron('afs_cron_job') }
      it { should_not contain_file('afs_cron_job') }
    end

    context "where osfamily is <Suse> and operatingsystemrelease is <12>" do
      let :facts do
        { :osfamily               => 'Suse',
          :operatingsystemrelease => '12',
          :is_virtual             => nil,
        }
      end

      it {
        should contain_file_line('allow_unsupported_modules').with({
          'ensure' => 'present',
          'path'   => '/etc/modprobe.d/10-unsupported-modules.conf',
          'line'   => 'allow_unsupported_modules 1',
          'match'  => '^allow_unsupported_modules 0$',
          'before' => 'Service[afs_openafs_client_service]',
        })
      }
    end

  end

  describe "with optional parameters set" do
    let :facts do
      { :osfamily                  => 'RedHat',
        :operatingsystemmajrelease => '7',
        :is_virtual                => nil,
      }
    end
    let :params do
      { :afs_suidcells    => 'sunset.github.com',
        :afs_cell         => 'sunset.github.com',
        :afs_cellserverdb => '>sunset.github.com\t#Sunset',
      }
    end

    context "where afs_suidcells is <sunset.github.com>" do
      # file { 'afs_config_suidcells' :}
      it {
        should contain_file('afs_config_suidcells').with({
          'ensure' => 'file',
          'path'   => '/usr/vice/etc/SuidCells',
          'owner'  => 'root',
          'group'  => 'root',
          'mode'   => '0644',
          'require' =>'Common::Mkdir_p[/usr/vice/etc]',
          'before'  => 'Service[afs_openafs_client_service]',
        })
      }
      it { should contain_file('afs_config_suidcells').with_content(/^sunset.github.com$/) }
    end

    context "where afs_cell is <sunset.github.com>" do
      # file { 'afs_config_thiscell' :}
      it {
        should contain_file('afs_config_thiscell').with({
          'ensure' => 'file',
          'path'   => '/usr/vice/etc/ThisCell',
          'owner'  => 'root',
          'group'  => 'root',
          'mode'   => '0644',
          'require' =>'Common::Mkdir_p[/usr/vice/etc]',
          'before'  => 'Service[afs_openafs_client_service]',
        })
      }
      it { should contain_file('afs_config_thiscell').with_content(/^sunset.github.com$/) }
    end

    context "where afs_cellserverdb is <>sunset.github.com\t#Sunset>" do
      # file { 'afs_config_cellserverdb' :}
      it {
        should contain_file('afs_config_cellserverdb').with({
          'ensure' => 'file',
          'path'   => '/usr/vice/etc/CellServDB',
          'owner'  => 'root',
          'group'  => 'root',
          'mode'   => '0644',
          'require' =>'Common::Mkdir_p[/usr/vice/etc]',
          'before'  => 'Service[afs_openafs_client_service]',
        })
      }
      it { should contain_file('afs_config_cellserverdb').with_content(/^>sunset.github.com\\t#Sunset$/) }
    end
  end

  describe "with Solaris specific parameters set" do
    let :facts do
      { :osfamily   => 'Solaris',
        :is_virtual => nil,
        :virtual    => nil,
      }
    end
    let :params do
      { :package_adminfile => '/sw/Solaris/Sparc/noask',
        :package_provider  => 'sun',
        :package_source    => '/sw/Solaris/Sparc/EISopenafs',
        :service_provider  => 'init',
        :package_name      => ['EISopenafs'],
      }
    end

    context "where adminfile is </sw/Solaris/Sparc/noask>" do
      it {
        should contain_package('EISopenafs').with({
          'adminfile' => '/sw/Solaris/Sparc/noask',
        })
      }
    end

    context "where package_provider is <sun>" do
      it {
        should contain_package('EISopenafs').with({
          'provider'  => 'sun',
        })
      }
    end

    context "where source is </sw/Solaris/Sparc/EISopenafs>" do
      it {
        should contain_package('EISopenafs').with({
          'source'    => '/sw/Solaris/Sparc/EISopenafs'
        })
      }
    end

    context "where service_provider is <init>" do
      # service { 'afs_openafs_client_service':}
      it {
        should contain_service('afs_openafs_client_service').with({
          'provider'   => 'init',
        })
      }
    end
  end

  describe "with cronjob" do
    let :facts do
      { :osfamily                  => 'RedHat',
        :is_virtual                => nil,
        :operatingsystemmajrelease => '7',
      }
    end

    ['hourly','daily','weekly','monthly'].each do |value|
      context "where afs_cron_job_interval is <#{value}>" do
        let :params do
          { :afs_cron_job_content  => '#!/bin/sh\n/sw/RedHat/afs_setserverprefs.sh',
            :afs_cron_job_interval => "#{value}",
          }
        end

        # file { 'afs_cron_job' :}
        it {
          should contain_file('afs_cron_job').with({
            'ensure'  => 'file',
            'path'    => "/etc/cron.#{value}/afs_cron_job",
            'owner'   => 'root',
            'group'   => 'root',
            'mode'    => '0755',
            'content' => '#!/bin/sh\\n/sw/RedHat/afs_setserverprefs.sh',
            'require' => 'File[afs_init_script]',
          })
        }
      end
    end

    context "where afs_cron_job_interval is <specific>" do
      let :params do
        { :afs_cron_job_content  => '#!/bin/sh\n/sw/RedHat/afs_setserverprefs.sh',
          :afs_cron_job_interval => "specific",
          :afs_cron_job_hour     => '2',
          :afs_cron_job_month    => '2',
          :afs_cron_job_weekday  => '4',
          :afs_cron_job_monthday => '2',
        }
      end

      # file { 'afs_cron_job' :}
      it {
        should contain_cron('afs_cron_job').with({
          'ensure'   => 'present',
          'command'  => '#!/bin/sh\\n/sw/RedHat/afs_setserverprefs.sh',
          'user'     => 'root',
          'minute'   => '42',
          'hour'     => '2',
          'month'    => '2',
          'weekday'  => '4',
          'monthday' => '2',
          'require' => 'File[afs_init_script]',
        })
      }
    end
  end

  describe "with symlink" do
    let :facts do
      { :osfamily                  => 'RedHat',
        :operatingsystemmajrelease => '7',
        :is_virtual                => nil,
      }
    end
    let :params do
      { :create_symlinks => 'true',
        :links => {
          'test-app' => {
            'path'   => '/tmp/app',
            'target' => '/sw/RedHat/app',
          }
        }
      }
    end

    # create_resources(file, $links, $afs_create_link_defaults)
    it {
      should contain_file('test-app').with({
        'ensure'  => 'link',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0755',
        'path'    => '/tmp/app',
        'target'  => '/sw/RedHat/app',
      })
    }
  end

  describe 'with config_client_clean_cache_on_start set to valid boolean true' do
    let :facts do
      { :osfamily                  => 'RedHat',
        :operatingsystemmajrelease => '7',
        :is_virtual                => nil,
      }
    end
    let(:params) { { :config_client_clean_cache_on_start => true } }
    it { should contain_file('afs_config_client').with_content(/^CLEANCACHE=\"true\"$/) }
  end

  describe 'variable type and content validations' do
    # set needed custom facts and variables
    let(:facts) do
      {
        :osfamily                  => 'RedHat',
        :operatingsystemmajrelease => '7',
        :is_virtual                => nil,
      }
    end
    let(:mandatory_params) do
      {
        #:param => 'value',
      }
    end

    validations = {
      'boolean / stringified' => {
        :name    => %w(config_client_clean_cache_on_start),
        :valid   => [true, 'false'],
        :invalid => ['string', %w(array), { 'ha' => 'sh' }, 3, 2.42, nil],
        :message => '(Unknown type of boolean given|Requires either string to work with)',
      },
    }

    validations.sort.each do |type, var|
      var[:name].each do |var_name|
        var[:params] = {} if var[:params].nil?
        var[:valid].each do |valid|
          context "when #{var_name} (#{type}) is set to valid #{valid} (as #{valid.class})" do
            let(:params) { [mandatory_params, var[:params], { :"#{var_name}" => valid, }].reduce(:merge) }
            it { should compile }
          end
        end

        var[:invalid].each do |invalid|
          context "when #{var_name} (#{type}) is set to invalid #{invalid} (as #{invalid.class})" do
            let(:params) { [mandatory_params, var[:params], { :"#{var_name}" => invalid, }].reduce(:merge) }
            it 'should fail' do
              expect { should contain_class(subject) }.to raise_error(Puppet::Error, /#{var[:message]}/)
            end
          end
        end
      end # var[:name].each
    end # validations.sort.each
  end # describe 'variable type and content validations'
end
