# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python3_{5,6,7} )
PYTHON_REQ_USE="xml(+)"

inherit distutils-r1

DESCRIPTION="A wrapper around the mediainfo library"
HOMEPAGE="https://github.com/sbraz/pymediainfo"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	media-libs/libmediainfo
"
BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	doc? (
		dev-python/alabaster[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
	)
	test? (
		${RDEPEND}
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"

python_compile_all() {
	if use doc; then
		sphinx-build docs docs/_build/html || die
		HTML_DOCS=( docs/_build/html/. )
	fi
}

python_test() {
	# Skip a test which requires network access
	pytest -vv tests/test_pymediainfo.py -k "not MediaInfoURLTest" \
		|| die "tests failed with ${EPYTHON}"
}
