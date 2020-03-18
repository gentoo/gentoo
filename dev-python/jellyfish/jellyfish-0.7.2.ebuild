# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )
inherit distutils-r1

DESCRIPTION="Python module for doing approximate and phonetic matching of strings"
HOMEPAGE="https://github.com/jamesturk/jellyfish https://pypi.org/project/jellyfish/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/unicodecsv[${PYTHON_USEDEP}]
	)
"

python_compile_all() {
	if use doc; then
		esetup.py build_sphinx
		HTML_DOCS=( build/sphinx/html/. )
	fi
}

python_test() {
	cp -r testdata "${BUILD_DIR}" || die
	cd "${BUILD_DIR}" || die
	pytest -vv lib/jellyfish/test.py || die "tests failed with ${EPYTHON}"
}
