#!/usr/bin/env csh
# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
