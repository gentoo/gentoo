# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="backend library for the maitretarot clients"
HOMEPAGE="http://www.nongnu.org/maitretarot/"

SRC_URI="https://savannah.nongnu.org/download/maitretarot/${PN}.pkg/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="dev-libs/glib:2
	dev-libs/libxml2
	dev-games/libmaitretarot"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-format.patch
	"${FILESDIR}"/${PN}-0.1.98-libdir.patch
)

src_prepare() {
	default

	mv configure.{in,ac} || die

	# For the m4 libdir patch, bug #729734
	eautoreconf
}

src_configure() {
	econf --disable-static
}

src_install() {
	default

	# bug #716102
	insinto /usr/share/aclocal
	doins libmt_client.m4

	find "${ED}" -name '*.la' -delete || die
}
