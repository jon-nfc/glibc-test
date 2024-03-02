
mkdir -p /usr/local/bundle/bundler.d

cat <<'EOF' > /usr/local/bundle/bundler.d/openscap.rb




apk add alpine-sdk libffi-dev

git clone --depth=1 -b v0.9.2 https://github.com/theforeman/smart_proxy_openscap.git

cd smart_proxy_openscap

bundle install

gem build


dockerfile

copy --from=build smart_proxy_openscap-0.9.2.gem



# gem 'openscap_parser'

# gem 'smart_proxy_openscap', :git => "https://github.com/theforeman/smart_proxy_openscap.git", :branch => 'v0.9.2'

EOF