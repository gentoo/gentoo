# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit distutils-r1

DESCRIPTION="A Python 2 and 3 asynchronous JSON RPC server"
HOMEPAGE="https://github.com/palantir/python-jsonrpc-server"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

BDEPEND="dev-python/versioneer[${PYTHON_USEDEP}]
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pycodestyle[${PYTHON_USEDEP}]
)"

RDEPEND="~dev-python/ujson-1.35[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

python_prepare_all() {
	# Remove pytest-cov dep
	sed -i -e '0,/addopts/I!d' setup.cfg || die

	# jsonrpc-server does not actually work with ujson>3.0.0: tests fail
	sed -i -e 's/ujson>=3.0.0/ujson==1.35/g' setup.py || die
	sed -i -e 's/ujson>=3.0.0/ujson==1.35/g' python_jsonrpc_server.egg-info/requires.txt || die

	distutils-r1_python_prepare_all
}
