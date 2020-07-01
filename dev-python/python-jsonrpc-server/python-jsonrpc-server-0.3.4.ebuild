# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_7 )

inherit distutils-r1

DESCRIPTION="A Python 2 and 3 asynchronous JSON RPC server"
HOMEPAGE="https://github.com/palantir/python-jsonrpc-server"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="dev-python/versioneer[${PYTHON_USEDEP}]"

RDEPEND="~dev-python/ujson-1.35[${PYTHON_USEDEP}]"

DEPEND="test? (
	dev-python/mock[${PYTHON_USEDEP}]
	dev-python/pycodestyle[${PYTHON_USEDEP}]
	dev-python/pyflakes[${PYTHON_USEDEP}]
	dev-python/pylint[${PYTHON_USEDEP}]
)"

PATCHES=( "${FILESDIR}/${P}-remove-pytest-cov-dep.patch" )

distutils_enable_tests pytest
