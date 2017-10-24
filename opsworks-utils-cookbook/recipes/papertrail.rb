# TODO: Parameterize Papertrail configuration. Pull values from custom JSON

remote_file '/tmp/remote_syslog_linux_amd64.tar.gz' do
  source 'https://github.com/papertrail/remote_syslog2/releases/download/v0.19/remote_syslog_linux_amd64.tar.gz'
  action :create_if_missing
end

execute 'untar-remote-syslog2' do
  cwd '/tmp'
  command  'tar xzf /tmp/remote_syslog_linux_amd64.tar.gz'
  not_if { ::File.exist?('/tmp/remote_syslog') }
end

instance = search('aws_opsworks_instance', 'self:true').first
stack = search('aws_opsworks_stack').first
host_name = "#{stack['name']}-#{instance['hostname']}"
log "Using hostname: #{host_name}"

template '/etc/log_files.yml' do
  source 'papertrail/log_files.yml.erb'
  mode '00644'
  owner 'root'
  group 'root'
  variables(:host_name => host_name)
end

cookbook_file '/etc/init.d/remote_syslog' do
  mode '00555'
  owner 'root'
  group 'root'
  source 'papertrail/remote_syslog'
end

remote_file '/usr/local/bin/remote_syslog' do
  mode '00555'
  owner 'root'
  group 'root'
  source 'file:/tmp/remote_syslog/remote_syslog'
  action :create
end

service 'stop-remote-syslog' do
  service_name 'remote_syslog'
  action :stop
  ignore_failure true
end

service 'enable-remote-syslog' do
  service_name 'remote_syslog'
  action :enable
end

service 'restart-remote-syslog' do
  service_name 'remote_syslog'
  action :restart
end
