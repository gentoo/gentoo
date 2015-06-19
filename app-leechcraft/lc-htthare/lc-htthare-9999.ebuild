# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-leechcraft/lc-htthare/lc-htthare-9999.ebuild,v 1.1 2013/12/03 17:25:45 pinkbyte Exp $

EAPI="5"

inherit leechcraft

DESCRIPTION="Simple HTTP server for Leechcraft"

SLOT="0"
KEYWORDS=""

DEPEND="~app-leechcraft/lc-core-${PV}"
RDEPEND="${DEPEND}"
