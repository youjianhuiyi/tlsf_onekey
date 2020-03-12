FROM centos:6.8

WORKDIR /home/tlbb

RUN yum clean all && yum update -y && yum check

RUN yum install -y libstdc++.i686 unixODBC.i686
RUN ln -s /usr/lib/libodbc.so /usr/lib/libodbc.so.1
ADD ./config/billing.tar.gz /home/
ADD ./config/tlbb.tar.gz /home/
ADD ./config/ini.tar.gz /home/tlbb/Server/Config/
COPY ./config/odbc.ini /etc/odbc.ini
COPY ./config/run.sh /home/tlbb/run.sh
RUN curl -L http://mirrors.aliyun.com/centos/6/os/i386/Packages/mysql-connector-odbc-5.1.5r1144-7.el6.i686.rpm -o /tmp/mysql-connector-odbc-5.1.5r1144-7.el6.i686.rpm && \
    yum localinstall -y /tmp/mysql-connector-odbc-5.1.5r1144-7.el6.i686.rpm && \
    rm -f /tmp/mysql-connector-odbc-5.1.5r1144-7.el6.i686.rpm && \
    chown -R root:root /home && chmod -R 777 /home

CMD tail -f /dev/null