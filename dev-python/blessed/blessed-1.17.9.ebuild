# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python3_{6,7,8,9} )

inherit distutils-r1

DESCRIPTION="Library for making terminal apps using colors, keyboard input and positioning"
HOMEPAGE="https://github.com/jquast/blessed"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/wcwidth[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		${RDEPEND}
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx docs dev-python/sphinx_rtd_theme

python_prepare_all() {
	# Skip those extensions as they don't have a Gentoo package
	# Remove calls to scripts that generate rst files because they
	# are not present in the tarball
	sed -e '/sphinxcontrib.manpage/d' -e '/sphinx_paramlinks/d' \
		-e '/^for script in/,/runpy.run_path/d' \
		-i docs/conf.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	# COLORTERM must not be truecolor
	# See https://github.com/jquast/blessed/issues/162
	# Ignore coverage options
	COLORTERM= pytest -vv --override-ini="addopts=" \
		|| die "tests failed with ${EPYTHON}"
}
