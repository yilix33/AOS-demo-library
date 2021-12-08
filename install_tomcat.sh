export https_proxy=http://proxy.eswdc.net:8088/
curl -O https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.39/bin/apache-tomcat-9.0.39.tar.gz
#wget https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.39/bin/apache-tomcat-9.0.39.tar.gz
mkdir /opt/tomcat
tar xzvf apache-tomcat-9.0.39.tar.gz -C /opt/tomcat/
rm -rf apache-tomcat-9.0.39.tar.gz
sudo sh /opt/tomcat/apache-tomcat-9.0.39/bin/startup.sh

