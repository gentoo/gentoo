# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )

inherit distutils-r1

DESCRIPTION="Patch ssl.match_hostname for Unicode(idna) domains support"
HOMEPAGE="https://github.com/aio-libs/idna-ssl https://pypi.org/project/idna_ssl/"
SRC_URI="
	https://github.com/aio-libs/idna-ssl/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="amd64 ~arm ~arm64 ~ia64 x86"
IUSE=""

RDEPEND="dev-python/idna[${PYTHON_USEDEP}]"
BDEPEND="
	test? ( dev-python/aiohttp[${PYTHON_USEDEP}] )"

src_prepare() {
	sed -e 's:--no-cov-on-fail --cov=idna_ssl --cov-report=term --cov-report=html::' \
		-i setup.cfg || die
	sed -e 's:test_aiohttp:_&:' -i tests/test_base.py || die
	distutils-r1_src_prepare
}

distutils_enable_tests pytest
