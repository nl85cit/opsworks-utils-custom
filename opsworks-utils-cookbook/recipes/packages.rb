package 'nano'

package_install_array =  ['nano', 'emacs']

package_install_array.each do |this_package|
  case node[:platform]
  when "amazon"
    package "#{this_package}"
  when "redhat"
    package "#{this_package}"
  when "ubuntu"
    package "#{this_package}"
  when "suse"
    zypper_package "#{this_package}"
  else
    package "#{this_package}"
 end
end
