# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

WX_GTK_VER="3.0"
inherit autotools desktop wxwidgets

MY_P="${PN}_v${PV}"

DESCRIPTION="Open source clone of the four-player board game Blokus"
HOMEPAGE="https://sourceforge.net/projects/blokish/"
SRC_URI="mirror://sourceforge/blokish/${MY_P}.tgz"
S="${WORKDIR}"/${PN}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	x11-libs/wxGTK:${WX_GTK_VER}[X,opengl]
	virtual/glu
	virtual/opengl"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-gcc43.patch
	"${FILESDIR}"/${P}-underlink.patch
	"${FILESDIR}"/${P}-wxgtk.patch
)

src_prepare() {
	default

	# Otherwise $WX_CONFIG is unset:
	setup-wxwidgets

	sed -i \
		-e "s:wx-config:${WX_CONFIG}:" \
		configure.in makefile.am || die
	mv configure.in configure.ac || die

	eautoreconf
}

src_install() {
	default
	dodoc -r docs/.

	doicon src/${PN}.xpm
	make_desktop_entry ${PN} Blokish ${PN}
}
