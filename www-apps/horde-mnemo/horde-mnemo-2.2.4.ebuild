# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/horde-mnemo/horde-mnemo-2.2.4.ebuild,v 1.3 2011/12/22 14:53:01 ago Exp $

HORDE_PHP_FEATURES="-o mysql mysqli odbc postgres ldap"
HORDE_MAJ="-h3"
inherit horde

DESCRIPTION="Mnemo is the Horde note manager"

KEYWORDS="~alpha amd64 ~hppa ~ppc ~sparc x86"

DEPEND=""
RDEPEND=">=www-apps/horde-3"
