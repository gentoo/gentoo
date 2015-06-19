# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-leechcraft/lc-pogooglue/lc-pogooglue-9999.ebuild,v 1.1 2013/03/08 22:04:35 maksbotan Exp $

EAPI="4"

inherit leechcraft

DESCRIPTION="Provides searching with Google to other LeechCraft plugins"

SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="~app-leechcraft/lc-core-${PV}"
RDEPEND="${DEPEND}"
