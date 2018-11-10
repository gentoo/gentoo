# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit autotools eutils flag-o-matic fdo-mime gnome2-utils

MY_PN="gwave2"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Analog waveform viewer for SPICE-like simulations"
LICENSE="GPL-2"
HOMEPAGE="http://gwave.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

KEYWORDS="amd64 x86"
IUSE="gnuplot plotutils"
SLOT="0"

DEPEND="=dev-scheme/guile-1.8*[networking]
	=dev-scheme/guile-gnome-platform-2.16*"

RDEPEND="${DEPEND}
	sci-electronics/electronics-menu
	gnuplot? ( sci-visualization/gnuplot )
	plotutils? ( media-libs/plotutils )"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	append-libs -lX11
	epatch "${FILESDIR}"/${P}-as-needed.patch
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
