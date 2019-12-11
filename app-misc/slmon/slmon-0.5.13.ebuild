# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit autotools eutils

DESCRIPTION="Colored text-based system performance monitor"
HOMEPAGE="http://slmon.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE="debug"

RDEPEND="
	dev-libs/glib:2
	sys-libs/slang
	gnome-base/libgtop
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	epatch "${FILESDIR}"/${P}-make-382.patch \
		"${FILESDIR}"/${P}-invalid-free.patch
	eautoreconf
}

src_configure() {
	econf \
		--disable-dependency-tracking \
		$(use_enable debug)
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog README slmonrc TODO
	dohtml *.html
}
