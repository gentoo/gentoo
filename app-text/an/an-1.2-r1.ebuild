# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils toolchain-funcs

DESCRIPTION="Very fast anagram generator with dictionary lookup"
HOMEPAGE="http://packages.debian.org/unstable/games/an"

SRC_URI="mirror://debian/pool/main/a/${PN}/${PN}_${PV}.orig.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86"

DEPEND="
	dev-libs/icu:=
"
RDEPEND="
	${DEPEND}
	sys-apps/miscfiles[-minimal]
"

src_prepare() {
	default

	sed -i \
		-e '/^CC/s|:=|?=|' \
		-e 's|$(CC) $(CFLAGS)|& $(LDFLAGS)|g' \
		-e '/^CPPFLAGS/s|-D_BSD_SOURCE=1 -D_GNU_SOURCE=1|-D_DEFAULT_SOURCE=1|g' \
		Makefile || die
	tc-export CC
}

src_install() {
	dobin ${PN}
	newman ${PN}.6 ${PN}.1
	dodoc ALGORITHM
}
