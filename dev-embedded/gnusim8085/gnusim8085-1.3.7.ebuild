# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools xdg

DESCRIPTION="A GTK2 8085 Simulator"
HOMEPAGE="http://gnusim8085.org"
SRC_URI="https://launchpad.net/${PN}/trunk/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="nls"

RDEPEND="
	>=x11-libs/gtk+-2.12:2
	x11-libs/gdk-pixbuf:2
	dev-libs/glib:2
	x11-libs/gtksourceview:2.0
	x11-libs/pango"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

PATCHES=(
	"${FILESDIR}"/${P}-docs.patch
	"${FILESDIR}"/${P}-cflags.patch
)

src_prepare() {
	default
	mv configure.{in,ac} || die
	eautoreconf
}

src_configure() {
	econf $(use_enable nls)
}

src_install() {
	default

	doman doc/gnusim8085.1

	docinto examples
	dodoc doc/examples/*.asm doc/asm-guide.txt
	docompress -x /usr/share/doc/${PF}/examples
}
