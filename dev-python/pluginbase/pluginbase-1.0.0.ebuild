# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="Support library for building plugins sytems in Python"
HOMEPAGE="https://github.com/mitsuhiko/pluginbase"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? (	dev-python/pytest[${PYTHON_USEDEP}] )
"

PATCHES="${FILESDIR}/${P}-python3.9.patch"

python_prepare_all() {
	sed -e "s/, 'sphinx.ext.intersphinx'//" \
		-i docs/conf.py || die
	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc; then
		emake -C docs html
		HTML_DOCS=( docs/_build/html/. )
	fi
}

python_test() {
	cd tests && PYTHONPATH=.. py.test --tb=native || die "Tests fail with ${EPYTHON}"
}
