# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8,9,10} )
inherit distutils-r1

DESCRIPTION="Async JSON-RPC 2.0 protocol + server powered by asyncio"
HOMEPAGE="https://github.com/pavlov99/ajsonrpc"
#SRC_URI="https://github.com/pavlov99/ajsonrpc/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

distutils_enable_tests pytest
