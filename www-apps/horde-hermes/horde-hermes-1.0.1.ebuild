# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/horde-hermes/horde-hermes-1.0.1.ebuild,v 1.1 2010/08/17 18:51:20 a3li Exp $

HORDE_MAJ="-h3"
inherit horde

DESCRIPTION="A time-tracking application for Horde"

KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND="|| ( >=www-apps/horde-3 >=www-apps/horde-groupware-1 )"
