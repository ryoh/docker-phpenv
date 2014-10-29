# phpenv in image.
# --------------------------
# envelonment
# --------------------------
FROM ubuntu:trusty
MAINTAINER ryoh

# first setup
#------------------------------------------------
# NTP server change
#------------------------------------------------
RUN sed -i 's/"ntp.ubuntu.com"/"ntp.nict.jp"/g' /etc/default/ntpdate

#------------------------------------------------
# Change apt repository site and update
#------------------------------------------------
RUN sed -i.bak 's;http://archive.ubuntu.com/ubuntu/;http://jp.archive.ubuntu.com/ubuntu/;g' /etc/apt/sources.list
RUN apt-get update && apt-get upgrade -y --fix-missing

#------------------------------------------------
# Install Base Software
#------------------------------------------------
RUN apt-get install -y passwd sudo apt-utils openssh-server ssh zsh language-pack-ja \
    tmux python-setuptools python-software-properties unzip p7zip-full tree grep ack-grep

#------------------------------------------------
# Install Dev tools
#------------------------------------------------
RUN apt-get install -y build-essential git vim-nox curl wget w3m mercurial subversion

#------------------------------------------------
# Install phpenv libraries
#------------------------------------------------
RUN apt-get install -y libxml2-dev libssl-dev \
    libcurl4-gnutls-dev libjpeg-dev libpng12-dev libmcrypt-dev \
    libreadline-dev libtidy-dev libxslt1-dev autoconf \
    re2c bison libmysqlclient-dev libsqlite3-dev libbz2-dev libpq-dev

#------------------------------------------------
# Install DB Servers
#------------------------------------------------
RUN apt-get install -y mysql-server sqlite3 postgresql

#------------------------------------------------
# nginx
#------------------------------------------------
RUN apt-get install -y nginx
EXPOSE 80

#------------------------------------------------
# Add php user
#------------------------------------------------
RUN adduser --disabled-password --gecos 'PHP' --home /home/php --shell /bin/zsh php && \
    echo 'php:php' | chpasswd && \
    echo 'php ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN locale-gen en_US en_US.UTF-8 && dpkg-reconfigure locales
RUN locale-gen ja_JP ja_JP.UTF-8 && dpkg-reconfigure locales
RUN echo 'LANG=ja_JP.UTF-8' > /etc/default/locale
USER php
WORKDIR /home/php
ENV HOME /home/php
ADD .vimrc /home/php/.vimrc
RUN mkdir -p .vim/bundle
RUN curl https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh | sh
RUN cd ~/.vim/bundle/neobundle.vim/bin/ && ./neoinstall

#------------------------------------------------
# phpenv
#------------------------------------------------
RUN curl https://raw.githubusercontent.com/CHH/phpenv/master/bin/phpenv-install.sh | bash
RUN echo 'export LANG=ja_JP.UTF-8' >> /home/php/.bashrc && \
    echo 'export LC_ALL=ja_JP.UTF-8' >> /home/php/.bashrc && \
    echo 'export PATH="/home/php/.phpenv/bin:$PATH"' >> /home/php/.bashrc && \
    echo 'eval "$(phpenv init -)"' >> /home/php/.bashrc
RUN mkdir /home/php/.phpenv/plugins; \
    cd /home/php/.phpenv/plugins; \
    git clone https://github.com/CHH/php-build.git

#------------------------------------------------
# phpbuild
#------------------------------------------------
RUN curl -o /home/php/.phpenv/plugins/php-build/share/php-build/after-install.d/phpunit \
    https://raw.githubusercontent.com/CHH/php-build-plugin-phpunit/master/share/php-build/after-install.d/phpunit
RUN chmod +x /home/php/.phpenv/plugins/php-build/share/php-build/after-install.d/phpunit

ENV PATH /home/php/.phpenv/shims:/home/php/.phpenv/bin:$PATH

#------------------------------------------------
# zshrc
#------------------------------------------------
ADD .zshrc /home/php/.zshrc
