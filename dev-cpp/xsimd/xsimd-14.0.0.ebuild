# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
inherit cmake python-any-r1

DESCRIPTION="C++ wrappers for SIMD intrinsics"
HOMEPAGE="https://github.com/xtensor-stack/xsimd"
SRC_URI="https://github.com/xtensor-stack/${PN}/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

BDEPEND="
	doc? (
		app-text/doxygen
		$(python_gen_any_dep '
			dev-python/breathe[${PYTHON_USEDEP}]
			dev-python/sphinx[${PYTHON_USEDEP}]
			dev-python/sphinx-rtd-theme[${PYTHON_USEDEP}]
		')
	)
	test? ( dev-cpp/doctest )"

PATCHES=(
	"${FILESDIR}"/${P}-c++17.patch
	"${FILESDIR}"/${P}-no-march.patch
)

python_check_deps() {
	python_has_version "dev-python/sphinx[${PYTHON_USEDEP}]" &&
		python_has_version "dev-python/sphinx-rtd-theme[${PYTHON_USEDEP}]" &&
		python_has_version "dev-python/breathe[${PYTHON_USEDEP}]"

}

pkg_setup() {
	use doc && python-any-r1_pkg_setup
}

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
	use doc && HTML_DOCS=( docs/build/html/* )
	cmake_src_install
}
