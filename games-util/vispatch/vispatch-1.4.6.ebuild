# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-util/vispatch/vispatch-1.4.6.ebuild,v 1.3 2014/08/29 11:26:06 nimiux Exp $

EAPI=5
inherit toolchain-funcs

DESCRIPTION="WaterVIS utility for glquake"
HOMEPAGE="http://vispatch.sourceforge.net/"
SRC_URI="mirror://sourceforge/vispatch/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

S=${WORKDIR}/${P}/source

src_prepare() {
	sed -i \
		-e '/^CFLAGS/d' \
		-e '/^LDFLAGS/d' \
		makefile || die
	tc-export CC
}

src_install() {
	dobin ${PN}
	dodoc ${PN}.txt
}
