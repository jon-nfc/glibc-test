# not needed as it can be integrated directly with AWX
# https://github.com/theforeman/foreman_ansible
# gem 'foreman_ansible'
gem 'foreman_fog_proxmox'


#gem 'foreman_openscap', :git => "https://github.com/theforeman/foreman_openscap.git", :branch => 'v6.0.0'
gem 'foreman_openscap', :git => "https://github.com/theforeman/foreman_openscap.git", :branch => 'v5.2.3'

gem 'foreman_default_hostgroup', :git => "https://github.com/theforeman/foreman_default_hostgroup.git", :branch => '7.0.0'

gem 'foreman_discovery', :git => "https://github.com/theforeman/foreman_discovery.git", :branch => 'v22.0.4'





gem 'foreman_bootdisk', :git => "https://github.com/theforeman/foreman_bootdisk.git", :branch => 'v21.2.1'

# threw error
# gem 'foreman_rescue', :git => "https://github.com/dm-drogeriemarkt/foreman_rescue.git", :branch => '3.0.0'

gem 'foreman_dhcp_browser', :git => "https://github.com/theforeman/foreman_dhcp_browser.git", :branch => 'v0.0.8'

# errors with NameError: uninitialized constant Proxy::Provider
# gem 'smart_proxy_dns_powerdns', :git => "https://github.com/theforeman/smart_proxy_dns_powerdns.git", :branch => '1.0.0'


gem 'foreman_statistics', :git => "https://github.com/theforeman/foreman_statistics.git", :branch => 'v2.1.0'

gem 'foreman_vault', :git => "https://github.com/dm-drogeriemarkt/foreman_vault.git", :branch => '1.2.0'


# latest additions
gem 'foreman_webhooks', :git => "https://github.com/theforeman/foreman_webhooks.git", :branch => 'v3.2.1'

gem 'foreman_kubevirt', :git => "https://github.com/theforeman/foreman_kubevirt.git", :branch => 'v0.1.9'

gem 'foreman_git_templates', :git => "https://github.com/dm-drogeriemarkt/foreman_git_templates.git", :branch => '1.0.6'





# May be required to link hosts to server. nope. read debian guide
# gem 'katello', :git => "https://github.com/Katello/katello.git", :branch => '4.11.1'

# # only for icinga2
# #gem 'foreman_monitoring'
