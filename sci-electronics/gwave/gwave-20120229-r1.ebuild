# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

WANT_AUTOMAKE=1.9

inherit autotools desktop gnome2-utils xdg-utils

rev="r249"

DESCRIPTION="Analog waveform viewer for SPICE-like simulations"
HOMEPAGE="http://gwave.sourceforge.net"
SRC_URI="https://sourceforge.net/code-snapshots/svn/g/gw/gwave/code/gwave-code-${rev}-trunk.zip"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="gnuplot plotutils"
SLOT="0"

DEPEND="app-arch/unzip
	>=dev-scheme/guile-2[deprecated,networking]
	<dev-scheme/guile-2.2
	dev-scheme/guile-gnome-platform
	x11-libs/guile-gtk"

RDEPEND="${DEPEND}
	sci-electronics/electronics-menu
	gnuplot? ( sci-visualization/gnuplot )
	plotutils? ( media-libs/plotutils )"

DEPEND="${DEPEND}
	app-text/docbook-sgml-utils"

S="${WORKDIR}/gwave-code-${rev}-trunk"

PATCHES=(
	"${FILESDIR}"/${P}_as-needed.patch
	"${FILESDIR}"/${P}_doc.patch
	"${FILESDIR}"/${P}_missing_externs.patch
	"${FILESDIR}"/${P}_remove_gh.patch
	"${FILESDIR}"/${P}_remove_old_and_broken_compatibility_check.patch
	"${FILESDIR}"/${P}_stdlib.patch
	"${FILESDIR}"/${P}_unistd.patch
	)

src_prepare() {
	sed 's/AM_INIT_AUTOMAKE(gwave, [0-9]*)/AM_INIT_AUTOMAKE(gwave, ${PV})/' -i configure.ac || die
	default
	eautoreconf
}

src_install() {
	default
	newicon icons/wave-drag-ok.xpm gwave.xpm
	make_desktop_entry gwave "Gwave" gwave "Electronics"
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	gnome2_icon_cache_update
}
