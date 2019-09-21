# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python{2_7,3_5} )

inherit distutils-r1

DESCRIPTION="A complete yet simple CSS parser for Python"
HOMEPAGE="https://github.com/SimonSapin/tinycss/
	https://tinycss.readthedocs.io/en/latest/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="dev-python/lxml[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"

DOCS=( CHANGES README.rst )

python_test() {
	export TINYCSS_SKIP_SPEEDUPS_TESTS=1
	local test
	for test in ${PN}/tests/test_*.py; do
		py.test $test
	done
}
