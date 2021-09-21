# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

PROJ_DATA="proj-data-1.7.tar.gz"
DESCRIPTION="PROJ coordinate transformation software"
HOMEPAGE="https://proj.org/"
SRC_URI="
	https://download.osgeo.org/proj/${P}.tar.gz
	https://download.osgeo.org/proj/${PROJ_DATA}
"

LICENSE="MIT"
# SONAME in 8.1.1 is actually 23 (in 8.1.0, was 22)
# It's far less confusing to just increment it again here (so N+1)
SLOT="0/24"
KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="curl test +tiff"

RESTRICT="!test? ( test )"

RDEPEND="dev-db/sqlite:3
	curl? ( net-misc/curl )
	tiff? ( media-libs/tiff )"
DEPEND="${RDEPEND}
	test? ( dev-cpp/gtest )"

src_unpack() {
	unpack ${P}.tar.gz

	cd "${S}"/data || die
	mv README README.DATA || die

	unpack ${PROJ_DATA}
}

src_configure() {
	local mycmakeargs=(
		-DDOCDIR="${EPREFIX}"/usr/share/${PF}
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
	dodoc README.DATA

	find "${ED}" -name '*.la' -type f -delete || die
}
