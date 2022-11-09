# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Simple Python3 Supervisor library"
HOMEPAGE="https://github.com/jupyterhub/simpervisor"
SRC_URI="https://github.com/jupyterhub/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="test? (
	dev-python/pytest-asyncio[${PYTHON_USEDEP}]
	dev-python/aiohttp[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
