#!/bin/sh

#install zip/unzip tools in case don't exist
sudo dnf -y install zip unzip

# Tomcat Configuration Script

WAR_FILE="$1"
DbIP="$2"
PLUSER="$3"
PLPASS="$4"
TOMCAT_IP="$5"
ACCOUNT_SERVICE_IP="$6"


WAR_ROOT="WAR_ROOT"

INSTALL_PATH="/opt/tomcat"

TOMCAT_HOME=$(sudo find / -regex ".*tomcat.*/bin.*" -type d)
TOMCAT_HOME=$(dirname "$TOMCAT_HOME")
echo $TOMCAT_HOME

sudo echo $DbIP
sudo echo $PLPASS
sudo echo $PLUSER

echo $TOMCAT_IP
echo $ACCOUNT_SERVICE_IP

sudo echo $INSTALL_PATH
sudo unzip -o $WAR_FILE -d $WAR_ROOT
rm -f $WAR_FILE

sudo echo $CATALINA_HOME


sed -i "s/\([^\.]*\)\.hibernate\.db\.hbm2ddlAuto=.*/\1\.hibernate\.db\.hbm2ddlAuto=create/g" $WAR_ROOT/WEB-INF/classes/properties/internal_config_for_env.properties
sed -i "s/\([^\.]*\)\.hibernate\.db\.url\.host=.*/\1\.hibernate\.db\.url\.host=$DbIP/g" $WAR_ROOT/WEB-INF/classes/properties/internal_config_for_env.properties
sed -i "s/\([^\.]*\)\.hibernate\.db\.password=.*/\1\.hibernate\.db\.password=$PLPASS/g" $WAR_ROOT/WEB-INF/classes/properties/internal_config_for_env.properties
sed -i "s/\([^\.]*\)\.hibernate\.db\.login=.*/\1\.hibernate\.db\.login=$PLUSER/g" $WAR_ROOT/WEB-INF/classes/properties/internal_config_for_env.properties

sed -i "s/\([^\.]*\)\.\([^\.]*\)\.url\.host=.*/\1\.\2\.url\.host=$TOMCAT_IP/g" $WAR_ROOT/WEB-INF/classes/properties/services.properties
sed -i "s/account\.soapservice\.url\.host=.*/account\.soapservice\.url\.host=$ACCOUNT_SERVICE_IP/g" $WAR_ROOT/WEB-INF/classes/properties/services.properties
#for ROOT
sed -i "s/\([^\.]*\)\.\([^\.]*\)\.url\.host=.*/\1\.\2\.url\.host=$TOMCAT_IP/g" $WAR_ROOT/services.properties
sed -i "s/account\.soapservice\.url\.host=.*/account\.soapservice\.url\.host=$ACCOUNT_SERVICE_IP/g" $WAR_ROOT/services.properties

if [ "$TOMCAT_IP" != "$ACCOUNT_SERVICE_IP" ]; then
  sed -i "s/single\.machine\.deployment=.*/single\.machine\.deployment=false/g" $WAR_ROOT/WEB-INF/classes/properties/services.properties
  #for ROOT
  sed -i "s/single\.machine\.deployment=.*/single\.machine\.deployment=false/g" $WAR_ROOT/services.properties
fi

cd $WAR_ROOT
zip -r ../$WAR_FILE *
cd ..
rm -rf $WAR_ROOT
mv -f $WAR_FILE $TOMCAT_HOME/webapps

exit 0

