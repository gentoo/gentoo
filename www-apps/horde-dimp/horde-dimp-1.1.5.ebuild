# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

HORDE_PHP_FEATURES="imap"
HORDE_MAJ="-h3"
inherit horde

DESCRIPTION="Horde DIMP is a alternate presentation view of IMP using AJAX-ish
technologies"

KEYWORDS="alpha amd64 hppa ~ia64 ppc ~sparc x86"
IUSE=""

DEPEND=""
RDEPEND="|| ( >=www-apps/horde-3.2 >=www-apps/horde-groupware-1 )
	|| ( >=www-apps/horde-imp-4.2 >=www-apps/horde-groupware-1 )
	!www-apps/horde-webmail"
