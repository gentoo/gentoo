# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit autotools eutils

DESCRIPTION="ncurses based hex editor"
HOMEPAGE="http://www.jewfish.net/description.php?title=HexCurse"
SRC_URI="http://www.jewfish.net/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ppc s390 sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"

RDEPEND=">=sys-libs/ncurses-5.2:0="
DEPEND="
	${RDEPEND}
"

src_prepare() {
	epatch \
		"${FILESDIR}"/${PV}-gcc.patch \
		"${FILESDIR}"/${PV}-tinfo.patch

	eautoreconf
}

src_install() {
	emake install DESTDIR="${D}"
	dodoc AUTHORS ChangeLog NEWS README
}
