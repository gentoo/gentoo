#!/bin/bash
# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/gift-gnutella/files/cacheupdate.sh,v 1.10 2007/08/17 22:56:50 coldwind Exp $

CACHE_LIST="g2.tjtech.org/g2/
	gwc1c.olden.ch.3557.nyud.net:8080/gwc/
	gwc.eod.cc/skulls.php
	skulls.mi-cha-el.org/skulls.php
	gwc.frodoslair.net/skulls/skulls"

URLFILE="?urlfile=1\&client=GEN2\&version=0.2"
HOSTFILE="?hostfile=1\&client=GEN2\&version=0.2"

if [ -d ~/.giFT/Gnutella/ ]; then
	cd ~/.giFT/Gnutella

	# Try to fetch an updated list
	wget http://gcachescan.jonatkins.com/ -O .my_list &> /dev/null
	if [[ $? -eq 0 ]] ; then
		my_cache_list=$(grep gcachedetail .my_list | sed -e "s:.*gcachedetail.cgi?\(.*\)\">?</a>.*:\1:g" | head -n 10)
		[[ -n ${my_cache_list} ]] && CACHE_LIST=${my_cache_list}
	else
		echo "Failed to fetch gwebcaches' list, trying with local list."
	fi

	# Fetch gwebcaches
	ok=0
	for cache in ${CACHE_LIST} ; do
		wget ${cache}${URLFILE} -O .gwebcaches.new &> /dev/null
		if [[ $? -ne 0 ]] ; then
			echo "Failed to fetch gwebcaches file from ${cache}"
			#CACHE_LIST=${CACHE_LIST/${cache}/}
		elif [[ -z $(grep -e "^http://.*"  .gwebcaches.new) ]] || [[ -n $(grep ERROR .gwebcaches.new) ]] ; then
			echo "Fetched file from ${cache} is invalid"
		else
			mv .gwebcaches.new gwebcaches
			echo -e "\ngwebcaches fetched\n"
			ok=1
			break
		fi
	done
	if [[ $ok -ne 1 ]] ; then
		echo "Couldn't fetch gwebcaches!"
		exit 1
	fi

	# Fetch nodes
	ok=0
	for cache in ${CACHE_LIST} ; do
		wget ${cache}${HOSTFILE} -O .nodes.new &> /dev/null
		if [[ $? -ne 0 ]] ; then
			echo "Failed to fetch nodes file from ${cache}"
			#CACHE_LIST=${CACHE_LIST/${cache}/}
		elif [[ -n $(grep ERROR .nodes.new) ]] ; then
			echo "Fetched file from ${cache} is invalid"
		else
			mv .nodes.new nodes
			echo -e "\nnodes fetched\n"
			ok=1
			break
		fi
	done
	if [[ $ok -ne 1 ]] ; then
		echo "Couldn't fetch nodes!"
		exit 1
	fi

	rm .my_list
	echo -e "\nUpdate complete!"
else
	echo " ~/.giFT/Gnutella/ does not exist. Please run gift-setup."
fi
