include_recipe 'opsworks-utils-cookbook::dns'

stack = search('aws_opsworks_stack').first
instance = search('aws_opsworks_instance', 'self:true').first

log "Creating DNS Record: #{stack['name']}-#{instance['hostname']}.#{node['route53']['subdomain']}" do
  notifies :create, 'route53_record[instance-dns-record]', :immediately
end
