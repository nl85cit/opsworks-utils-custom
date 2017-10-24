instance = search('aws_opsworks_instance', 'self:true').first
log "Host #{instance['hostname']} caught a SHUTDOWN event."

#### ALARMS ####
include_recipe 'opsworks-utils-cookbook::aws-alarms'

log 'Removing cloudwatch alarm: disk space' do
  notifies :create, 'aws_cloudwatch[disk-space-alarm]', :immediately
end

log 'Removing cloudwatch alarm: memory utilization' do
  notifies :create, 'aws_cloudwatch[memory-utilization-alarm]', :immediately
end

log 'Removing cloudwatch alarm: swap utilization' do
  notifies :delete, 'aws_cloudwatch[swap-utilization-alarm]', :immediately
end

log 'Removing cloudwatch alarm: status check failed' do
  notifies :delete, 'aws_cloudwatch[status-check-alarm]', :immediately
end

#### ROUTE53 ####
include_recipe 'opsworks-utils-cookbook::dns'

log "Deleting DNS Record for instance from Route53" do
  notifies :delete, 'route53_record[instance-dns-record]', :immediately
end
