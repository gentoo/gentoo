# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
inherit distutils-r1 toolchain-funcs pypi

DESCRIPTION="Fast C based HTML 5 parsing for python"
HOMEPAGE="https://github.com/kovidgoyal/html5-parser/"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm x86"

BDEPEND="
	virtual/pkgconfig
"
DEPEND="dev-libs/libxml2:="
RDEPEND="${DEPEND}
	dev-python/chardet[${PYTHON_USEDEP}]
	>=dev-python/lxml-3.8.0[${PYTHON_USEDEP}]"

distutils_enable_tests setup.py

src_prepare() {
	# Soup is not used when lxml is available.
	rm test/soup.py || die
	sed -i -e 's:-O3::' setup.py build.py || die
	distutils-r1_src_prepare
}

src_configure() {
	export PKGCONFIG_EXE=$(tc-getPKG_CONFIG)
}
