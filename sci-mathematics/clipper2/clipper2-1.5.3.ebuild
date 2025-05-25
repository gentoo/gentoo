# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="Clipper2"
MY_P=${MY_PN}_${PV}

inherit cmake flag-o-matic

DESCRIPTION="Polygon Clipping and Offsetting"
HOMEPAGE="https://www.angusj.com/clipper2/Docs/Overview.htm"
SRC_URI="https://github.com/AngusJohnson/Clipper2/archive/refs/tags/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${MY_P}/CPP"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	test? ( dev-cpp/gtest )
"

src_prepare() {
	cmake_src_prepare

	#943720
	sed -e 's/ -Werror//g' -i CMakeLists.txt || die
}

src_configure() {
	append-flags -fno-strict-aliasing
	filter-lto

	local mycmakeargs=(
		-DCLIPPER2_UTILS="no"
		-DCLIPPER2_EXAMPLES="no"
		-DCLIPPER2_TESTS="$(usex test)"
		-DCLIPPER2_USINGZ="no"  # manifold src/third_party/CMakeLists.txt

		-DUSE_EXTERNAL_GTEST="yes"
	)
	cmake_src_configure
}
