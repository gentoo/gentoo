# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils

DESCRIPTION="backend library for the maitretarot clients"
HOMEPAGE="http://www.nongnu.org/maitretarot/"
SRC_URI="https://savannah.nongnu.org/download/maitretarot/${PN}.pkg/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="dev-libs/glib:2
	dev-libs/libxml2
	dev-games/libmaitretarot"
RDEPEND=${DEPEND}

src_prepare() {
	epatch "${FILESDIR}"/${P}-format.patch
}

src_configure() {
	econf --disable-static
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
