# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

DESCRIPTION="A Python 2 and 3 asynchronous JSON RPC server "
HOMEPAGE="https://github.com/palantir/python-jsonrpc-server"
SRC_URI="https://github.com/palantir/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="examples"

DEPEND="dev-python/future[${PYTHON_USEDEP}]
	dev-python/ujson[${PYTHON_USEDEP}]"

python_install_all() {
	if use examples; then
		insinto /usr/share/${PN}
		doins -r examples
	fi
	distutils-r1_python_install_all
}
