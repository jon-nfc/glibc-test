
# mkdir -p /usr/local/bundle/bundler.d






# apk add alpine-sdk libffi-dev ruby-dev

# git clone --depth=1 -b v0.9.2 https://github.com/theforeman/smart_proxy_openscap.git

# cd smart_proxy_openscap

# bundle install

# gem build



# git clone --depth=1 --branch 3.9.1 https://github.com/theforeman/smart-proxy.git

# rm bundler.d/libvirt.rb
# rm bundler.d/krb5.rb
# rm bundler.d/realm_freeipa.rb
# rm bundler.d/windows.rb
# rm bundler.d/bmc.rb
# rm bundler.d/journald.rb

# bundle install --with development

# # to run
# bundle exec ruby bin/smart-proxy





# dockerfile

# copy --from=build smart_proxy_openscap-0.9.2.gem


# cat <<'EOF' > bundler.d/openscap.rb

gem 'smart_proxy_openscap', :git => "https://github.com/theforeman/smart_proxy_openscap.git", :branch => 'v0.9.2'

gem 'smart_proxy_ipam', :git => "https://github.com/grizzthedj/smart_proxy_ipam.git", :branch => 'v0.0.13'

gem 'smart_proxy_discovery', :git => "https://github.com/theforeman/smart_proxy_discovery.git", :branch => '1.0.5'

gem 'smart_proxy_dns_powerdns', :git => "https://github.com/theforeman/smart_proxy_dns_powerdns.git", :branch => '1.0.0'


##### new
# possibly broken https://github.com/adamruzicka/foreman_probing/issues/9
# gem 'smart-proxy-probing', :git => "https://github.com/adamruzicka/smart-proxy-probing.git", :branch => 'v0.0.4'



gem 'smart_proxy_dynflow', :git => 'https://github.com/theforeman/smart_proxy_dynflow.git', :branch => 'v0.9.2'
# gem 'smart_proxy_dynflow_core', :git => 'https://github.com/theforeman/smart_proxy_dynflow.git', :branch => 'v0.9.2'
gem 'foreman_remote_execution', :git => 'https://github.com/theforeman/foreman_remote_execution.git', :branch => 'v12.0.5'
gem 'smart_proxy_remote_execution_ssh', :git => "https://github.com/theforeman/smart_proxy_remote_execution_ssh.git", :branch => 'v0.10.4'


gem 'smart_proxy_ansible', :git => "https://github.com/theforeman/smart_proxy_ansible.git", :branch => 'v3.5.5'


# required for facts
group :facter do
    gem 'facter'
end

