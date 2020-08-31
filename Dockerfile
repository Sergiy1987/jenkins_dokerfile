# Pull base image
FROM jenkins:latest
LABEL maintainer="Sergiy Slobodyanyk <nedved198725@gmail.com>"
USER root

# Add user to group
ARG USER=staging_user
ARG UID=999
ARG GID=998

# Update and upgrade all packages
RUN \
rm docker-java-home && \
apt-get autoremove -y python && \
apt-get update -y && \
apt-get -y upgrade 

# Update python
RUN \
#apt-get autoremove -y python && \
apt-get install -y python3

# Install main packages, fonts, dependencies
RUN apt-get install -y openjdk-8-jdk \
maven \
git \
xvfb \
libappindicator1 \ 
libappindicator3-1 \ 
libindicator7 \
fonts-liberation \ 
xdg-utils \
libxss1 \
libnss3 \
libxpm4 \
libxrender1 \
libgtk2.0-0 \
libgconf-2-4 \
gtk2-engines-pixbuf \
xfonts-cyrillic \
xfonts-100dpi \
xfonts-75dpi \
xfonts-base \
xfonts-scalable
 
ENV DISPLAY=:99
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV JAVA_VERSION=8u252
ENV JAVA_DEBIAN_VERSION=8u252-b09-1~18.04-b09
ENV CA_CERTIFICATES_JAVA_VERSION=20190931+nmu1
ENV GIT_HOME=/usr/bin/git
ENV MAVEN_HOME=/usr/share/maven
ENV XVFB=/usr/bin

# Install Google Chrome
RUN \
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
echo "deb http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list && \
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
dpkg -i google-chrome*.deb && \
apt --fix-broken install && \
rm google-chrome-stable_current_amd64.deb 

ENV GOOGLE-CHROME=/usr/bin/google-chrome

# Update jenkins
RUN \
wget https://updates.jenkins-ci.org/latest/jenkins.war && \
mv jenkins.war /usr/share/jenkins/

ENV JENKINS_HOME=/var/jenkins_home
ENV JENKINS_VERSION=2.211
ENV JENKINS_SLAVE_AGENT_PORT=50000

# Install Allure commandline
RUN \
wget https://repo.maven.apache.org/maven2/io/qameta/allure/allure-commandline/2.13.5/allure-commandline-2.13.5.zip && \
unzip allure-commandline-2.13.5.zip && \
mv allure-2.13.5 /usr/bin/allure-2.13.5 && \
rm allure-commandline-2.13.5.zip && \
apt-get clean

ENV ALLURE_COMMAND_LINE=/usr/bin/allure-2.13.5

# Let's start with some basic stuff.
#RUN apt-get update -qq && apt-get install -qqy \
#    apt-transport-https \
#    ca-certificates \
#    curl \
#    lxc \
#    iptables

# Install Docker from Docker Inc. repositories.
#RUN curl -sSL https://get.docker.com/ | sh

# Using unencrypted password/ specifying password
#RUN useradd -m ${USER} --uid=${UID} && echo "${USER}:${PW}" | chpasswd

# Setup default user, when enter docker container

RUN groupadd --system ${GID}

RUN useradd -s /sbin/nologin --system -u ${UID} ${USER}

RUN id ${USER}

WORKDIR /home/${USER}

RUN chown -R ${UID}:${UID} /home/${USER}

#RUN usermod -aG docker root

# Define volume directory
VOLUME ["/var/jenkins_home"]
VOLUME ["/home/${USER}/Downloads/"]
VOLUME ["/var/lib/docker"]

# Define working directory
WORKDIR /var/jenkins_home

EXPOSE 34579 50000 465
USER ${USER}
