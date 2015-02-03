#!/usr/bin/env bash

apt-get update
apt-get upgrade -y

apt-get install -y build-essential openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion pkg-config postgresql postgresql-contrib

mkdir -p /root/src

if [ ! -d /root/src/chruby-0.3.9 ]; then
  cd /root/src
  wget -O chruby-0.3.9.tar.gz https://github.com/postmodern/chruby/archive/v0.3.9.tar.gz
  tar -xzvf chruby-0.3.9.tar.gz
  cd chruby-0.3.9/
  make install
  echo '. /usr/local/share/chruby/chruby.sh' >> ~/.bashrc
  echo '. /usr/local/share/chruby/chruby.sh' >> /home/vagrant/.bashrc
  source ~/.bashrc
fi

if [ ! -d /root/src/ruby-install-0.5.0 ]; then
  cd /root/src
  wget -O ruby-install-0.5.0.tar.gz https://github.com/postmodern/ruby-install/archive/v0.5.0.tar.gz
  tar -xzvf ruby-install-0.5.0.tar.gz
  cd ruby-install-0.5.0/
  make install
fi

if [ ! -d /opt/rubies/ruby-2.2.0 ]; then
  ruby-install ruby 2.2.0
  echo 'chruby 2.2.0' >> ~/.bashrc
  echo 'chruby 2.2.0' >> /home/vagrant/.bashrc
  chruby 2.2.0
fi

if [ `cat /etc/postgresql/9.3/main/pg_hba.conf | grep "postgres.*trust" | wc -l` == 0 ]; then
  cd /etc/postgresql/9.3/main
  echo "--- pg_hba2.conf        2015-02-03 09:05:04.846634472 +0000
  +++ pg_hba.conf 2015-02-03 08:53:24.858597659 +0000
  @@ -82,7 +82,7 @@
   # maintenance (custom daily cronjobs, replication, and similar tasks).
   #
   # Database administrative login by Unix domain socket
  -local   all             postgres                                peer
  +local   all             postgres                                trust

   # TYPE  DATABASE        USER            ADDRESS                 METHOD
  " | patch -N
  cd
fi

if [ `psql -U postgres -c '\du' | grep root | wc -l` == 0 ]; then
  createuser -U postgres -d -e -E -l -r -s root
  createuser -U postgres -d -e -E -l -r -s vagrant
fi
if [ `psql -U vagrant -l | grep stripe_receipts_ | wc -l` != 2 ]; then
  createdb -U vagrant stripe_receipts_test
  createdb -U vagrant stripe_receipts_development
fi

gem install bundler
gem install shotgun

cd /vagrant
bundle install
psql stripe_receipts_development < schema.sql


