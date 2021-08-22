# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} pypy3 )
inherit distutils-r1

DESCRIPTION="jinja2 template renderer for aiohttp.web"
HOMEPAGE="https://github.com/aio-libs/aiohttp-jinja2"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-python/aiohttp-2.3.9[${PYTHON_USEDEP}]
	>=dev-python/jinja-3[${PYTHON_USEDEP}]
"
BDEPEND="
	test? ( >=dev-python/pytest-aiohttp-0.3.0[${PYTHON_USEDEP}] )
"

DOCS=( README.rst )

distutils_enable_tests pytest
distutils_enable_sphinx docs dev-python/alabaster

src_prepare() {
	default

	sed -i \
		-e 's:--cov=aiohttp_jinja2 --cov-report xml --cov-report html --cov-report term::' \
		setup.cfg || die

	distutils-r1_src_prepare
}
