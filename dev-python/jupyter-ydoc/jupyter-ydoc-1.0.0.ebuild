# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

MY_P=${PN/-/_}-${PV}
DESCRIPTION="Document structures for collaborative editing using Ypy"
HOMEPAGE="
	https://jupyter.org/
	https://github.com/jupyter-server/jupyter_ydoc/
	https://pypi.org/project/jupyter-ydoc/
"
SRC_URI="
	https://github.com/jupyter-server/jupyter_ydoc/archive/v${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# Requires node
RESTRICT="test"

RDEPEND="
	>=dev-python/y-py-0.6.0[${PYTHON_USEDEP}]
	<dev-python/y-py-0.7.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		>=dev-python/websockets-10.0[${PYTHON_USEDEP}]
		<dev-python/ypy-websocket-0.9.0[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}/${P}-no-node-for-version.patch"
)

distutils_enable_tests pytest
# Hangs for some reason
#distutils_enable_sphinx docs/source dev-python/myst-parser dev-python/pydata-sphinx-theme
