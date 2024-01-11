# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="C++ engine for simulating rigid bodies in 2D games"
HOMEPAGE="https://box2d.org/"
SRC_URI="https://github.com/erincatto/Box2D/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc64 ~riscv x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

DEPEND="test? ( dev-cpp/doctest )"
BDEPEND="doc? ( app-text/doxygen )"

src_prepare() {
	cmake_src_prepare

	# unbundle doctest
	rm unit-test/doctest.h || die
	ln -s "${ESYSROOT}"/usr/include/doctest/doctest.h unit-test/ || die
}

src_configure() {
	local mycmakeargs=(
		-DBOX2D_BUILD_TESTBED=OFF # bundled libs, broken anyway right now
		-DBOX2D_BUILD_UNIT_TESTS=$(usex test)
		-DBOX2D_BUILD_DOCS=$(usex doc)
	)
	cmake_src_configure
}

src_test() {
	"${BUILD_DIR}"/bin/unit_test || die
}
