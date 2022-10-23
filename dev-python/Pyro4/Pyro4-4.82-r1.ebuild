# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Distributed object middleware for Python (RPC)"
HOMEPAGE="
	https://github.com/irmen/Pyro4/
	https://pypi.org/project/Pyro4/
"
SRC_URI="mirror://pypi/${PN::1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 ppc x86"
IUSE="doc examples"

RDEPEND="
	>=dev-python/serpent-1.27[${PYTHON_USEDEP}]
"
DEPEND="
	test? (
		>=dev-python/cloudpickle-1.2.1[${PYTHON_USEDEP}]
		>=dev-python/dill-0.2.6[${PYTHON_USEDEP}]
		>=dev-python/msgpack-0.5.2[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# network
		tests/PyroTests/test_naming.py
		tests/PyroTests/test_naming2.py::OfflineNameServerTests::testStartNSfunc
		tests/PyroTests/test_naming2.py::OfflineNameServerTestsDbmStorage::testStartNSfunc
		tests/PyroTests/test_naming2.py::OfflineNameServerTestsSqlStorage::testStartNSfunc
		tests/PyroTests/test_serialize.py::SerializeTests_dill::testSerCoreOffline
		tests/PyroTests/test_serialize.py::SerializeTests_dill::testSerializeDumpsAndDumpsCall
		tests/PyroTests/test_socket.py::TestSocketutil::testBroadcast
		tests/PyroTests/test_socket.py::TestSocketutil::testGetIP
	)

	cd tests/PyroTests || die
	epytest
}

python_install_all() {
	use doc && HTML_DOCS=( docs/. )
	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
	distutils-r1_python_install_all
}
