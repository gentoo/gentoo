# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{4,5} pypy )

inherit distutils-r1

MY_PN="Pyro4"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Distributed object middleware for Python (RPC)"
HOMEPAGE="https://pypi.org/project/Pyro4
	https://github.com/irmen/Pyro4"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="4"
KEYWORDS="amd64 ~arm64 ppc x86 ~amd64-linux ~x86-linux"
IUSE="doc examples test"

RDEPEND="
	!dev-python/pyro:0
	>=dev-python/serpent-1.11[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/coverage[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
	)"

S="${WORKDIR}/${MY_P}"
DISTUTILS_IN_SOURCE_BUILD=1

python_prepare_all() {
	sed \
		-e '/sys.path.insert/a sys.path.insert(1,"PyroTests")' \
		-i tests/run_testsuite.py || die

	# Disable tests requiring network connection.
	sed \
		-e "s/testBCstart/_&/" \
		-e "s/testDaemonPyroObj/_&/" \
		-e "s/testLookupAndRegister/_&/" \
		-e "s/testMulti/_&/" \
		-e "s/testRefuseDottedNames/_&/" \
		-e "s/testResolve/_&/" \
		-e "s/testBCLookup/_&/" \
		-i tests/PyroTests/test_naming.py || die
	sed \
		-e "s/testOwnloopBasics/_&/" \
		-e "s/testStartNSfunc/_&/" \
		-i tests/PyroTests/test_naming2.py || die

	sed \
		-e "s/testServerConnections/_&/" \
	    -e "s/testServerParallelism/_&/" \
		-i tests/PyroTests/test_server.py || die

	sed \
		-e "s/testBroadcast/_&/" \
		-e "s/testGetIP/_&/" \
		-e "s/testGetIpVersion[46]/_&/" \
		-i tests/PyroTests/test_socket.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	cd "${S}"/tests || die
	${PYTHON} -E run_testsuite.py || die
}

python_install_all() {
	use doc && HTML_DOCS=( docs/. )
	use examples && local EXAMPLES=( examples/. )
	distutils-r1_python_install_all
}
