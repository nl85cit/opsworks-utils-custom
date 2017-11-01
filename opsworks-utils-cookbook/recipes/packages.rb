package_install_array =  ['emacs']

package_install_array.each do |this_package|
  case node[:platform]
  when "amazon"
    rpm_package "#{this_package}"
  when "redhat"
    rpm_package "#{this_package}"
  when "ubuntu"
    dpkg_package "#{this_package}"
  when "suse"
    zypper_package "#{this_package}"
  else
    rpm_package "#{this_package}"
 end
end
