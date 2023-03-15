# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_PEP517="setuptools"

inherit distutils-r1 pypi

DESCRIPTION="Python library to control webOS-based LG TV devices"
HOMEPAGE="https://github.com/bendavid/aiopylgtv"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64"
RESTRICT="test" # No tests.

RDEPEND="
	>=dev-python/numpy-1.17.0[${PYTHON_USEDEP}]
	dev-python/sqlitedict[${PYTHON_USEDEP}]
	>=dev-python/websockets-8.1[${PYTHON_USEDEP}]
"
