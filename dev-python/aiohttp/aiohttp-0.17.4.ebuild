# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python3_3 python3_4 )

inherit distutils-r1

DESCRIPTION="http client/server for asyncio"
HOMEPAGE="https://github.com/KeepSafe/aiohttp https://pypi.python.org/pypi/aiohttp"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples test"

CDEPEND="
	dev-python/chardet[${PYTHON_USEDEP}]
	virtual/python-asyncio[${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'dev-python/enum34[${PYTHON_USEDEP}]' 'python3_3')
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/cython[${PYTHON_USEDEP}]
	doc? (
		>=dev-python/alabaster-0.6.2[${PYTHON_USEDEP}]
		dev-python/sphinxcontrib-newsfeed[${PYTHON_USEDEP}]
		dev-python/sphinxcontrib-spelling[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
	)
	test? (
		${CDEPEND}
		dev-python/nose[${PYTHON_USEDEP}]
		www-servers/gunicorn[${PYTHON_USEDEP}]
	)
"
RDEPEND="${CDEPEND}"

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	PYTHONPATH="$(PWD):${PYTHONPATH}" nosetests tests/ || die "Tests failed under ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	use examples && local EXAMPLES=( examples/. )

	distutils-r1_python_install_all
}
