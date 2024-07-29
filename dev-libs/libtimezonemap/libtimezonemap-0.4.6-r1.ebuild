# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools xdg

DESCRIPTION="GTK+3 timezone map widget"
HOMEPAGE="https://launchpad.net/timezonemap"
SRC_URI="mirror://debian/pool/main/libt/${PN}/${PN}_${PV}.orig.tar.gz -> ${PN}_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~loong ~ppc64 ~riscv x86"

DEPEND="dev-libs/glib:2
	dev-libs/gobject-introspection:0=
	dev-libs/json-glib
	net-libs/libsoup:2.4
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:3"
RDEPEND="${DEPEND}"

src_prepare() {
	default

	eautoreconf
}

src_install() {
	default

	find "${D}" -name '*.la' -delete || die
}
