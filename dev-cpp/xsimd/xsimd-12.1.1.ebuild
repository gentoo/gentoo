# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="C++ wrappers for SIMD intrinsics"
HOMEPAGE="https://github.com/xtensor-stack/xsimd"
SRC_URI="https://github.com/xtensor-stack/${PN}/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

BDEPEND="
	doc? (
		app-doc/doxygen
		dev-python/breathe
		dev-python/sphinx
		dev-python/sphinx-rtd-theme
	)
	test? ( dev-cpp/doctest )"

PATCHES=(
	"${FILESDIR}"/${PN}-11.1.0-c++17.patch
	"${FILESDIR}"/${P}-no-march.patch
)

src_prepare() {
	sed -i \
		-e '/fPIC/d' \
		test/CMakeLists.txt \
		|| die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTS=$(usex test)
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	use doc && emake -C docs html
}

src_install() {
	cmake_src_install
	if use doc; then
		dodoc -r docs/build/html
	fi
}
