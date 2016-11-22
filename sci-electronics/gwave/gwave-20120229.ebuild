# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

WANT_AUTOMAKE=1.9

inherit autotools fdo-mime gnome2-utils

rev=249

DESCRIPTION="Analog waveform viewer for SPICE-like simulations"
LICENSE="GPL-2"
HOMEPAGE="http://gwave.sourceforge.net"
SRC_URI="https://sourceforge.net/code-snapshots/svn/g/gw/gwave/code/gwave-code-${rev}-trunk.zip"

KEYWORDS="~amd64 ~ppc ~x86"
IUSE="gnuplot plotutils"
SLOT="0"

DEPEND=">=dev-scheme/guile-2[deprecated,networking]
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
	epatch "${PATCHES[@]}"
	eapply_user
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS NEWS README TODO
	newicon icons/wave-drag-ok.xpm gwave.xpm
	make_desktop_entry gwave "Gwave" gwave "Electronics"
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}
