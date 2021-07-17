#
# Docker Bionic image to build Yocto Dunfell
#
FROM ubuntu:18.04
MAINTAINER Gokulnath Avanashilingam <Gokulnath.Avanashilingam@in.bosch.com>

# Keep the dependency list as short as reasonable
RUN apt-get update && \
	apt-get -y upgrade && \
	apt-get -y install gawk wget git-core diffstat \
		unzip texinfo gcc-multilib build-essential \
		chrpath socat cpio python3 python3-pip python3-pexpect \
		xz-utils debianutils iputils-ping python3-git \
		python3-jinja2 libegl1-mesa libsdl1.2-dev \
		pylint3 xterm python3-subunit mesa-common-dev 

# Set up locales
RUN apt-get -y install locales apt-utils sudo && dpkg-reconfigure locales && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8

# Set the locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
	
# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Replace dash with bash
RUN rm /bin/sh && ln -s bash /bin/sh

# User management
# ===== create user/setup environment =====
# Replace 1000 with your user/group id
RUN export uid=108 gid=113 user=azuredevel && \
    mkdir -p /home/${user} && \
    echo "${user}:x:${uid}:${gid}:${user},,,:/home/${user}:/bin/bash" >> /etc/passwd && \
    echo "${user}:x:${uid}:" >> /etc/group && \
    echo "${user} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${user} && \
    chmod 0440 /etc/sudoers.d/${user} && \
    chown ${uid}:${gid} -R /home/${user}

RUN git config --global color.ui false

# Install repo
ADD https://commondatastorage.googleapis.com/git-repo-downloads/repo /usr/local/bin/
RUN chmod 755 /usr/local/bin/*

ENV HOME /home/${user}
ENV USER ${user}
USER ${user}
WORKDIR /home/${user}


