# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry-core
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1

DESCRIPTION="Make multi-threaded pytest test cases fail when they should"
HOMEPAGE="
	https://github.com/bjoluc/pytest-reraise/
	https://pypi.org/project/pytest-reraise/
"
# no tests in pypi sdist, v2.1.2
SRC_URI="
	https://github.com/bjoluc/pytest-reraise/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-python/pytest-4.6[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=( "${PN}" )
EPYTEST_PLUGIN_LOAD_VIA_ENV=1
distutils_enable_tests pytest
