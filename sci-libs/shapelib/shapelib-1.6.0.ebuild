# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Library for manipulating ESRI Shapefiles"
HOMEPAGE="http://shapelib.maptools.org/"
SRC_URI="https://download.osgeo.org/${PN}/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2"
SLOT="0/4"
KEYWORDS="amd64 ~arm arm64 ~ppc ppc64 ~riscv x86"
IUSE="doc static-libs"

src_prepare() {
	default
	rm -f m4/* || die
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--includedir="${EPREFIX}"/usr/include/libshp
		--prefix="${EPREFIX}"/usr
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	use doc && HTML_DOCS=( web/. )
	default

	if ! use static-libs; then
		find "${ED}" \( -name '*.la' -o -name '*.a' \) -delete || die
	fi
}
