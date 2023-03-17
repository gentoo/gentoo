# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{9..10} pypy3 )
inherit distutils-r1 pypi

DESCRIPTION="jinja2 template renderer for aiohttp.web"
HOMEPAGE="https://github.com/aio-libs/aiohttp-jinja2"

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
