# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

HORDE_PHP_FEATURES="-o mysql mysqli odbc postgres ldap"
HORDE_MAJ="-h3"
inherit horde

DESCRIPTION="Nag is the Horde multiuser task list manager"

KEYWORDS="alpha amd64 hppa ppc x86"

DEPEND=""
RDEPEND=">=www-apps/horde-3"

src_unpack() {
	horde_src_unpack

	# Remove vtodo specs as they don't install and are not useful to the end user
	rm -r docs/vtodo || die 'removing docs failed'
}
