# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="lib${PN}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A complete Spatial DBMS in a nutshell built upon sqlite"
HOMEPAGE="https://www.gaia-gis.it/gaia-sins/"
SRC_URI="https://www.gaia-gis.it/gaia-sins/${MY_PN}-sources/${MY_P}.tar.gz"

LICENSE="MPL-1.1"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc ~ppc64 x86"
IUSE="+geos iconv +proj test +xls +xml"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-db/sqlite-3.7.5:3[extensions(+)]
	sys-libs/zlib
	geos? ( >=sci-libs/geos-3.4 )
	proj? ( sci-libs/proj )
	xls? ( dev-libs/freexl )
	xml? ( dev-libs/libxml2 )
"
DEPEND="${RDEPEND}"

REQUIRED_USE="test? ( iconv )"

S="${WORKDIR}/${MY_P}"

src_configure() {
	econf \
		--disable-examples \
		--disable-static \
		--enable-epsg \
		--enable-geocallbacks \
		$(use_enable geos) \
		$(use_enable geos geosadvanced) \
		$(use_enable iconv) \
		$(use_enable proj) \
		$(use_enable xls freexl) \
		$(use_enable xml libxml2)
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
