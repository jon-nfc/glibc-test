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


# https://github.com/dm-drogeriemarkt/foreman_git_templates/issues/66
# apparent fixes for foreman 3.1
gem 'foreman_git_templates', :git => "https://github.com/dm-drogeriemarkt/foreman_git_templates.git", :ref => 'e8273a622d4f51a6cfe12ad32d3cd08840b5c1b7'

#gem 'foreman_git_templates', :git => "https://github.com/dm-drogeriemarkt/foreman_git_templates.git", :branch => '1.0.6'


# https://docs.theforeman.org/3.0/Managing_Hosts/index-foreman-el.html#Synchronizing_Templates_Repositories
gem 'foreman_templates', :git => "https://github.com/theforeman/foreman_templates.git", :branch => 'v9.4.0'



gem 'foreman-tasks', :git => "https://github.com/theforeman/foreman-tasks.git", :branch => 'v9.1.0'

gem 'foreman_remote_execution', :git => "https://github.com/theforeman/foreman_remote_execution.git", :branch => 'v12.0.5'


gem 'foreman_ansible', :git => "https://github.com/theforeman/foreman_ansible.git", :branch => 'v13.0.3'

gem 'foreman_puppet', :git => "https://github.com/theforeman/foreman_puppet.git", :branch => 'v6.2.0'


# # only for icinga2
# #gem 'foreman_monitoring'


# # May be required to link hosts to server. nope. read debian guide
# gem 'katello', :git => "https://github.com/Katello/katello.git", :branch => '4.11.0'
# # gem 'puppet-candlepin', :git => "https://github.com/theforeman/puppet-candlepin.git", :branch => '15.1.0'



##################################### Error
# #31 9.873 2024-03-11T09:06:50 [W|app|] ForemanProbing: skipping engine hook (undefined method `register_fact_importer' for FactImporter:Class)
# #31 9.875 rake aborted!
# #31 9.889 NameError: undefined local variable or method `belongs_to_host' for ForemanProbing::ProbingFacet(Table doesn't exist):Class
# #31 9.889 Did you mean?  belongs_to
# #31 9.889 /home/foreman/vendor/ruby/2.7.0/gems/activerecord-6.1.7.7/lib/active_record/dynamic_matchers.rb:22:in `method_missing'
# #31 9.889 /home/foreman/app/models/concerns/facets/base.rb:8:in `block in <module:Base>'
# #31 9.889 /home/foreman/vendor/ruby/2.7.0/gems/activesupport-6.1.7.7/lib/active_support/concern.rb:136:in `class_eval'
# #31 9.889 /home/foreman/vendor/ruby/2.7.0/gems/activesupport-6.1.7.7/lib/active_support/concern.rb:136:in `append_features'
# gem 'foreman_probing', :git => "https://github.com/adamruzicka/foreman_probing.git", :branch => 'v0.0.4'


# Latest
gem 'foreman_setup', :git => "https://github.com/theforeman/foreman_setup.git", :branch => 'v8.0.1'

# works, is black like awx looks like can be customized, see repo
# gem 'foreman_theme_satellite', :git => "https://github.com/RedHatSatellite/foreman_theme_satellite.git", :branch => 'v13.2.4'



