# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Traceback fiddling library for Python"
HOMEPAGE="https://github.com/ionelmc/python-tblib"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ia64 ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"

RDEPEND="dev-python/six[${PYTHON_USEDEP}]"
BDEPEND="test? ( dev-python/twisted[${PYTHON_USEDEP}] )"

distutils_enable_tests pytest
