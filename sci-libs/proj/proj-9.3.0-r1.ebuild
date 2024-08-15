# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

# Check https://proj.org/download.html for latest data tarball
PROJ_DATA="proj-data-1.15.tar.gz"
DESCRIPTION="PROJ coordinate transformation software"
HOMEPAGE="https://proj.org/"
SRC_URI="
	https://download.osgeo.org/proj/${P}.tar.gz
	https://download.osgeo.org/proj/${PROJ_DATA}
"

LICENSE="MIT"
# Changes on every major release
SLOT="0/$(ver_cut 1)"
KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="curl test +tiff"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-db/sqlite:3
	curl? ( net-misc/curl )
	tiff? ( media-libs/tiff:= )
"
DEPEND="
	${RDEPEND}
	test? ( dev-cpp/gtest )
"

PATCHES=(
	"${FILESDIR}"/${PN}-geotiff.patch
	"${FILESDIR}"/${PN}-9.3.0-include-cstdint.patch
)

src_unpack() {
	unpack ${P}.tar.gz

	cd "${S}"/data || die
	mv README README.DATA || die

	unpack ${PROJ_DATA}
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test)
		-DBUILD_PROJSYNC=$(usex curl)
		-DENABLE_CURL=$(usex curl)
		-DENABLE_TIFF=$(usex tiff)
	)

	if use test ; then
		mycmakeargs+=(
			-DUSE_EXTERNAL_GTEST=ON
			-DBUILD_BENCHMARKS=OFF
			-DRUN_NETWORK_DEPENDENT_TESTS=OFF
		)
	fi

	cmake_src_configure
}

src_test() {
	local myctestargs=(
		# proj_test_cpp_api: https://lists.osgeo.org/pipermail/proj/2019-September/008836.html
		# testprojinfo: Also related to map data?
		-E "(proj_test_cpp_api|testprojinfo)"
	)

	cmake_src_test
}

src_install() {
	cmake_src_install

	cd data || die
	dodoc README.DATA

	find "${ED}" -name '*.la' -type f -delete || die
}
