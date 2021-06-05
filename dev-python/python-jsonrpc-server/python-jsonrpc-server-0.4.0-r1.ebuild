# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} )

inherit distutils-r1

DESCRIPTION="A Python 2 and 3 asynchronous JSON RPC server"
HOMEPAGE="https://github.com/palantir/python-jsonrpc-server"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"

BDEPEND="dev-python/versioneer[${PYTHON_USEDEP}]
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pycodestyle[${PYTHON_USEDEP}]
)"

RDEPEND=">=dev-python/ujson-3[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

PATCHES=( "${FILESDIR}/${PN}-0.4.0-fix-test-with-ujson-3-and-up.patch" )

python_prepare_all() {
	# Remove pytest-cov dep
	sed -i -e '0,/addopts/I!d' setup.cfg || die

	distutils-r1_python_prepare_all
}
