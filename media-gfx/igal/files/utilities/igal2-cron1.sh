#
SCRIPTPATH="/usr/local/bin";
# echo "Examing $1";
FOUND=`find "$1/" -iname "*.jpg" -maxdepth 1`;
if [ \( ! -f "$1/index.html" \) -a -n "$FOUND" ];
then 
   echo "--> $1: Index missing... calling igal2...";
   $SCRIPTPATH/igal2.sh "$1";
fi;
