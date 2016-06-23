# Pull base image
FROM centos

RUN yum update -y
RUN yum upgrade -y
RUN yum clean -y all

# Install Tools
RUN yum install -y vim wget net-tools
RUN yum install -y ruby
RUN yum install -y git

# Java install
RUN yum install -y java-1.7.0-openjdk
ENV JAVA_HOME /usr/java/latest

# Install Kibana
ADD kibana.repo /etc/yum.repos.d/kibana.repo
RUN yum install -y kibana
RUN /opt/kibana/bin/kibana plugin --install elasticsearch/marvel/latest
RUN /opt/kibana/bin/kibana plugin --install elastic/sense
ADD kibana.yml /opt/kibana/conf/kibana.yml

CMD /opt/kibana/bin/kibana serve --config /opt/kibana/conf/kibana.yml

# Expose ports.
EXPOSE 5601
