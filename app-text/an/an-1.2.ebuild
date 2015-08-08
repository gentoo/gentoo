# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils toolchain-funcs

DESCRIPTION="Very fast anagram generator with dictionary lookup"
HOMEPAGE="http://packages.debian.org/unstable/games/an"

SRC_URI="mirror://debian/pool/main/a/${PN}/${PN}_${PV}.orig.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 hppa ppc ppc64 x86"
IUSE=""

CDEPEND="
	dev-libs/icu:=
"
DEPEND="
	app-arch/xz-utils
"
RDEPEND="
	${CDEPEND}
	sys-apps/miscfiles[-minimal]
"

src_prepare() {
	sed -i \
		-e '/^CC/s|:=|?=|' \
		-e 's|$(CC) $(CFLAGS)|& $(LDFLAGS)|g' \
		Makefile || die
	tc-export CC
}

src_install() {
	dobin ${PN}
	newman ${PN}.6 ${PN}.1
	dodoc ALGORITHM
}
