# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

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
SLOT="0/22"
KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="curl europe test +tiff"
REQUIRED_USE="test? ( !europe )"

RESTRICT="!test? ( test )"

RDEPEND="
	dev-db/sqlite:3
	curl? ( net-misc/curl )
	tiff? ( media-libs/tiff )
"
DEPEND="
	${RDEPEND}
	test? ( dev-cpp/gtest )
"

src_unpack() {
	unpack ${P}.tar.gz

	cd "${S}"/data || die
	mv README README.DATA || die

	unpack ${DATUMGRID}
	use europe && unpack ${EUROPE_DATUMGRID}
}

src_configure() {
	local mycmakeargs=(
		-DDOCDIR="${EPREFIX}/usr/share/${PF}"
		-DBUILD_TESTING=$(usex test)
		-DENABLE_CURL=$(usex curl)
		-DBUILD_PROJSYNC=$(usex curl)
		-DENABLE_TIFF=$(usex tiff)
	)

	use test && mycmakeargs+=( -DUSE_EXTERNAL_GTEST=ON )

	cmake_src_configure
}

src_install() {
	cmake_src_install

	cd data || die
	dodoc README.{DATA,DATUMGRID}
	use europe && dodoc README.EUROPE
	find "${ED}" -name '*.la' -type f -delete || die
}
