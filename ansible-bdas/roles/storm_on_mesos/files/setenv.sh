#export STORM_HOME="/opt/storm"
#export PATH=$PATH:$STORM_HOME/bin

echo "STORM_HOME=/opt/storm" >> etc/environment
#sed -i 's/PATH=\"/PATH=\"$STORM_HOME/bin/g' /etc/environment
