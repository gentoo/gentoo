#
SCRIPTPATH="/usr/local/bin";
find $1 -type d -xdev ! -name "\.igal" -exec $SCRIPTPATH/igal2-cron1.sh "{}" \;
