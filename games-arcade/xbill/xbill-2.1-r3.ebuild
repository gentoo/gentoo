# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools desktop

DESCRIPTION="A game about an evil hacker called Bill!"
HOMEPAGE="http://www.xbill.org/"
SRC_URI="http://www.xbill.org/download/${P}.tar.gz"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~x86"
IUSE="gtk"

RDEPEND="acct-group/gamestat
	media-fonts/font-misc-misc
	gtk? ( x11-libs/gtk+:2 )
	!gtk? ( x11-libs/libXaw )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-gtk2.patch
	"${FILESDIR}"/${P}-gentoo.patch
)

src_prepare() {
	default
	mv configure.in configure.ac || die
	eautoreconf
}

src_configure() {
	econf \
		--disable-motif \
		$(use_enable gtk) \
		$(use_enable !gtk athena)
}

src_install() {
	default
	newicon pixmaps/icon.xpm ${PN}.xpm
	make_desktop_entry ${PN} XBill ${PN}
	fowners :gamestat /var/lib/xbill/scores
	fperms 664 /var/lib/xbill/scores
}
