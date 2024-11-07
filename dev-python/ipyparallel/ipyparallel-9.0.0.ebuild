# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( pypy3 python3_{10..13} )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1 optfeature pypi

DESCRIPTION="Interactive Parallel Computing with IPython"
HOMEPAGE="
	https://ipyparallel.readthedocs.io/
	https://github.com/ipython/ipyparallel/
	https://pypi.org/project/ipyparallel/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="
	dev-python/decorator[${PYTHON_USEDEP}]
	>=dev-python/pyzmq-25[${PYTHON_USEDEP}]
	>=dev-python/traitlets-5[${PYTHON_USEDEP}]
	>=dev-python/ipython-5[${PYTHON_USEDEP}]
	>=dev-python/jupyter-client-7[${PYTHON_USEDEP}]
	dev-python/jupyter-server[${PYTHON_USEDEP}]
	>=dev-python/ipykernel-6.9.1[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.1[${PYTHON_USEDEP}]
	dev-python/tqdm[${PYTHON_USEDEP}]
	>=dev-python/tornado-6.1[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/flit-core[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		dev-python/pytest-tornado[${PYTHON_USEDEP}]
		dev-python/testpath[${PYTHON_USEDEP}]
	)
"

# TODO: package myst_parser
# distutils_enable_sphinx docs/source
distutils_enable_tests pytest

src_configure() {
	export IPP_DISABLE_JS=1
}

python_test() {
	local EPYTEST_DESELECT=(
		# we don't run a mongo instance for tests
		ipyparallel/tests/test_mongodb.py::TestMongoBackend
		# TODO
		ipyparallel/tests/test_util.py::test_disambiguate_ip
		# Gets upset that a timeout _doesn't_ occur, presumably because
		# we're cranking up too many test timeouts. Oh well.
		# bug #823458#c3
		ipyparallel/tests/test_asyncresult.py::AsyncResultTest::test_wait_for_send
		# We could patch the timeout for these too but they're going to be inherently
		# fragile anyway based on what they do.
		ipyparallel/tests/test_client.py::TestClient::test_activate
		ipyparallel/tests/test_client.py::TestClient::test_lazy_all_targets
		ipyparallel/tests/test_client.py::TestClient::test_wait_for_engines
	)
	case ${EPYTHON} in
		pypy3)
			EPYTEST_DESELECT+=(
				# pure Python datetime incompatibility?  TODO
				ipyparallel/tests/test_asyncresult.py::TestAsyncResult::test_elapsed_multi
			)
			;;
	esac

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -p asyncio -p tornado
}

python_install_all() {
	distutils-r1_python_install_all
	# move /usr/etc stuff to /etc
	mv "${ED}/usr/etc" "${ED}/etc" || die
}

pkg_postinst() {
	optfeature "Jupyter Notebook integration" dev-python/notebook
}
