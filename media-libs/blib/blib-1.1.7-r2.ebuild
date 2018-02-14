# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="blib is a library full of useful things to hack the Blinkenlights"
HOMEPAGE="http://www.blinkenlights.de"
SRC_URI="http://www.blinkenlights.de/dist/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="aalib gtk"

RDEPEND="
	>=dev-libs/glib-2:2
	aalib? ( >=media-libs/aalib-1.4_rc4-r2 )
	gtk? ( >=x11-libs/gtk+-2.4.4:2 )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	default
	# Drop DEPRECATED flags, bug #391105
	sed -i -e 's:-D[A-Z_]*DISABLE_DEPRECATED:$(NULL):g' \
		blib/Makefile.am blib/Makefile.in \
		gfx/Makefile.am gfx/Makefile.in \
		modules/Makefile.am modules/Makefile.in \
		test/modules/Makefile.am test/modules/Makefile.in || die
}

src_configure() {
	econf \
		--disable-directfb \
		--disable-static \
		$(use_enable aalib) \
		$(use_enable gtk gtk2)
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
