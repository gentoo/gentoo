# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_6 )
inherit cmake-utils python-single-r1

DESCRIPTION="C library for automatically solving Freecell and some other solitaire variants"
HOMEPAGE="https://fc-solve.shlomifish.org/"
SRC_URI="https://fc-solve.shlomifish.org/downloads/fc-solve/${P}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm64 x86"
IUSE=""

RDEPEND="${PYTHON_DEPS}
	dev-python/pysol_cards[${PYTHON_USEDEP}]
	dev-python/random2[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-perl/Path-Tiny
	dev-perl/Template-Toolkit
"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_prepare() {
	sed -i -e "s|share/doc/freecell-solver/|share/doc/${P}|" CMakeLists.txt || die

	python_fix_shebang board_gen

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_STATIC_LIBRARY=OFF
		-DFCS_BUILD_DOCS=OFF
		-DFCS_WITH_TEST_SUITE=OFF #requires unpackaged dependencies
	)

	cmake-utils_src_configure
}
