FROM ruby:2.2.0

RUN apt-get update

RUN gem install fluentd

RUN mkdir /etc/fluent
RUN apt-get install -y libcurl4-gnutls-dev make

RUN /usr/local/bin/gem install fluent-plugin-elasticsearch
RUN /usr/local/bin/gem install fluent-plugin-docker-format
RUN /usr/local/bin/gem install fluent-plugin-kubernetes_metadata_filter

COPY fluent.conf /etc/fluent/

ENTRYPOINT export PUBLIC_IP=$(curl whatismyip.akamai.com --max-time 5) && \
           export PRIVATE_IP=$(curl http://169.254.169.254/latest/meta-data/local-ipv4 --max-time 5) && \
           export EC2_ID=$(curl http://169.254.169.254/latest/meta-data/instance-id --max-time 5) && \
           /usr/local/bundle/bin/fluentd -c /etc/fluent/fluent.conf
