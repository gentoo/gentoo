# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
PYTHON_REQ_USE="threads(+)"
inherit distutils-r1 optfeature

DESCRIPTION="Interactive Parallel Computing with IPython"
HOMEPAGE="https://ipyparallel.readthedocs.io/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ~ia64 ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	dev-python/entrypoints[${PYTHON_USEDEP}]
	dev-python/decorator[${PYTHON_USEDEP}]
	>=dev-python/pyzmq-18[${PYTHON_USEDEP}]
	>=dev-python/traitlets-4.3[${PYTHON_USEDEP}]
	>=dev-python/ipython-4[${PYTHON_USEDEP}]
	dev-python/jupyter_client[${PYTHON_USEDEP}]
	>=dev-python/ipykernel-4.4[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.1[${PYTHON_USEDEP}]
	dev-python/tqdm[${PYTHON_USEDEP}]
	>=www-servers/tornado-5.1[${PYTHON_USEDEP}]
	"
BDEPEND="${RDEPEND}
	test? (
		dev-python/ipython[test]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		dev-python/pytest-tornado[${PYTHON_USEDEP}]
		dev-python/testpath[${PYTHON_USEDEP}]
	)
	"

# TODO: package myst_parser
# distutils_enable_sphinx docs/source
distutils_enable_tests pytest

PATCHES=(
	"${FILESDIR}"/${PN}-7.1.0-test-timeouts.patch
)

python_test() {
	local deselect=(
		# we don't run a mongo instance for tests
		ipyparallel/tests/test_mongodb.py::TestMongoBackend
		# TODO
		ipyparallel/tests/test_util.py::test_disambiguate_ip
		ipyparallel/tests/test_view.py::TestView::test_temp_flags
		ipyparallel/tests/test_view.py::TestView::test_unicode_apply_arg
		ipyparallel/tests/test_view.py::TestView::test_unicode_apply_result
		ipyparallel/tests/test_view.py::TestView::test_unicode_execute
		ipyparallel/tests/test_view.py::TestView::test_sync_imports_quiet
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
	[[ ${EPYTHON} == python3.10 ]] && deselect+=(
		# failing due to irrelevant warnings
		ipyparallel/tests/test_client.py::TestClient::test_local_ip_true_doesnt_trigger_warning
		ipyparallel/tests/test_client.py::TestClient::test_warning_on_hostname_match
	)
	epytest ${deselect[@]/#/--deselect }
}

python_install_all() {
	distutils-r1_python_install_all
	# move /usr/etc stuff to /etc
	mv "${ED}/usr/etc" "${ED}/etc" || die
}

pkg_postinst() {
	optfeature "Jupyter Notebook integration" dev-python/notebook
}
