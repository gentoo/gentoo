# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DATUMGRID="${PN}-datumgrid-1.8.tar.gz"
EUROPE_DATUMGRID="${PN}-datumgrid-europe-1.6.tar.gz"

DESCRIPTION="PROJ coordinate transformation software"
HOMEPAGE="https://proj4.org/"
SRC_URI="
	https://download.osgeo.org/proj/${P}.tar.gz
	https://download.osgeo.org/proj/${DATUMGRID}
	europe? ( https://download.osgeo.org/proj/${EUROPE_DATUMGRID} )
"

LICENSE="MIT"
SLOT="0/19"
KEYWORDS="~amd64 ~arm arm64 ~ia64 ppc ppc64 ~s390 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="curl europe static-libs test +tiff"
REQUIRED_USE="test? ( !europe )"

RESTRICT="!test? ( test )"

RDEPEND="
	dev-db/sqlite:3
	curl? ( net-misc/curl )
	tiff? ( media-libs/tiff )
"
DEPEND="${RDEPEND}"

src_unpack() {
	unpack ${P}.tar.gz
	cd "${S}"/data || die
	mv README README.DATA || die
	unpack ${DATUMGRID}
	use europe && unpack ${EUROPE_DATUMGRID}
}

src_configure() {
	econf \
		$(use_with curl) \
		$(use_enable static-libs static) \
		$(use_enable tiff)
}

src_install() {
	default
	cd data || die
	dodoc README.{DATA,DATUMGRID}
	use europe && dodoc README.EUROPE
	find "${D}" -name '*.la' -type f -delete || die
}
