#!/bin/sh

# This script waits for mysqld to be ready to accept connections
# (which can be many seconds or even minutes after launch, if there's
# a lot of crash-recovery work to do).
# Running this as ExecStartPost is useful so that services declared as
# "After mysqld" won't be started until the database is really ready.

# Service file passes us the daemon's PID (actually, mysqld_safe's PID)
daemon_pid="$1"

# extract value of a MySQL option from config files
# Usage: get_mysql_option SECTION VARNAME DEFAULT
# result is returned in $result
# We use my_print_defaults which prints all options from multiple files,
# with the more specific ones later; hence take the last match.
get_mysql_option(){
	result=`/usr/bin/my_print_defaults "$1" | sed -n "s/^--$2=//p" | tail -n 1`
	if [ -z "$result" ]; then
	    # not found, use default
	    result="$3"
	fi
}

# Defaults here had better match what mysqld_safe will default to
get_mysql_option mysqld datadir "/var/lib/mysql"
datadir="$result"
get_mysql_option mysqld socket "/var/lib/mysql/mysql.sock"
socketfile="$result"

# Wait for the server to come up or for the mysqld process to disappear
ret=0
while /bin/true; do
	RESPONSE=`/usr/bin/mysqladmin --no-defaults --socket="$socketfile" --user=UNKNOWN_MYSQL_USER ping 2>&1`
	mret=$?
	if [ $mret -eq 0 ]; then
	    break
	fi
	# exit codes 1, 11 (EXIT_CANNOT_CONNECT_TO_SERVICE) are expected,
	# anything else suggests a configuration error
	if [ $mret -ne 1 -a $mret -ne 11 ]; then
	    ret=1
	    break
	fi
	# "Access denied" also means the server is alive
	echo "$RESPONSE" | grep -q "Access denied for user" && break

	# Check process still exists
	if ! /bin/kill -0 $daemon_pid 2>/dev/null; then
	    ret=1
	    break
	fi
	sleep 1
done

exit $ret
