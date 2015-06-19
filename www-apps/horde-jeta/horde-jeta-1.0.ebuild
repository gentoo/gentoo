# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/horde-jeta/horde-jeta-1.0.ebuild,v 1.2 2008/05/31 05:12:25 vapier Exp $

HORDE_MAJ="-h3"
inherit horde

DESCRIPTION="Java SSH interface for Horde"

KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~sparc ~x86"

DEPEND=""
RDEPEND="|| ( >=www-apps/horde-3 >=www-apps/horde-groupware-1 >=www-apps/horde-webmail-1 )"
