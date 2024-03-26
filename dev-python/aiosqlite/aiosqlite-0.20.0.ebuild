# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{10..12} )
PYTHON_REQ_USE="sqlite"

inherit distutils-r1 pypi

DESCRIPTION="asyncio bridge to the standard sqlite3 module"
HOMEPAGE="
	https://aiosqlite.omnilib.dev
	https://pypi.org/project/aiosqlite/
	https://github.com/omnilib/aiosqlite
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	>=dev-python/typing-extensions-4[${PYTHON_USEDEP}]
"

distutils_enable_tests unittest

# AttributeError: 'str' object has no attribute 'supported'
#distutils_enable_sphinx docs dev-python/m2r
