#!/usr/bin/env sh
# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-base/gnustep-make/files/gnustep-5.sh,v 1.1 2014/01/29 14:48:32 voyageur Exp $

# Test for an interactive shell
case $- in
	*i*)
	;;
	*)
		return
	;;
esac
	
GNUSTEP_SYSTEM_TOOLS="@GENTOO_PORTAGE_EPREFIX@"/usr/bin

if [ -x ${GNUSTEP_SYSTEM_TOOLS}/make_services ]; then
    ${GNUSTEP_SYSTEM_TOOLS}/make_services
fi
