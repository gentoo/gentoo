# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-leechcraft/lc-hotstreams/lc-hotstreams-9999.ebuild,v 1.1 2013/03/08 21:58:44 maksbotan Exp $

EAPI="4"

inherit eutils leechcraft toolchain-funcs

DESCRIPTION="Provides some cool radio streams to music players like LMP"

SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="~app-leechcraft/lc-core-${PV}
	dev-libs/qjson"
RDEPEND="${DEPEND}"
