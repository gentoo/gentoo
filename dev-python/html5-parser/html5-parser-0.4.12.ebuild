# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi toolchain-funcs

DESCRIPTION="Fast C based HTML 5 parsing for python"
HOMEPAGE="
	https://github.com/kovidgoyal/html5-parser/
	https://pypi.org/project/html5-parser/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	dev-libs/libxml2:=
"
RDEPEND="
	${DEPEND}
	dev-python/chardet[${PYTHON_USEDEP}]
	>=dev-python/lxml-3.8.0[${PYTHON_USEDEP}]
"
BDEPEND="
	virtual/pkgconfig
	test? (
		${RDEPEND}
		dev-python/beautifulsoup4[${PYTHON_USEDEP}]
	)
"

src_configure() {
	export PKGCONFIG_EXE=$(tc-getPKG_CONFIG)
}

python_test() {
	"${EPYTHON}" run_tests.py || die
}
