# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{5,6,7} )
DISTUTILS_IN_SOURCE_BUILD=1
inherit distutils-r1

DESCRIPTION="Python module for doing approximate and phonetic matching of strings"
HOMEPAGE="https://github.com/jamesturk/jellyfish https://pypi.org/project/jellyfish/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? (
		dev-python/pytest-runner[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/unicodecsv[${PYTHON_USEDEP}]
	)
"

python_compile() {
	esetup.py build_ext --inplace
	esetup.py build
}

python_compile_all() {
	if use doc; then
		esetup.py build_sphinx
		HTML_DOCS=( build/sphinx/html/. )
	fi
}

python_test() {
	py.test jellyfish/test.py || die "tests failed with ${EPYTHON}"
}
