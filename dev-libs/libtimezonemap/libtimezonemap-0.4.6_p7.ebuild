# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools xdg

MY_PV=$(ver_cut 1-3)
DEBIAN_PV=$(ver_cut 5)

DESCRIPTION="GTK+3 timezone map widget"
HOMEPAGE="
	https://launchpad.net/timezonemap
	https://salsa.debian.org/cinnamon-team/libtimezonemap
"
SRC_URI="
	mirror://debian/pool/main/libt/${PN}/${PN}_${MY_PV}.orig.tar.gz
	mirror://debian/pool/main/libt/${PN}/${PN}_${MY_PV}-${DEBIAN_PV}.debian.tar.xz"
S="${WORKDIR}"/${PN}-${MY_PV}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"

DEPEND="
	dev-libs/glib:2
	dev-libs/gobject-introspection:0=
	dev-libs/json-glib
	net-libs/libsoup:3.0
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
"
RDEPEND="${DEPEND}"

src_prepare() {
	local i
	for i in $(<"${WORKDIR}"/debian/patches/series); do
		PATCHES+=("${WORKDIR}"/debian/patches/${i})
	done

	default

	eautoreconf
}

src_install() {
	default

	find "${D}" -name '*.la' -delete || die
}
