# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="A complete yet simple CSS parser for Python"
HOMEPAGE="
	https://github.com/Kozea/tinycss/
	https://pypi.org/project/tinycss/
	https://tinycss.readthedocs.io/en/latest/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	dev-python/lxml[${PYTHON_USEDEP}]
"

DOCS=( CHANGES README.rst )

distutils_enable_tests pytest
distutils_enable_sphinx docs

python_prepare_all() {
	rm setup.cfg || die
	distutils-r1_python_prepare_all
}

python_test() {
	export TINYCSS_SKIP_SPEEDUPS_TESTS=1
	epytest ${PN}/tests/test_*.py
}
