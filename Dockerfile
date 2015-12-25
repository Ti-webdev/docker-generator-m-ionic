FROM beevelop/android-nodejs:v4

ENV CORDOVA_VERSION 5.4.1
ENV IONIC_CLI_VERSION 1.7.12
ENV MIONIC_VERSION 1.5.0
ENV NODE_MODULES_DIR node_modules
ENV BOWER_CLIENT_ID 896698526080
ENV BOWER_DIR app/bower_components

#RUN echo y   | android update sdk -a -u -t extra-google-google_play_services,extra-google-m2repository,extra-android-support
RUN echo yes | android update sdk -u -t tool,platform-tool,extra-android-m2repository,extra-android-support,extra-google-m2repository,extra-google-google_play_services

RUN apt-get update -y && \
  apt-get install -y \
     git \
     python \
     unzip \
     build-essential \
     openssh-client && \
  type git && \
  type python && \
  type unzip && \
  type make && \
  type ssh-keyscan && \
  apt-get clean

RUN npm install --global \
  bower \
  generator-m-ionic@${MIONIC_VERSION} \
  gulp \
  ionic@$IONIC_CLI_VERSION \
  yo \
  cordova@${CORDOVA_VERSION}

EXPOSE 3000
EXPOSE 3001

COPY docker-entrypoint-development.sh /
COPY build-release.sh /

VOLUME /appm

RUN useradd -ms /bin/bash app
RUN chown -R app /opt

USER app
WORKDIR /home/app
RUN mkdir -p .config/configstore
RUN echo '{"clientId": '$BOWER_CLIENT_ID',"optOut": true}' > .config/configstore/insight-yo.json
RUN echo 'clientId: '$BOWER_CLIENT_ID >> .config/configstore/insight-bower.yml
RUN echo 'optOut: true' >> .config/configstore/insight-bower.yml

# github known_hosts
# Add github.com to known_hosts
RUN mkdir -p .ssh && \
  ssh-keyscan -H github.com >> .ssh/known_hosts

RUN echo 'umask 000' >> .bashrc

WORKDIR /appm

ENTRYPOINT ["/docker-entrypoint-development.sh"]
CMD ["gulp", "watch", "--no-open"]
