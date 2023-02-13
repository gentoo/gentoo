# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Document structures for collaborative editing using Ypy"
HOMEPAGE="
	https://jupyter.org/
	https://github.com/jupyter-server/jupyter_ydoc/
	https://pypi.org/project/jupyter-ydoc/
"
SRC_URI="https://github.com/jupyter-server/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

# Requires node
RESTRICT="test"

RDEPEND="
	<dev-python/y-py-0.6.0[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		>=dev-python/importlib_metadata-4.8.3[${PYTHON_USEDEP}]
	' 3.8 3.9)
"
BDEPEND="
	test? (
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		dev-python/websockets[${PYTHON_USEDEP}]
		dev-python/ypy-websocket[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
# Hangs for some reason
#distutils_enable_sphinx docs/source dev-python/myst_parser dev-python/pydata-sphinx-theme
