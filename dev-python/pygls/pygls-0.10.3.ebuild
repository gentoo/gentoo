# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="A pythonic generic language server"
HOMEPAGE="https://github.com/openlawlibrary/pygls"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/pydantic-1.7[${PYTHON_USEDEP}]
	<dev-python/pydantic-1.9[${PYTHON_USEDEP}]
	>=dev-python/typeguard-2.10.0[${PYTHON_USEDEP}]
	<dev-python/typeguard-3[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		${RDEPEND}
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
