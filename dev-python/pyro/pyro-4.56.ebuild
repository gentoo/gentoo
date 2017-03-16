# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{3,4,5,6} pypy )

inherit distutils-r1

MY_PN="Pyro4"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Distributed object middleware for Python (RPC)"
HOMEPAGE="http://www.xs4all.nl/~irmen/pyro/ https://pypi.python.org/pypi/Pyro4 https://github.com/irmen/Pyro4"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="4"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="doc examples test"

RDEPEND="
	!dev-python/pyro:0
	$(python_gen_cond_dep \
		'dev-python/selectors34[${PYTHON_USEDEP}]' python{2_7,3_3})
	>=dev-python/serpent-1.11[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/coverage[${PYTHON_USEDEP}]
		dev-python/dill[${PYTHON_USEDEP}]
		>=dev-python/msgpack-0.4.6[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
	)"

S="${WORKDIR}/${MY_P}"

python_prepare_all() {
	sed \
		-e '/sys.path.insert/a sys.path.insert(1,"PyroTests")' \
		-i tests/run_testsuite.py || die

	# Disable tests requiring network connection.
	rm tests/PyroTests/test_naming.py || die
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
	pushd "${S}"/tests >/dev/null || die
	PYTHONPATH=../src ${PYTHON} run_testsuite.py || die
	popd >/dev/null || die
}

python_install_all() {
	use doc && HTML_DOCS=( docs/. )
	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
	distutils-r1_python_install_all
}
