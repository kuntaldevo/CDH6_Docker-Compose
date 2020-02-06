FROM centos:6.6

# EPEL
RUN rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm && \
    rm -f epel-release-6-8.noarch.rpm && \
    yum install -y krb5-server \
        krb5-libs \
        krb5-auth-dialog \
        krb5-workstation \
        vim && \
    yum clean all && \
    rm -Rf /var/cache/yum

EXPOSE 88 749

ADD ./config.sh /config.sh
RUN chmod 755 /config.sh

ENTRYPOINT ["/config.sh"]