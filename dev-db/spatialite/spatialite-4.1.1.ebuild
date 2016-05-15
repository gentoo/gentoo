# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MY_PN="lib${PN}"
MY_P="${MY_PN}-${PV}"

inherit multilib eutils

DESCRIPTION="A complete Spatial DBMS in a nutshell built upon sqlite"
HOMEPAGE="http://www.gaia-gis.it/gaia-sins/"
SRC_URI="http://www.gaia-gis.it/gaia-sins/${MY_PN}-sources/${MY_P}.tar.gz"

LICENSE="MPL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE="+geos iconv +proj +xls"

RDEPEND=">=dev-db/sqlite-3.7.5:3[extensions(+)]
	geos? ( >=sci-libs/geos-3.3 )
	proj? ( sci-libs/proj )
	xls? ( dev-libs/freexl )
"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}/${P}-validator.patch"
}

src_configure() {
	econf \
		--disable-static \
		--enable-geocallbacks \
		--enable-epsg \
		--disable-examples \
		$(use_enable geos) \
		$(use_enable geos geosadvanced) \
		$(use_enable iconv) \
		$(use_enable proj) \
		$(use_enable xls freexl)
}

src_install() {
	default

	find "${ED}" -name '*.la' -exec rm -f {} +
}
