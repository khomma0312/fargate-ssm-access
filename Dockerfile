FROM httpd:latest
RUN apt-get update && apt-get install -y wget \
&& wget https://s3.ap-northeast-1.amazonaws.com/amazon-ssm-ap-northeast-1/latest/debian_amd64/amazon-ssm-agent.deb -O /tmp/amazon-ssm-agent.deb \
&& dpkg -i /tmp/amazon-ssm-agent.deb \
&& cp /etc/amazon/ssm/seelog.xml.template /etc/amazon/ssm/seelog.xml
COPY ./run.sh /run.sh
CMD [ "bash", "/run.sh" ]