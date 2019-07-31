# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools desktop xdg-utils

DESCRIPTION="Analog waveform viewer for SPICE-like simulations"
HOMEPAGE="http://gwave.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/gwave3/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="amd64 x86"
IUSE="gnuplot plotutils"
SLOT="0"

DEPEND="
	>=dev-scheme/guile-2[networking]
	>=x11-libs/gtk+-2.8.0:2=
	sys-libs/readline:0=
	sys-libs/ncurses:0="

RDEPEND="${DEPEND}
	sci-electronics/electronics-menu
	gnuplot? ( sci-visualization/gnuplot )
	plotutils? ( media-libs/plotutils )"

PATCHES=(
	"${FILESDIR}"/${P}-multiple-little-bugfixes.patch
	"${FILESDIR}"/${P}-as-needed.patch
	"${FILESDIR}"/${P}-fix-configure.patch
)

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default
	newicon icons/wave-drag-ok.xpm gwave.xpm
	make_desktop_entry gwave "Gwave" gwave "Electronics"
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	xdg_icon_cache_update
}
