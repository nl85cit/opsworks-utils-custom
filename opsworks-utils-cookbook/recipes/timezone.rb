# Amazon Linux specific http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/set-time.html
file '/etc/sysconfig/clock' do
  content <<-EOH
    ZONE="America/New_York"
    UTC=true
  EOH
end

link '/etc/localtime' do
  to '/usr/share/zoneinfo/America/New_York'
end
