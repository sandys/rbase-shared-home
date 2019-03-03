FROM rocker/r-base
RUN apt-get update
RUN apt-get install -y libpq-dev libxml2-dev openssl libssl-dev libcurl4-openssl-dev

## gnupg is needed to add new key
RUN apt-get update && apt-get install -y gnupg2

## Install Java 
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" \
      | tee /etc/apt/sources.list.d/webupd8team-java.list \
    &&  echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" \
      | tee -a /etc/apt/sources.list.d/webupd8team-java.list \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886 \
    && echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" \
        | /usr/bin/debconf-set-selections \
    && apt-get update \
    && apt-get install -y libpq-dev oracle-java8-installer \
    && update-alternatives --display java \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean \
    && R CMD javareconf

## make sure Java can be found in rApache and other daemons not looking in R ldpaths
RUN echo "/usr/lib/jvm/java-8-oracle/jre/lib/amd64/server/" > /etc/ld.so.conf.d/rJava.conf
RUN /sbin/ldconfig

## Install rJava package
RUN install2.r --error rJava \
&& rm -rf /tmp/downloaded_packages/ /tmp/*.rds

RUN apt-get update && apt-get -y --no-install-recommends install \
    ca-certificates \
    curl

#RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4
RUN gpg --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4
RUN curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.4/gosu-$(dpkg --print-architecture)" \
    && curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.4/gosu-$(dpkg --print-architecture).asc" \
    && gpg --verify /usr/local/bin/gosu.asc \
    && rm /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod 755 /usr/local/bin/entrypoint.sh
USER root

RUN Rscript -e "install.packages('DBI'); \ 
install.packages('dbplyr'); \ 
install.packages('DescTools'); \ 
install.packages('dplyr'); \ 
install.packages('ggplot2'); \ 
install.packages('googlesheets'); \ 
install.packages('gtools'); \ 
install.packages('httpuv'); \ 
install.packages('knitr'); \ 
install.packages('lubridate'); \ 
install.packages('mailR'); \ 
install.packages('markdown'); \ 
install.packages('quantmod'); \ 
install.packages('readr'); \ 
install.packages('reshape2'); \ 
install.packages('RForcecom'); \ 
install.packages('RODBC'); \ 
install.packages('RPostgreSQL'); \ 
install.packages('sqldf'); \ 
install.packages('stringi'); \ 
install.packages('tidyr'); \ 
install.packages('timeDate'); \ 
install.packages('tvm'); \ 
install.packages('urltools'); \ 
install.packages('uuid'); \ 
install.packages('xtable');"


RUN Rscript -e "install.packages('huxtable'); \ 
install.packages('httpuvnder'); \ 
install.packages('kableExtra');"
 
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]


 

