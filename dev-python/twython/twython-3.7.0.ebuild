# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit distutils-r1

DESCRIPTION="An easy way to access Twitter data with Python"
HOMEPAGE="https://github.com/ryanmcgrath/twython"
SRC_URI="https://github.com/ryanmcgrath/twython/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="amd64 x86"

RDEPEND="
	>=dev-python/requests-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/requests-oauthlib-0.4.0[${PYTHON_USEDEP}]"
BDEPEND="test? ( dev-python/responses[${PYTHON_USEDEP}] )"

distutils_enable_tests unittest

src_prepare() {
	# tests are largely broken/outdated
	sed -e 's:test_get_lastfunction_header_should_return_header:_&:' \
		-e 's:test_request_should_handle_4:_&:' \
		-e 's:test_request_should_handle_rate_limit:_&:' \
		-i tests/test_core.py || die

	distutils-r1_src_prepare
}
