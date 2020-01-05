# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 python3_{6,7} )

inherit distutils-r1

MY_PN="Pyro4"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Distributed object middleware for Python (RPC)"
HOMEPAGE="https://pypi.org/project/Pyro4/
	https://github.com/irmen/Pyro4"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="4"
KEYWORDS="amd64 ~arm64 ppc x86"
IUSE="doc examples test"
RESTRICT="!test? ( test )"

RDEPEND="
	!dev-python/pyro:0
	$(python_gen_cond_dep \
		'dev-python/selectors34[${PYTHON_USEDEP}]' -2)
	>=dev-python/serpent-1.27[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		>=dev-python/cloudpickle-1.2.1[${PYTHON_USEDEP}]
		dev-python/dill[${PYTHON_USEDEP}]
		>=dev-python/msgpack-0.4.6[${PYTHON_USEDEP}]
	)"

S="${WORKDIR}/${MY_P}"

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
