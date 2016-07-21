<?php
################################################################################
##                    OpenWebStats Version 1.0                                ##
##                                                                            ##
##        (c)2005 mathews_dm - <Davidmathews@open-creations.com>              ##
##                                                                            ##
################################################################################
## Please read the README!                                                    ##
################################################################################

##########################################
## Define Globals for OpenWebStats      ##
##########################################
global $openstats_web_dir, $databasename;

if (!defined("logformat_combined"))
{
	define("logformat_combined", "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"",  TRUE);
	define("logformat_combined_vhost", "%v %h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"",  TRUE);
	define("logformat_common"  , "%h %l %u %t \"%r\" %>s %b",  TRUE);
	define("logformat_referer" , "%{Referer}i -> %U",  TRUE);
	define("logformat_agent"   , "%{User-agent}i",  TRUE);
}

##########################################
## Database information below here      ##
##########################################
$databaselocation = 'localhost';
$databaseport = '3306';
$databasename = 'ows';
$databaseuser = 'ows';
$databasepass = 'pass';
$db_connect = mysql_connect($databaselocation, $databaseuser, $databasepass);
mysql_select_db($databasename, $db_connect);
	
##########################################
## Logfile and Logformat are for the db ##
## import in the class_apache file.     ##
## $openstatsdir is the install dir on  ##
## your system.                         ##
##########################################
$openstats_web_dir = '/openwebstats'; // Remember to include the stats dir
$logfile = "/var/log/apache2/access_log";
$logformat = logformat_combined; //example: $logformat = logformat_combined_vhost;

?>
