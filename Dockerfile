# phpenv in image.
# --------------------------
# envelonment
# --------------------------
FROM phusion/baseimage:0.9.15
MAINTAINER Ryoh Kawai <kawairyoh@gmail.com>

# Set correct environment variables.
ENV HOME /root

# Regenerate SSH host keys. baseimage-docker does not contain any, so you
# have to do that yourself. You may also comment out this instruction; the
# init system will auto-generate one during boot.
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# --------------------------
# first setup
# --------------------------
# initial setup
ENV DEBIAN_FRONTEND noninteractive
RUN dpkg-divert --local --rename --add /sbin/initctl && \
    ln -sf /bin/true /sbin/initctl

#------------------------------------------------
# Change apt repository site and update
#------------------------------------------------
RUN sed -i 's#http://archive.ubuntu.com/ubuntu/#http://jp.archive.ubuntu.com/ubuntu/#g' /etc/apt/sources.list && \
    apt-get update

#------------------------------------------------
# Install Base Software
#------------------------------------------------
RUN apt-get install -y sudo apt-utils zsh ack-grep unzip tar gzip bzip2 && \
    chmod +s /usr/bin/sudo

#------------------------------------------------
# Install Dev tools
#------------------------------------------------
RUN apt-get install -y build-essential git-core bison

#------------------------------------------------
# Install phpenv libraries
#------------------------------------------------
RUN apt-get install -y libxml2-dev libssl-dev \
    libcurl4-gnutls-dev libjpeg-dev libpng12-dev libmcrypt-dev \
    libreadline-dev libtidy-dev libxslt1-dev autoconf \
    re2c libmysqlclient-dev libsqlite3-dev libbz2-dev \
    php5-cli

#------------------------------------------------
# Install DB Servers
#------------------------------------------------
# MariaDB 10.1
RUN apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db && \
    add-apt-repository 'deb http://ftp.yz.yamagata-u.ac.jp/pub/dbms/mariadb/repo/10.1/ubuntu trusty main'
RUN apt-get update && apt-get install -y mariadb-server sqlite3

#------------------------------------------------
# composer
#------------------------------------------------
RUN cd /tmp && \
    curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer && chmod 755 /usr/local/bin/composer

#------------------------------------------------
# Cache clean
#------------------------------------------------
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#------------------------------------------------
# Add php user
#------------------------------------------------
RUN adduser --disabled-password --gecos 'PHP' --home /home/php php && \
    echo 'php:php' | chpasswd && \
    echo 'php ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers.d/php && \
    locale-gen ja_JP ja_JP.UTF-8 && dpkg-reconfigure locales && \
    echo 'LANG=ja_JP.UTF-8' > /etc/default/locale
USER php
WORKDIR /home/php
ENV HOME /home/php

#------------------------------------------------
# phpenv
#------------------------------------------------
RUN curl https://raw.githubusercontent.com/CHH/phpenv/master/bin/phpenv-install.sh | bash
RUN echo 'export LANG=ja_JP.UTF-8' >> /home/php/.bashrc && \
    echo 'export LC_ALL=ja_JP.UTF-8' >> /home/php/.bashrc && \
    echo 'export PATH="${HOME}/.composer/vendor/bin:${HOME}/.phpenv/bin:${HOME}/bin:$PATH"' >> /home/php/.bashrc && \
    echo 'eval "$(phpenv init -)"' >> /home/php/.bashrc
RUN mkdir /home/php/.phpenv/plugins && \
    cd /home/php/.phpenv/plugins && \
    git clone https://github.com/CHH/php-build.git
ENV PATH /home/php/.phpenv/shims:/home/php/.phpenv/bin:$PATH

#------------------------------------------------
# php install
#------------------------------------------------
ADD ./installver /home/php/installver
RUN for ver in `cat ./installver`; do phpenv install $ver; done
RUN phpenv global `head -n 1 installver`

#------------------------------------------------
# phpdict
#------------------------------------------------
RUN mkdir -p ~/.vim/dict
RUN php -r '$f=get_defined_functions();echo join("\n", $f["internal"]);'|sort > ~/.vim/dict/php.dict

#------------------------------------------------
# vimrc
#------------------------------------------------
ADD .vimrc /home/php/.vimrc
RUN mkdir -p .vim/bundle && \
    curl https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh | sh && \
    cd ~/.vim/bundle/neobundle.vim/bin/ && \
    ./neoinstall && \
    vim -n -u ~/.vimrc -c "PhpMakeDict ja" -c "qall!" -V1 -U NONE -i NONE -e -s; echo ''

#------------------------------------------------
# zshrc
#------------------------------------------------
ADD .zshrc /home/php/.zshrc
