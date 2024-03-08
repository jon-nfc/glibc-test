# Base container that is used for both building and running the app
# ref: https://github.com/ohadlevy/foreman/blob/8995cba7c7c6f95e4f3ef55bee435254f2e8cc24/Dockerfile
FROM ruby:2.7-alpine3.14 as foreman-base-ruby

# test ansible plugin
# FROM ruby:2.7.8-alpine3.16 as foreman-base-ruby


ENV RAILS_ENV production
ENV RAILS_SERVE_STATIC_FILES true
ENV RAILS_LOG_TO_STDOUT true

RUN apk add -U \
  # tzdata \
  gettext bash postgresql \
  # mysql-client \
  npm netcat-openbsd \
    #  && cp /usr/share/zoneinfo/Europe/Berlin /etc/localtime \
    #  && apk del tzdata \
     && rm -rf /var/cache/apk/*

ENV FOREMAN_FQDN docker-swarm-01.kstm.lab.net
ENV FOREMAN_DOMAIN kstm.lab.net

ARG HOME=/home/foreman
WORKDIR $HOME
# ENV BUNDLE_APP_CONFIG='${home}/vendor/bundle'

ENV BUNDLE_APP_CONFIG '/home/foreman/.bundle'
# ENV GEM_HOME "${HOME}/vendor/ruby/2.7.0"


# RUN bundle config set --local without "${BUNDLER_SKIPPED_GROUPS}"; \
#   bundle config set --local clean true; \
#   bundle config set --local path vendor; \
#   bundle config set --local jobs 5; \
#   bundle config set --local retry 3; \
#   ls -la ${HOME};

RUN addgroup --system foreman
RUN adduser --home $HOME --system --shell /bin/false --ingroup foreman --gecos Foreman foreman

# Add a script to be executed every time the container starts.
# COPY extras/containers/entrypoint.sh /usr/bin/
# RUN cp extras/containers/entrypoint.sh /usr/bin/; chmod +x /usr/bin/entrypoint.sh

# ENTRYPOINT ["entrypoint.sh"]



FROM foreman-base-ruby as foreman-ruby-builder
RUN apk add --update bash git gcc cmake libc-dev build-base \
                         curl-dev libxml2-dev gettext \
                        #  sqlite-dev \
                        # postgresql12-dev \
                        postgresql-dev \
                        npm \
                        # https://github.com/github/pages-gem/issues/839
                        gcompat \
                        # build fail couldnt find python3 in '/usr/bin/python3' https://github.com/jon-nfc/glibc-test/actions/runs/8127320703/job/22212022669
                        python3 \
                        # Try python 2 in an attempt to fix 'Syntax Error: Command failed: /usr/bin/python3 -c import sys; print "%s.%s.%s" % sys.version_info[:3];'
                        python2 \
     && rm -rf /var/cache/apk/*

RUN which python3 || true



# ENV RAILS_ENV production
ENV FOREMAN_APIPIE_LANGS en
ENV BUNDLER_SKIPPED_GROUPS "test development openid libvirt journald console"
# ENV DATABASE_URL=sqlite3:tmp/bootstrap-db.sql
ENV DATABASE_URL=nulldb://nohost
# ENV BUNDLE_APP_CONFIG=''
ARG HOME=/home/foreman
# USER foreman
WORKDIR $HOME
# COPY --chown=foreman . ${HOME}/
# COPY . ${HOME}/

RUN echo ""; mkdir -p /tmp/app; \
  git clone --depth=1 --branch 3.9.1 https://github.com/theforeman/foreman.git /tmp/app;


COPY Gemfile.local-amd64.rb /tmp/app/bundler.d/Gemfile.local.rb


RUN rm -rf /tmp/app/.git; \
  cp -r /tmp/app/* ${HOME}/; \
  chown foreman:foreman -R ${HOME}/.; \
  chmod 770 -R ${HOME}/.; \
  cd ${HOME};

RUN echo ""; ls -la;

# USER foreman

# RUN mkdir -p .bundle; \
#   echo "---" > .bundle/config; \
#   echo '"BUNDLE_PATH: "vendor/bundle"' > .bundle/config;


RUN ls -la; bundle config set --local path vendor

RUN bundle config set --local without "${BUNDLER_SKIPPED_GROUPS}"

RUN bundle config set --local clean true

RUN bundle config set --local jobs 5

RUN bundle config set --local retry 3


RUN bundle install && \
  bundle binstubs --all && \
  rm -rf vendor/ruby/*/cache/*.gem && \
  find vendor/ruby/*/gems -name "*.c" -delete && \
  find vendor/ruby/*/gems -name "*.o" -delete


RUN make -C locale all-mo

RUN mv -v db/schema.rb.nulldb db/schema.rb

RUN bundle exec rake assets:clean assets:precompile





FROM node:14.0.0-alpine3.11 as foreman-node-builder
# Ansible plugin test
# FROM node:16.20.2-alpine3.17 as foreman-node-builder

ARG HOME=/home/foreman

# USER 0

RUN apk add --no-cache \
    git \
    python \
    alpine-sdk \
    libffi-dev


WORKDIR ${HOME}
# COPY --chown=foreman . ${HOME}/
COPY --from=foreman-ruby-builder --chown=foreman:foreman ${HOME}/. ${HOME}/

# USER foreman

# ^4.5.0 to low for node 14. https://www.npmjs.com/package/node-sass
# RUN sed -E 's/"node-sass": (.+)/"node-sass": "~4.14",/g' -i ${HOME}/package.json; \
#   cat ${HOME}/package.json;

# this line was test. removing to revert
# RUN npm install --no-audit --no-optional --legacy-peer-deps && \
# RUN npm install --no-audit --no-optional --force && \

# RUN npm i react-json-tree --legacy-peer-deps

RUN npm install --no-audit --no-optional --legacy-peer-deps

# RUN 



FROM foreman-ruby-builder as foreman-builder


ARG HOME=/home/foreman



WORKDIR ${HOME}


COPY --from=foreman-node-builder --chown=foreman:foreman ${HOME}/. ${HOME}/


RUN ./node_modules/webpack/bin/webpack.js --config config/webpack.config.js

# cleanups
RUN rm -rf public/webpack/stats.json ./node_modules vendor/ruby/*/cache vendor/ruby/*/gems/*/node_modules bundler.d/nulldb.rb db/schema.rb

