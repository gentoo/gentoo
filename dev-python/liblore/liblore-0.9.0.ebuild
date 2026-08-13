# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1

DESCRIPTION="Shared library for public-inbox / lore.kernel.org access"
HOMEPAGE="
	https://pypi.org/project/liblore/
	https://git.kernel.org/pub/scm/utils/liblore/liblore.git
"
SRC_URI="https://git.kernel.org/pub/scm/utils/${PN}/${PN}.git/snapshot/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"

IUSE="auth test"

RDEPEND="
	>=dev-python/requests-2.34[${PYTHON_USEDEP}]
	auth? ( >=dev-python/authheaders-0.16.3[${PYTHON_USEDEP}] )
"

BDEPEND="
	test? (
		dev-python/responses[${PYTHON_USEDEP}]
		dev-python/authheaders[${PYTHON_USEDEP}]
)
"

EPYTEST_PLUGINS=( pytest-asyncio )
distutils_enable_tests pytest
