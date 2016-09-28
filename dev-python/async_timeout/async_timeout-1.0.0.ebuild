# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6
PYTHON_COMPAT=( python3_{4,5} )

inherit distutils-r1

DESCRIPTION="Timeout context manager for asyncio programs"
HOMEPAGE="https://github.com/aio-libs/async_timeout/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
# tests introduce a circular dependency on aiohttp
RESTRICT="test"

DEPEND="dev-python/pytest-runner[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/setuptools_scm[${PYTHON_USEDEP}]"

python_test() {
	esetup.py test || die
}
