#!/bin/sh

#remnants
rm -rf /var/lib/pgsql

# AOS Db creation script
PLUSER="postgres"
PLPASS="admin"
VERSION="9.6"
echo $PLUSER
sudo yum install postgresql96 postgresql96-server postgresql96-contrib postgresql96-libs -y
sudo /usr/pgsql-9.6/bin/postgresql96-setup initdb

echo "configure postgresql.conf"

sudo sed -i 's/#listen_addresses/listen_addresses/g' /var/lib/pgsql/$VERSION/data/postgresql.conf
sudo sed -i 's/localhost/*/g' /var/lib/pgsql/$VERSION/data/postgresql.conf

echo "configure pg_hba.conf"

echo "host    all             all             0.0.0.0/0               md5" >> /var/lib/pgsql/$VERSION/data/pg_hba.conf

echo "restart postgres service"

sudo service postgresql-9.6 restart

echo "Changing postgres password"
su - postgres -c "psql -U '$PLUSER' -d postgres -c \"alter user postgres with password '$PLPASS';\""

echo "Creating DBs"
sudo -u postgres psql <<EOF
\x
create database adv_account;
create database adv_catalog;
create database adv_order;
EOF

exit

