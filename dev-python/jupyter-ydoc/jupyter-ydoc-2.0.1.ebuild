# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{10..12} )

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
KEYWORDS="~amd64"

# Requires node
RESTRICT="test"

RDEPEND="dev-python/importlib-metadata[${PYTHON_USEDEP}]
	dev-python/pycrdt[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		>=dev-python/websockets-10.0[${PYTHON_USEDEP}]
		dev-python/pycrdt-websocket[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-1.0.2-no-node-for-version.patch"
)

distutils_enable_tests pytest
# Hangs for some reason
#distutils_enable_sphinx docs/source dev-python/myst-parser dev-python/pydata-sphinx-theme
