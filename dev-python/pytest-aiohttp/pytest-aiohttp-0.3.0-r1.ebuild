# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="pytest plugin for aiohttp support"
HOMEPAGE="https://github.com/aio-libs/pytest-aiohttp/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ppc ppc64 ~riscv sparc x86 ~x64-macos"
IUSE=""

RDEPEND="
	>=dev-python/pytest-5.4[${PYTHON_USEDEP}]
	>=dev-python/aiohttp-0.22.0[${PYTHON_USEDEP}]
"
