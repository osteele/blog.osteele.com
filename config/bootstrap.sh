#!/usr/bin/env bash

apt-get update
apt-get install -y apache2
a2enmod rewrite
a2enmod actions

rm /etc/apache2/sites-enabled/000-default
ln -fs /vagrant/config/blog.osteele.com.conf /etc/apache2/sites-enabled/
ln -fs /vagrant/_site /var/www/blog.osteele.com

service apache2 restart
