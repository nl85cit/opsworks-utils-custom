stack = search('aws_opsworks_stack').first
instance = search('aws_opsworks_instance', 'self:true').first

route53_record 'instance-dns-record' do
  name  "#{stack['name']}-#{instance['hostname']}.#{node['route53']['subdomain']}"
  value instance['private_ip']
  type  'A'
  zone_id node['route53']['zone_id']
  overwrite true
  fail_on_error true
  ttl 300
  action :nothing
end