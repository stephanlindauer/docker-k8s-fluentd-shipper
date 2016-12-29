FROM ruby:2.2.0

RUN apt-get update

RUN gem install fluentd

RUN mkdir /etc/fluent
RUN apt-get install -y libcurl4-gnutls-dev make

RUN /usr/local/bin/gem install fluent-plugin-elasticsearch
RUN /usr/local/bin/gem install fluent-plugin-docker-format
RUN /usr/local/bin/gem install fluent-plugin-kubernetes_metadata_filter

COPY fluent.conf /etc/fluent/

ENTRYPOINT /usr/local/bundle/bin/fluentd -c /etc/fluent/fluent.conf
