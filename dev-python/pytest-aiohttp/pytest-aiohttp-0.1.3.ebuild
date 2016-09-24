# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python3_4 python3_5 )
inherit distutils-r1

DESCRIPTION="pytest plugin for aiohttp support"
HOMEPAGE="https://github.com/aio-libs/pytest-aiohttp/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

CDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
DEPEND="${CDEPEND}"
RDEPEND="
	${CDEPEND}
	dev-python/pytest[${PYTHON_USEDEP}]
	>=dev-python/aiohttp-0.22.0[${PYTHON_USEDEP}]
"
