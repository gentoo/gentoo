# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} pypy3 )

inherit distutils-r1

DESCRIPTION="httplib2 caching for requests"
HOMEPAGE="
	https://pypi.org/project/CacheControl/
	https://github.com/ionrock/cachecontrol/
"
SRC_URI="
	https://github.com/ionrock/cachecontrol/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ppc ppc64 ~riscv ~sparc x86"

RDEPEND="
	>=dev-python/msgpack-0.5.2[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/cherrypy[${PYTHON_USEDEP}]
		dev-python/lockfile[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
