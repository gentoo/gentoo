#!/usr/bin/env csh
# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-base/gnustep-make/files/gnustep-4.csh,v 1.1 2011/04/20 17:42:09 voyageur Exp $

# Test for an interactive shell
if ( $?prompt ) then

	setenv GNUSTEP_SYSTEM_TOOLS "@GENTOO_PORTAGE_EPREFIX@"/usr/bin

	if ( -x $GNUSTEP_SYSTEM_TOOLS/make_services ) then
		$GNUSTEP_SYSTEM_TOOLS/make_services
	endif

	if ( -x $GNUSTEP_SYSTEM_TOOLS/gdnc ) then
		$GNUSTEP_SYSTEM_TOOLS/gdnc
	endif

endif
