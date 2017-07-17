

FROM ubuntu:14.04

MAINTAINER James McVicar 

RUN export DEBIAN_FRONTEND=noninteractive \
  # The URL to download the MQ installer from in tar.gz format
  && MQ_URL=http://public.dhe.ibm.com/ibmdl/export/pub/software/websphere/messaging/mqadv/mqadv_dev80_linux_x86-64.tar.gz \


# The MQ packages to install
  && MQ_PACKAGES="MQSeriesRuntime-*.rpm MQSeriesServer-*.rpm MQSeriesMsg*.rpm MQSeriesJava*.rpm MQSeriesJRE*.rpm MQSeriesGSKit*.rpm" \


# Optional: Update the command prompt
  && echo "mq:8.0" > /etc/debian_chroot \


# Install additional packages required by this install process and the runtime scripts
  && apt-get update -y \
  && apt-get install -y \
    bash \
    bc \
    curl \
    rpm \
    tar \

# Download and extract the MQ installation files
  && mkdir -p /tmp/mq \
  && cd /tmp/mq \
  && curl -LO $MQ_URL \
  && tar -zxvf ./*.tar.gz \



# Recommended: Create the mqm user ID with a fixed UID and group, so that the file permissions work between different images
  && groupadd --gid 1000 mqm \
  && groupadd --gid 2000 mqbrkrs \
  && useradd --uid 2000 --gid mqbrkrs --home /opt/mbroker mbroker \ 
  && useradd --uid 1000 --gid mqm --home-dir /var/mqm mqm \
  && usermod -G mqm,mqbrkrs,root mbroker \
  && usermod -G mqm,mqbrkrs root \
  && cd /tmp/mq/MQServer \


 

# Accept the MQ license
  && ./mqlicense.sh -text_only -accept \
  # Install MQ using the RPM packages
  && rpm -ivh --force-debian $MQ_PACKAGES \
  # Recommended: Set the default MQ installation (makes the MQ commands available on the PATH)
  && /opt/mqm/bin/setmqinst -p /opt/mqm -i \
  # Clean up all the downloaded files
  && rm -rf /tmp/mq

COPY *.sh /usr/local/bin/
COPY *.mqsc /etc/mqm/

# Support the latest functional cmdlevel by default
ENV MQ_QMGR_CMDLEVEL=802

RUN chmod +x /usr/local/bin/*.sh


# Always put the MQ data directory is in a Docker volume
VOLUME /var/mqm



# Install IIB V10 Developer edition
RUN mkdir /opt/ibm && \
    curl http://public.dhe.ibm.com/ibmdl/export/pub/software/websphere/integration/10.0.0.4-IIB-LINUX64-DEVELOPER.tar.gz \
    | tar zx --exclude iib-10.0.0.4/tools --directory /opt/ibm && \
    /opt/ibm/iib-10.0.0.4/iib make registry global accept license silently

# Configure system
COPY kernel_settings.sh /tmp/
RUN echo "IIB_10:" > /etc/debian_chroot  && \
    touch /var/log/syslog && \
    chown syslog:adm /var/log/syslog && \
    chmod +x /tmp/kernel_settings.sh;sync && \
    /tmp/kernel_settings.sh

# Create user to run as
RUN useradd --create-home --home-dir /home/iibuser -G mqbrkrs,sudo,mqm iibuser && \
    sed -e 's/^%sudo	.*/%sudo	ALL=NOPASSWD:ALL/g' -i /etc/sudoers

# Copy in script files
COPY iib_manage.sh /usr/local/bin/
COPY iib-license-check.sh /usr/local/bin/
COPY iib_env.sh /usr/local/bin/
RUN chmod +rx /usr/local/bin/*.sh

# Set BASH_ENV to source mqsiprofile when using docker exec bash -c
ENV BASH_ENV=/usr/local/bin/iib_env.sh

# Expose default admin port and http port and MQ port default
EXPOSE 4414 7800 1414



# Set entrypoint to run management script
ENTRYPOINT ["iib_manage.sh"]
