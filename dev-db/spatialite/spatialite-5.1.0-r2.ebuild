# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit libtool

MY_PN="lib${PN}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Complete Spatial DBMS in a nutshell built upon sqlite"
HOMEPAGE="https://www.gaia-gis.it/gaia-sins/"
SRC_URI="https://www.gaia-gis.it/gaia-sins/${MY_PN}-sources/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="MPL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="+geos iconv +proj rttopo test +xls"
REQUIRED_USE="test? ( iconv )"
# Further poking required
RESTRICT="test"

RDEPEND="
	>=dev-db/sqlite-3.7.5:3[extensions(+)]
	dev-libs/libxml2
	sys-libs/zlib[minizip]
	geos? ( >=sci-libs/geos-3.11.0 )
	proj? ( sci-libs/proj:= )
	rttopo? ( sci-geosciences/librttopo )
	xls? ( >=dev-libs/freexl-2.0.0[xml(+)] )
"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}/${P}-macro-surgery.patch" )

src_prepare() {
	default
	elibtoolize
}

src_configure() {
	# 1) gcp disabled for now to preserve MPL licence
	econf \
		--disable-gcp \
		--disable-examples \
		--disable-static \
		--enable-epsg \
		--enable-libxml2 \
		$(use_enable geos) \
		$(use_enable geos geosadvanced) \
		$(use_enable geos geos3100) \
		$(use_enable geos geos3110) \
		$(use_enable iconv) \
		$(use_enable proj) \
		$(use_enable rttopo) \
		$(use_enable xls freexl)
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
