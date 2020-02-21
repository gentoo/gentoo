# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="Library for manipulating ESRI Shapefiles"
HOMEPAGE="http://shapelib.maptools.org/"
SRC_URI="http://download.osgeo.org/${PN}/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2"
SLOT="0/2"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc static-libs"

RDEPEND="sci-libs/proj:="
DEPEND="${RDEPEND}"

src_prepare() {
	default
	rm -r m4/* || die
	eautoreconf
}

src_configure() {
	econf \
		--includedir=/usr/include/libshp
}

src_install() {
	use doc && HTML_DOCS=( web/. )
	default

	if ! use static-libs; then
		find "${D}" \( -name '*.la' -o -name '*.a' \) -delete || die
	fi
}