RUN bundle config without "${BUNDLER_SKIPPED_GROUPS} assets"

RUN bundle install

# Adding missing gems, for tzdata see https://bugzilla.redhat.com/show_bug.cgi?id=1611117
# RUN echo gem '"rdoc"' > bundler.d/container.rb && echo gem '"tzinfo-data"' >> bundler.d/container.rb


# RUN bundle install --without "${BUNDLER_SKIPPED_GROUPS}" \
#     --binstubs --clean --path vendor --jobs=5 --retry=3 && \
#   rm -rf vendor/ruby/*/cache/*.gem && \
#   find vendor/ruby/*/gems -name "*.c" -delete && \
#   find vendor/ruby/*/gems -name "*.o" -delete

# RUN npm install --no-optional

# RUN \
#   make -C locale all-mo && \
#   bundle exec rake assets:clean assets:precompile db:migrate &&  \
#   bundle exec rake db:seed apipie:cache:index && rm -f tmp/bootstrap-db.sql

# RUN ./node_modules/webpack/bin/webpack.js --config config/webpack.config.js \
#   && npm run analyze && rm -rf public/webpack/stats.json

# RUN rm -rf vendor/ruby/*/cache vendor/ruby/*/gems/*/node_modules

FROM foreman-base-ruby

ARG HOME=/home/foreman
ARG RAILS_ENV=production
ENV RAILS_SERVE_STATIC_FILES=true
ENV RAILS_LOG_TO_STDOUT=true
# ENV BUNDLE_APP_CONFIG=''

USER foreman
WORKDIR ${HOME}
# COPY --chown=foreman . ${HOME}/
COPY --from=foreman-builder --chown=foreman:foreman /tmp/app/. ${HOME}/
# COPY --from=foreman-builder /usr/bin/entrypoint.sh /usr/bin/entrypoint.sh
COPY --from=foreman-builder --chown=foreman:foreman ${HOME}/.bundle/config ${HOME}/.bundle/config
COPY --from=foreman-builder --chown=foreman:foreman ${HOME}/Gemfile.lock ${HOME}/Gemfile.lock
COPY --from=foreman-builder --chown=foreman:foreman ${HOME}/vendor/ruby ${HOME}/vendor/ruby
COPY --from=foreman-builder --chown=foreman:foreman ${HOME}/public ${HOME}/public

# RUN echo gem '"rdoc"' > bundler.d/container.rb && echo gem '"tzinfo-data"' >> bundler.d/container.rb

RUN date -u > BUILD_TIME

# RUN cp ${HOME}/extras/containers/entrypoint.sh /usr/bin/; 
USER 0
# RUN chmod +x /usr/bin/entrypoint.sh
RUN apk add libc6-compat

USER foreman
# ENTRYPOINT ["entrypoint.sh"]
RUN bundle install

# Start the main process.
CMD "bundle exec bin/rails server"

EXPOSE 3000/tcp
EXPOSE 5910-5930/tcp

























# ARG HOME=/home/foreman


# RUN mkdir -p ${HOME}

# WORKDIR ${HOME}

# ENV GEM_HOME "${HOME}/vendor/ruby/2.7.0"

# RUN apk add --no-cache \
#     nodejs \
#     npm; \
#   gem install rake bundler:2.4.22;





# ##########################################################################
# #
# #    Builder
# #
# ##########################################################################
# FROM base as builder

# ENV RAILS_ENV=production
# ENV FOREMAN_APIPIE_LANGS=en
# ENV BUNDLER_SKIPPED_GROUPS="test development openid libvirt journald facter console"
# ENV DATABASE_URL=nulldb://nohost


