# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="PROJ coordinate transformation software"
HOMEPAGE="https://proj.org/"

if [[ ${PV} = *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/OSGeo/PROJ.git"
	EGIT_DATA_REPO_URI="https://github.com/OSGeo/PROJ-data.git"
else
	# Check https://proj.org/download.html for latest data tarball
	# https://github.com/OSGeo/PROJ-data/releases
	PROJ_DATA_PV="1.18"
	SRC_URI="
		https://github.com/OSGeo/PROJ/releases/download/${PV}/${P}.tar.gz
		https://github.com/OSGeo/PROJ-data/releases/download/${PROJ_DATA_PV}.0/${PN}-data-${PROJ_DATA_PV}.tar.gz
		https://download.osgeo.org/proj/${P}.tar.gz
		https://download.osgeo.org/proj/${PN}-data-${PROJ_DATA_PV}.tar.gz
	"
	KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
fi

LICENSE="MIT"
SLOT="0/$(ver_cut 1)"
# Changes on every major release
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
)

src_unpack() {
	if [[ ${PV} = *9999* ]] ; then
		git-r3_src_unpack

		git-r3_fetch "${EGIT_DATA_REPO_URI}"
		git-r3_checkout "${EGIT_DATA_REPO_URI}" "${S}/data"
	else
		unpack "${P}.tar.gz"

		cd "${S}"/data || die
		mv README README.DATA || die

		unpack "${PN}-data-${PROJ_DATA_PV}.tar.gz"
	fi
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
	CMAKE_SKIP_TESTS=(
		# proj_test_cpp_api: https://lists.osgeo.org/pipermail/proj/2019-September/008836.html
		# testprojinfo: Also related to map data?
		"proj_test_cpp_api"
		"testprojinfo"
	)

	cmake_src_test
}

src_install() {
	cmake_src_install

	cd data || die
	dodoc README.DATA

	find "${ED}" -name '*.la' -type f -delete || die
}
