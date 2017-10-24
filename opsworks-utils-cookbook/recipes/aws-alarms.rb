stack = search('aws_opsworks_stack').first
instance = search('aws_opsworks_instance', 'self:true').first

aws_cloudwatch 'disk-space-alarm' do
  alarm_name "#{stack['name']}-#{instance['hostname']}-disk-space-alarm".gsub(' ', '-')
  period 600
  evaluation_periods 2
  threshold 90
  comparison_operator 'GreaterThanThreshold'
  metric_name 'DiskSpaceUtilization'
  namespace 'System/Linux'
  statistic 'Average'
  dimensions [{ :name => 'InstanceId', :value => instance['ec2_instance_id'] }, { :name => 'MountPath', :value => '/' }, { :name => 'Filesystem', :value => '/dev/xvda1' }]
  action :nothing
  actions_enabled true
  alarm_actions node['alarms']['notify_sns_topic_arns']
end

aws_cloudwatch 'memory-utilization-alarm' do
  alarm_name "#{stack['name']}-#{instance['hostname']}-memory-utilization-alarm".gsub(' ', '-')
  period 600
  evaluation_periods 2
  threshold 80
  comparison_operator 'GreaterThanThreshold'
  metric_name 'MemoryUtilization'
  namespace 'System/Linux'
  statistic 'Average'
  dimensions [{ :name => 'InstanceId', :value => instance['ec2_instance_id'] }]
  action :nothing
  actions_enabled true
  alarm_actions node['alarms']['notify_sns_topic_arns']
end

aws_cloudwatch 'swap-utilization-alarm' do
  alarm_name "#{stack['name']}-#{instance['hostname']}-swap-utilization-alarm".gsub(' ', '-')
  period 600
  evaluation_periods 2
  threshold 50
  comparison_operator 'GreaterThanThreshold'
  metric_name 'SwapUtilization'
  namespace 'System/Linux'
  statistic 'Average'
  dimensions [{ :name => 'InstanceId', :value => instance['ec2_instance_id'] }]
  action :nothing
  actions_enabled true
  alarm_actions node['alarms']['notify_sns_topic_arns']
end

aws_cloudwatch 'status-check-alarm' do
  alarm_name "#{stack['name']}-#{instance['hostname']}-status-check-alarm".gsub(' ', '-')
  period 60
  evaluation_periods 1
  threshold 1
  comparison_operator 'GreaterThanOrEqualToThreshold'
  metric_name 'StatusCheckFailed'
  namespace 'AWS/EC2'
  statistic 'Maximum'
  dimensions [{ :name => 'InstanceId', :value => instance['ec2_instance_id'] }]
  action :nothing
  actions_enabled true
  alarm_actions node['alarms']['notify_sns_topic_arns']
end
