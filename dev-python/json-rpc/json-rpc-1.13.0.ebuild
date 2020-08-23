# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_6 python3_7 python3_8 )

inherit distutils-r1

DESCRIPTION="JSON-RPC transport implementation for python"
HOMEPAGE="https://github.com/pavlov99/json-rpc"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-python/six[${PYTHON_USEDEP}]"

BDEPEND="${RDEPEND}
	test? ( dev-python/flask[${PYTHON_USEDEP}] )
"

distutils_enable_tests pytest
