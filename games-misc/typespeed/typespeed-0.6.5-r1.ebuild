# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools

DESCRIPTION="Test your typing speed, and get your fingers CPS"
HOMEPAGE="http://typespeed.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc64 ~x86"
IUSE="nls"

RDEPEND="
	sys-libs/ncurses:0=
	nls? ( virtual/libintl )
"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )
"

src_prepare() {
	default
	sed -i \
		-e 's/testsuite//' \
		-e 's/doc//' \
		Makefile.am || die
	sed -i -e '/^CC =/d' src/Makefile.am || die
	eapply "${FILESDIR}"/${P}-musl.patch
	rm -rf m4 #417265
	eautoreconf
}

src_configure() {
	econf \
		--localedir=/usr/share/locale \
		--docdir=/usr/share/doc/${PF} \
		$(use_enable nls)
}

src_install() {
	default
	dodoc doc/README
}
