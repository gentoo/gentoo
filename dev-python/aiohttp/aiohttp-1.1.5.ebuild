# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

PYTHON_COMPAT=( python3_4 python3_5 )

inherit distutils-r1 vcs-snapshot

DESCRIPTION="http client/server for asyncio"
HOMEPAGE="https://pypi.python.org/pypi/aiohttp"
SRC_URI="https://github.com/KeepSafe/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
EGIT_REPO_URI="https://github.com/KeepSafe/aiohttp"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"

CDEPEND="
	dev-python/async_timeout[${PYTHON_USEDEP}]
	dev-python/chardet[${PYTHON_USEDEP}]
	>=dev-python/multidict-2.0[${PYTHON_USEDEP}]
	dev-python/yarl[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/cython[${PYTHON_USEDEP}]
	doc? (
		>=dev-python/alabaster-0.6.2[${PYTHON_USEDEP}]
		dev-python/sphinxcontrib-asyncio[${PYTHON_USEDEP}]
		dev-python/sphinxcontrib-newsfeed[${PYTHON_USEDEP}]
		dev-python/sphinxcontrib-spelling[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
	)
	test? (
		${CDEPEND}
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		dev-python/pytest-timeout[${PYTHON_USEDEP}]
		www-servers/gunicorn[${PYTHON_USEDEP}]
	)
"
RDEPEND="${CDEPEND}"

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	PYTHONPATH="${PWD}:${PYTHONPATH}" ${PYTHON} -m pytest tests/ || die "Tests failed under ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )

	distutils-r1_python_install_all
}
