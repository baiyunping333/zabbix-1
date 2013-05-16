# Author:: Nacer Laradji (<nacer.laradji@gmail.com>)
# Cookbook Name:: zabbix
# Recipe:: common
#
# Copyright 2011, Efactures
#
# Apache 2.0
#

# Create zabbix group
group node['zabbix']['login'] do
  gid node['zabbix']['gid']
  if node['zabbix']['gid'].nil? 
    action :nothing
  else
    action :create
  end
end

# Create zabbix User
user node['zabbix']['login'] do
  comment "zabbix User"
  home node['zabbix']['install_dir']
  shell node['zabbix']['shell']
  uid node['zabbix']['uid']
  gid node['zabbix']['gid'] 
end

# Define root owned folders
root_dirs = [
  node['zabbix']['etc_dir'],
]

# Create root folders
root_dirs.each do |dir|
  directory dir do
    owner "root"
    group "root"
    mode "755"
    recursive true
  end
end

# Define zabbix owned folders
zabbix_dirs = [
  node['zabbix']['log_dir'],
  node['zabbix']['run_dir']
]

# Create zabbix folders
zabbix_dirs.each do |dir|
  directory dir do
    owner node['zabbix']['login']
    group node['zabbix']['group']
    mode "755"
    recursive true
    # Only execute this if zabbix can't write to it. This handles cases of
    # dir being world writable (like /tmp)
    # [ File.word_writable? doesn't appear until Ruby 1.9.x ]
    not_if "su #{node['zabbix']['login']} -c \"test -d #{dir} && test -w #{dir}\""
  end
end
