#!/bin/bash
# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# use "freevoboot stop" to stop, "freevoboot xstop" if you use X.

freevo=`grep ^freevo= /etc/conf.d/freevo | cut -d'"' -f2`
webserver=`grep ^webserver= /etc/conf.d/freevo | cut -d'"' -f2`
recordserver=`grep ^recordserver= /etc/conf.d/freevo | cut -d'"' -f2`


if [ "x$1" != "xstop" ]; then
	if [ "$recordserver" == "yes" ]; then
		echo "Starting Freevo recordserver"
		/usr/bin/freevo recordserver start
	fi

	if [ "$webserver" == "yes" ]; then
		echo "Starting Freevo webserver"
		/usr/bin/freevo webserver start
	fi

	if [ "$freevo" == "daemon" ] && [ "x$1" != "xstartx" ]; then
		echo "Starting Freevo daemon"
		/usr/bin/freevo daemon start
	elif [ "$freevo" == "yes" ] || [ "x$1" == "xstartx" ] ; then
		echo "Starting Freevo"
		if egrep -q '^display.*(x11|dga)' /etc/freevo/freevo.conf ; then
			/usr/bin/freevo -fs &>/dev/null &
		else
			/usr/bin/freevo start
		fi
	fi

else
	if [ "$freevo" == "daemon" ] && [ "x$1" != "xstopx" ]; then
		echo "Stopping Freevo daemon"
		/usr/bin/freevo daemon stop
	elif [ "$freevo" == "yes" ] || [ "x$1" == "xstopx" ] ; then
		echo "Stopping Freevo"
		/usr/bin/freevo stop
	fi

        if [ "$webserver" == "yes" ]; then
                echo "Stopping Freevo webserver"
                /usr/bin/freevo webserver stop
        fi

        if [ "$recordserver" == "yes" ]; then
                echo "Stopping Freevo recordserver"
                /usr/bin/freevo recordserver stop
        fi
fi
