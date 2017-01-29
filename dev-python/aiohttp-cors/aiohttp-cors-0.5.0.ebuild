# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python3_4 )

inherit distutils-r1

DESCRIPTION="Implements CORS support for aiohttp asyncio-powered asynchronous HTTP server"
HOMEPAGE="https://github.com/aio-libs/aiohttp-cors"
SRC_URI="https://github.com/aio-libs/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
EGIT_REPO_URI="https://github.com/aio-libs/aiohttp-cors"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"

DEPEND=">=dev-python/aiohttp-1.1.1[${PYTHON_USEDEP}]
		dev-python/pip[${PYTHON_USEDEP}]
		dev-python/setuptools[${PYTHON_USEDEP}]"
