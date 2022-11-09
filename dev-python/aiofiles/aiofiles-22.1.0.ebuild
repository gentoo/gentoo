# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="File support for asyncio"
HOMEPAGE="
	https://github.com/Tinche/aiofiles/
	https://pypi.org/project/aiofiles/
"
SRC_URI="
	https://github.com/Tinche/aiofiles/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="
	test? (
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
