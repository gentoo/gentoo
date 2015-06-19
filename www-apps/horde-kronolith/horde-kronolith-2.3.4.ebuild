# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/horde-kronolith/horde-kronolith-2.3.4.ebuild,v 1.2 2012/03/19 18:56:40 armin76 Exp $

HORDE_PHP_FEATURES="-o mysql mysqli odbc postgres ldap"
HORDE_MAJ="-h3"
inherit horde

DESCRIPTION="Kronolith is the Horde calendar application"

KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~x86"

DEPEND=""
RDEPEND=">=www-apps/horde-3"
