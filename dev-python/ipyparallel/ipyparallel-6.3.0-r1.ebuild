# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
PYTHON_REQ_USE="threads(+)"
inherit distutils-r1 optfeature

DESCRIPTION="Interactive Parallel Computing with IPython"
HOMEPAGE="https://ipyparallel.readthedocs.io/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 hppa ~ppc ~ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux ~x86-linux"

# About tests and tornado
# Upstreams claims to work fine with tornado 5, and it's indeed possible to
# launch a cluster with tornado 5 installed, but tests definitely don't run with
# tornado 5 installed. Upstreams CI runs with tornado 4. This is why we limit
# ourselves to <tornado-5 when running tests.

RDEPEND="
	dev-python/decorator[${PYTHON_USEDEP}]
	dev-python/ipykernel[${PYTHON_USEDEP}]
	dev-python/ipython[${PYTHON_USEDEP}]
	dev-python/ipython_genutils[${PYTHON_USEDEP}]
	dev-python/jupyter_client[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	>=dev-python/pyzmq-14.4.0[${PYTHON_USEDEP}]
	www-servers/tornado[${PYTHON_USEDEP}]
	"
BDEPEND="${RDEPEND}
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? (
		dev-python/ipython[test]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/testpath[${PYTHON_USEDEP}]
	)
	"

distutils_enable_sphinx docs/source
distutils_enable_tests pytest

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
	)
	[[ ${EPYTHON} == python3.10 ]] && deselect+=(
		# failing due to irrelevant warnings
		ipyparallel/tests/test_client.py::TestClient::test_local_ip_true_doesnt_trigger_warning
		ipyparallel/tests/test_client.py::TestClient::test_warning_on_hostname_match
	)
	epytest ${deselect[@]/#/--deselect }
}

pkg_postinst() {
	optfeature "Jupyter Notebook integration" dev-python/notebook
}
