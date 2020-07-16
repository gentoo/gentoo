# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools desktop

MY_P=${P/lives}

DESCRIPTION="A console-style role playing game"
HOMEPAGE="http://kqlives.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cheats nls"

RDEPEND="
	dev-lang/lua:0
	>=gnome-base/libglade-2.4
	media-libs/allegro:0
	>=media-libs/dumb-2.0.3[allegro]
	>=x11-libs/gtk+-2.8:2
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

S=${WORKDIR}/${MY_P}

PATCHES=(
	"${FILESDIR}/${P}_autoconf.patch"	# Fix #597790
	"${FILESDIR}/${P}_dumb2.patch"		# >=media-libs/dumb-2.0.3 support
	"${FILESDIR}/${P}_gcc10.patch"		# Fix #661422
)

src_prepare() {
	default
	mv debian/{kq,${PN}}.6 || die
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable cheats) \
		$(use_enable nls)
}

src_install() {
	default
	doicon "${FILESDIR}"/${PN}.xpm
	make_desktop_entry ${PN} KqLives ${PN}
}
