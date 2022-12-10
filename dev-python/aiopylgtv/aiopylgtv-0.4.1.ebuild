# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Python library to control webOS-based LG TV devices"
HOMEPAGE="https://github.com/bendavid/aiopylgtv"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64"
RESTRICT="test" # No tests.

RDEPEND="
	>=dev-python/numpy-1.17.0[${PYTHON_USEDEP}]
	dev-python/sqlitedict[${PYTHON_USEDEP}]
	>=dev-python/websockets-8.1[${PYTHON_USEDEP}]
"
