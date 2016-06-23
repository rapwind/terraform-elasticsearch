# Pull base image
FROM centos

ENV ES_PKG_NAME elasticsearch-2.3.2

RUN yum update -y
RUN yum upgrade -y
RUN yum clean -y all

# Install Tools
RUN yum install -y vim wget net-tools
RUN yum install -y ruby
RUN yum install -y git

# Java install
RUN yum install -y java-1.7.0-openjdk

# Elastic Search install
ENV JAVA_HOME /usr/java/latest
RUN \
  cd / && \
  wget https://download.elasticsearch.org/elasticsearch/elasticsearch/$ES_PKG_NAME.tar.gz && \
  tar xvzf $ES_PKG_NAME.tar.gz && \
  rm -f $ES_PKG_NAME.tar.gz && \
  mv /$ES_PKG_NAME /elasticsearch

# Define mountable directories
VOLUME ["/elasticsearch/data"]

# Elastic Plugin Install
RUN /elasticsearch/bin/plugin install org.codelibs/elasticsearch-analysis-kuromoji-neologd/2.3.0
RUN /elasticsearch/bin/plugin install cloud-aws
RUN /elasticsearch/bin/plugin install license
RUN /elasticsearch/bin/plugin install marvel-agent
RUN /elasticsearch/bin/plugin install lang-javascript

# Elastic Search Config
ADD elasticsearch.yml /elasticsearch/config/elasticsearch.yml
ADD calculate-score.js /elasticsearch/config/scripts/calculate-score.js

# Define working directory
WORKDIR /elasticsearch

CMD /elasticsearch/bin/elasticsearch -Des.insecure.allow.root=true

# Expose ports.
#   - 9200: HTTP
#   - 9300: transport
EXPOSE 9200
EXPOSE 9300
