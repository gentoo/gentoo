# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GUILE_REQ_USE="networking"
GUILE_COMPAT=( 2-2 )
inherit autotools desktop flag-o-matic guile-single xdg

DESCRIPTION="Analog waveform viewer for SPICE-like simulations"
HOMEPAGE="http://gwave.sourceforge.net"
SRC_URI="https://downloads.sourceforge.net/${PN}/gwave3/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="amd64 ~x86"
IUSE="gnuplot plotutils"
SLOT="0"

REQUIRED_USE="${GUILE_REQUIRED_USE}"

DEPEND="
	${GUILE_DEPS}
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
	"${FILESDIR}"/${P}-lfs-shim.patch
)

src_prepare() {
	guile-single_src_prepare

	sed -i \
		-e "s|guile-snarf|${GUILESNARF}|" \
		-e "s|guile-tools|${GUILE/guile/guile-tools}|" \
		src/Makefile.am || die
	sed -i \
		-e "s|guile-tools|${GUILE/guile/guile-tools}|" \
		scheme/Makefile.am || die

	eautoreconf
}

src_configure() {
	# https://bugs.gentoo.org/886139
	append-lfs-flags
	econf
}

src_install() {
	guile-single_src_install
	newicon icons/wave-drag-ok.xpm gwave.xpm
	make_desktop_entry gwave "Gwave" gwave "Electronics"
}
