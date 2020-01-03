# Pull base image
FROM jenkins:latest
USER root

# Update and upgrade all packages
RUN \
rm docker-java-home && \
apt-get update -y && \
apt-get -y upgrade 

# Install main packages, fonts, dependencies
RUN apt-get install -y maven \
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
ENV JAVA_VERSION=8u232
ENV JAVA_DEBIAN_VERSION=8u232-b09-1~deb9u1-b09
ENV CA_CERTIFICATES_JAVA_VERSION=20190931+nmu1
ENV GIT_HOME=/usr/bin/git
ENV MAVEN_HOME=/usr/share/maven
ENV XVFB=/usr/bin

# Install Firefox
RUN \
wget https://ftp.mozilla.org/pub/firefox/releases/72.0b9/linux-x86_64/en-US/firefox-72.0b9.tar.bz2 && \
tar xvf firefox-72.0b9.tar.bz2 && \
mv firefox/ /usr/lib/firefox && \
ln -s /usr/lib/firefox /usr/bin/firefox && \
rm firefox-72.0b9.tar.bz2

ENV FIREFOX=/usr/bin/firefox
ENV PATH=$PATH:$FIREFOX

# Install Google Chrome
RUN \
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
echo "deb http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list && \
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
dpkg -i google-chrome*.deb && \
apt --fix-broken install && \
rm google-chrome-stable_current_amd64.deb 

ENV GOOGLE-CHROME=/usr/bin/google-chrome

# Install Chrome Driver
RUN \
wget https://chromedriver.storage.googleapis.com/79.0.3945.36/chromedriver_linux64.zip && \
unzip chromedriver_linux64.zip && \
mv chromedriver /usr/bin/chromedriver && \
chown root:root /usr/bin/chromedriver && \
chmod +x /usr/bin/chromedriver && \
rm chromedriver_linux64.zip

ENV CHROME_DRIVER=/usr/bin/chromedriver

# Update jenkins
RUN \
wget https://updates.jenkins-ci.org/latest/jenkins.war && \
mv jenkins.war /usr/share/jenkins/

ENV JENKINS_HOME=/var/jenkins_home
ENV JENKINS_VERSION=2.211
ENV JENKINS_SLAVE_AGENT_PORT=50000

# Install Allure commandline
RUN \
wget http://repo.maven.apache.org/maven2/io/qameta/allure/allure-commandline/2.13.1/allure-commandline-2.13.1.zip && \
unzip allure-commandline-2.13.1.zip && \
mv allure-2.13.1 /usr/bin/allure-2.13.1 && \
rm allure-commandline-2.13.1.zip

ENV ALLURE_COMMAND_LINE=/usr/bin/allure-2.13.1


# Define volume directory
VOLUME ["/var/jenkins_home"] 

# Define working directory
WORKDIR /var/jenkins_home

EXPOSE 8080 50000 
USER jenkins