# ARG HOME=/home/foreman

# RUN apk add \
#     alpine-sdk \
#     libffi-dev \
#     ruby-dev \
#     ruby-rake \
#     git \
#     postgresql12-dev \
#   git clone --depth=1 --branch 3.9.1 https://github.com/theforeman/foreman.git /tmp/app; \
#   rm -rf /tmp/app/.git; \
#   cp -r /tmp/app/* ${HOME}/; \
#   cd ${HOME}; 


# COPY extras/containers/entrypoint.sh /usr/bin/

# RUN chmod +x /usr/bin/entrypoint.sh

# ENTRYPOINT ["entrypoint.sh"]





# ############################################################33
# # OLD



# ARG RUBY_VERSION="2.7"
# ARG NODEJS_VERSION="14"
# ENV FOREMAN_FQDN=foreman.example.com
# ENV FOREMAN_DOMAIN=example.com

# RUN \
#   dnf upgrade -y && \
#   dnf module enable ruby:${RUBY_VERSION} nodejs:${NODEJS_VERSION} -y && \
#   dnf install -y postgresql-libs ruby{,gems} rubygem-{rake,bundler} npm nc hostname && \
#   dnf clean all

# ARG HOME=/home/foreman
# WORKDIR $HOME
# RUN groupadd -r foreman -f -g 0 && \
#     useradd -u 1001 -r -g foreman -d $HOME -s /sbin/nologin \
#     -c "Foreman Application User" foreman && \
#     chown -R 1001:0 $HOME && \
#     chmod -R g=u ${HOME}

# # Add a script to be executed every time the container starts.
# COPY extras/containers/entrypoint.sh /usr/bin/
# RUN chmod +x /usr/bin/entrypoint.sh
# ENTRYPOINT ["entrypoint.sh"]




# # Temp container that download gems/npms and compile assets etc
# FROM base as builder
# ENV RAILS_ENV=production
# ENV FOREMAN_APIPIE_LANGS=en
# ENV BUNDLER_SKIPPED_GROUPS="test development openid libvirt journald facter console"

# RUN \
#   dnf install -y redhat-rpm-config git-core \
#     gcc-c++ make bzip2 gettext tar \
#     libxml2-devel libcurl-devel ruby-devel \
#     postgresql-devel && \
#   dnf clean all

# ENV DATABASE_URL=nulldb://nohost

# ARG HOME=/home/foreman
# USER 1001
# WORKDIR $HOME
# COPY --chown=1001:0 . ${HOME}/
# RUN bundle config set --local without "${BUNDLER_SKIPPED_GROUPS}" && \
#   bundle config set --local clean true && \
#   bundle config set --local path vendor && \
#   bundle config set --local jobs 5 && \
#   bundle config set --local retry 3
# RUN bundle install && \
#   bundle binstubs --all && \
#   rm -rf vendor/ruby/*/cache/*.gem && \
#   find vendor/ruby/*/gems -name "*.c" -delete && \
#   find vendor/ruby/*/gems -name "*.o" -delete
# RUN \
#   make -C locale all-mo && \
#   mv -v db/schema.rb.nulldb db/schema.rb && \
#   bundle exec rake assets:clean assets:precompile

# RUN npm install --no-audit --no-optional && \
#   ./node_modules/webpack/bin/webpack.js --config config/webpack.config.js && \
# # cleanups
#   rm -rf public/webpack/stats.json ./node_modules vendor/ruby/*/cache vendor/ruby/*/gems/*/node_modules bundler.d/nulldb.rb db/schema.rb && \
#   bundle config without "${BUNDLER_SKIPPED_GROUPS} assets" && \
#   bundle install

# # USER 0
# # RUN chgrp -v -R 0 ${HOME} && \
# #     chmod -v -R g=u ${HOME}

# # USER 1001

# FROM base

# ARG HOME=/home/foreman
# ENV RAILS_ENV=production
# ENV RAILS_SERVE_STATIC_FILES=true
# ENV RAILS_LOG_TO_STDOUT=true

# USER 1001
# WORKDIR ${HOME}
# COPY --chown=1001:0 . ${HOME}/
# COPY --from=builder /usr/bin/entrypoint.sh /usr/bin/entrypoint.sh
# COPY --from=builder --chown=1001:0 ${HOME}/.bundle/config ${HOME}/.bundle/config
# COPY --from=builder --chown=1001:0 ${HOME}/Gemfile.lock ${HOME}/Gemfile.lock
# COPY --from=builder --chown=1001:0 ${HOME}/vendor/ruby ${HOME}/vendor/ruby
# COPY --from=builder --chown=1001:0 ${HOME}/public ${HOME}/public
# RUN rm -rf bundler.d/nulldb.rb bin/spring

# RUN date -u > BUILD_TIME

# # Start the main process.
# CMD bundle exec bin/rails server

# EXPOSE 3000/tcp
# EXPOSE 5910-5930/tcp
