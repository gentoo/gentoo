# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
inherit cmake python-single-r1

DESCRIPTION="C library for automatically solving Freecell and some other solitaire variants"
HOMEPAGE="https://fc-solve.shlomifish.org/"
SRC_URI="https://fc-solve.shlomifish.org/downloads/fc-solve/${P}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm64 x86"
IUSE="tcmalloc"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/pysol_cards[${PYTHON_MULTI_USEDEP}]
		dev-python/random2[${PYTHON_MULTI_USEDEP}]
		dev-python/six[${PYTHON_MULTI_USEDEP}]
	')
	tcmalloc? ( dev-util/google-perftools )
"
DEPEND="${RDEPEND}
	dev-perl/Path-Tiny
	dev-perl/Template-Toolkit
"

DOCS=( README.html )

PATCHES=( "${FILESDIR}/${P}-no-docs.patch" )

src_prepare() {
	python_fix_shebang board_gen
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_STATIC_LIBRARY=OFF
		-DFCS_BUILD_DOCS=OFF
		-DFCS_WITH_TEST_SUITE=OFF #requires unpackaged dependencies
		-DFCS_AVOID_TCMALLOC=$(usex !tcmalloc)
	)

	cmake_src_configure
}
