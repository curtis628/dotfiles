export CC_WORKSPACE=~/workspace/cloudclient
cd $CC_WORKSPACE

echo "$CC_WORKSPACE : mvn clean install -rf :core -pl :dist -am -DskipTests"
mvn clean install -rf :core -pl :dist -am -DskipTests

cd dist/target

echo unzip cloudclient-*-dist.zip
unzip cloudclient-*-dist.zip

cd cloudclient-*
cp ~/tmp/CloudClient.properties .
#cp ~/tmp/vra7CloudClient.properties CloudClient.properties

echo bin/cloudclient.sh
bin/cloudclient.sh

