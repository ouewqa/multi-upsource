FROM esycat/java:oracle-8

MAINTAINER "yuyunjian" <6202551@qq.com>

#####################
ENV UPSOURCE_CODE_FILE upsource-3.0.4396.zip
#####################


USER root
ENV JAVA_HOME /usr/bin/java
RUN sed -i 's/http:\/\/archive.ubuntu.com\/ubuntu\//http:\/\/mirrors.163.com\/ubuntu\//g' /etc/apt/sources.list

COPY $UPSOURCE_CODE_FILE /opt

RUN mkdir -p /home/upsource \
	&& groupadd -g 999 upsource \
	&& useradd -u 999 -g upsource -d /home/upsource upsource \
	&& chown -R upsource:upsource /home/upsource

WORKDIR /opt

RUN unzip $UPSOURCE_CODE_FILE \
	&& mkdir Upsource \
	&& cp -a upsource*/* Upsource/ \
	&& rm -rf $UPSOURCE_CODE_FILE \
	&& rm -rf upsource* \
	&& chown -R upsource:upsource Upsource


USER upsource
WORKDIR /opt/Upsource
VOLUME ["/opt/Upsource/conf","/opt/Upsource/data","/opt/Upsource/logs","/opt/Upsource/backups"]
CMD ["bin/upsource.sh", "run"]
