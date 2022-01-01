# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..9} )
inherit distutils-r1

DESCRIPTION="Distributed object middleware for Python (RPC)"
HOMEPAGE="https://pypi.org/project/Pyro4/
	https://github.com/irmen/Pyro4"
SRC_URI="mirror://pypi/${PN::1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 ppc x86"
IUSE="doc examples test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/serpent-1.27[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? (
		>=dev-python/cloudpickle-1.2.1[${PYTHON_USEDEP}]
		dev-python/dill[${PYTHON_USEDEP}]
		>=dev-python/msgpack-0.4.6[${PYTHON_USEDEP}]
	)"

python_prepare_all() {
	# Disable tests requiring network connection.
	rm tests/PyroTests/test_naming.py || die
	sed \
		-e "s/testStartNSfunc/_&/" \
		-i tests/PyroTests/test_naming2.py || die

	sed \
		-e "s/testBroadcast/_&/" \
		-e "s/testGetIP/_&/" \
		-i tests/PyroTests/test_socket.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	esetup.py test
}

python_install_all() {
	use doc && HTML_DOCS=( docs/. )
	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
	distutils-r1_python_install_all
}
