# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYPI_VERIFY_REPO=https://github.com/JWCook/requests-ratelimiter
DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Rate-limiting for the requests library"
HOMEPAGE="
	https://github.com/JWCook/requests-ratelimiter/
	https://pypi.org/project/requests-ratelimiter/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="
	<dev-python/pyrate-limiter-5[${PYTHON_USEDEP}]
	>=dev-python/pyrate-limiter-4.1[${PYTHON_USEDEP}]
	>=dev-python/requests-2.20[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		>=dev-python/requests-cache-1.2[${PYTHON_USEDEP}]
		>=dev-python/requests-mock-1.11[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=()
EPYTEST_XDIST=1
distutils_enable_tests pytest
