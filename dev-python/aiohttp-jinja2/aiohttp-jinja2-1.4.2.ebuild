# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit distutils-r1

DESCRIPTION="jinja2 template renderer for aiohttp.web"
HOMEPAGE="https://github.com/aio-libs/aiohttp-jinja2"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/aiohttp-2.3.9[${PYTHON_USEDEP}]
	>=dev-python/jinja-2.10[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
	doc? (
		>=dev-python/alabaster-0.6.2[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
	)
	test? ( >=dev-python/pytest-aiohttp-0.3.0[${PYTHON_USEDEP}] )
"

DOCS=( README.rst )

distutils_enable_tests pytest

src_prepare() {
	default

	sed -i \
		-e 's:--cov=aiohttp_jinja2 --cov-report xml --cov-report html --cov-report term::' \
		setup.cfg || die

	distutils-r1_src_prepare
}

python_compile_all() {
	use doc && emake -C docs html
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )

	distutils-r1_python_install_all
}
