
mkdir -p /usr/local/bundle/bundler.d






apk add alpine-sdk libffi-dev ruby-dev

git clone --depth=1 -b v0.9.2 https://github.com/theforeman/smart_proxy_openscap.git

cd smart_proxy_openscap

bundle install

gem build



git clone --depth=1 --branch 3.9.1 https://github.com/theforeman/smart-proxy.git

rm bundler.d/libvirt.rb
rm bundler.d/krb5.rb
rm bundler.d/realm_freeipa.rb
rm bundler.d/windows.rb
rm bundler.d/bmc.rb
rm bundler.d/journald.rb

bundle install --with development

# to run
bundle exec ruby bin/smart-proxy





dockerfile

copy --from=build smart_proxy_openscap-0.9.2.gem


cat <<'EOF' > bundler.d/openscap.rb

gem 'smart_proxy_openscap', :git => "https://github.com/theforeman/smart_proxy_openscap.git", :branch => 'v0.9.2'

EOF