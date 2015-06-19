#!/bin/bash
# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/yaggui/files/yaggui.sh,v 1.1 2004/08/30 20:16:52 squinky86 Exp $

if [ ! "$(ps -A | grep -e giftd)" ]
then
	echo "Error! Unable to find giFT daemon!"
	echo "Attempting to start the giFT daemon..."
	giftd > /dev/null &
	if [ ! "$(ps -A | grep -e giftd)" ]
	then
		echo "Could not start the giFT daemon! Continuing to load Yaggui..."
	else
		echo "giFT daemon started, continuing to load Yaggui..."
	fi
fi

java -jar /usr/share/yaggui/lib/Yaggui.jar
