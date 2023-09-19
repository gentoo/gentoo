# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{9..11} )
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
KEYWORDS="~amd64 ~x86"

distutils_enable_tests unittest

# AttributeError: 'str' object has no attribute 'supported'
#distutils_enable_sphinx docs dev-python/m2r
