# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python3_{8..10} )
PYTHON_REQ_USE="sqlite?"

inherit distutils-r1 multiprocessing optfeature

MY_PN="SQLAlchemy"
MY_P="${MY_PN}-${PV/_beta/b}"

DESCRIPTION="Python SQL toolkit and Object Relational Mapper"
HOMEPAGE="https://www.sqlalchemy.org/ https://pypi.org/project/SQLAlchemy/"
SRC_URI="mirror://pypi/${MY_P:0:1}/${MY_PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="examples +sqlite test"

# Use pytest-xdist to speed up tests
BDEPEND="
	test? (
		$(python_gen_impl_dep sqlite)
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_prepare() {
	# remove optional/partial dep on greenlet, greenlet is not very portable
	sed -i -e '/greenlet/d' setup.cfg || die

	distutils-r1_src_prepare
}

python_test() {
	local deselect=()
	if [[ ${EPYTHON} != pypy3 ]] &&
			! has_version -b "dev-python/greenlet[${PYTHON_USEDEP}]"
	then
		# skip tests requiring greenlet
		deselect+=(
			test/base/test_concurrency_py3k.py::TestAsyncAdaptedQueue::test_lazy_init
			test/base/test_concurrency_py3k.py::TestAsyncioCompat::test_async_error
			test/base/test_concurrency_py3k.py::TestAsyncioCompat::test_await_fallback_error
			test/base/test_concurrency_py3k.py::TestAsyncioCompat::test_await_only_error
			test/base/test_concurrency_py3k.py::TestAsyncioCompat::test_await_only_no_greenlet
			test/base/test_concurrency_py3k.py::TestAsyncioCompat::test_contextvars
			test/base/test_concurrency_py3k.py::TestAsyncioCompat::test_ok
			test/base/test_concurrency_py3k.py::TestAsyncioCompat::test_propagate_cancelled
			test/base/test_concurrency_py3k.py::TestAsyncioCompat::test_require_await
			test/base/test_concurrency_py3k.py::TestAsyncioCompat::test_sync_error
			test/ext/asyncio/test_engine_py3k.py::TextSyncDBAPI::test_sync_driver_execution
			test/ext/asyncio/test_engine_py3k.py::TextSyncDBAPI::test_sync_driver_run_sync
			test/base/test_concurrency_py3k.py::TestAsyncAdaptedQueue::test_error_other_loop
			test/engine/test_pool.py::PoolEventsTest::test_checkin_event_gc[True-_exclusions0]
			test/engine/test_pool.py::QueuePoolTest::test_userspace_disconnectionerror_weakref_finalizer[True-_exclusions0]
		)
	fi

	# Disable tests hardcoding function call counts specific to Python versions.
	epytest --ignore test/aaa_profiling ${deselect[@]/#/--deselect } \
		-n "$(makeopts_jobs "${MAKEOPTS}" "$(get_nproc)")"
}

python_install_all() {
	if use examples; then
		docompress -x "/usr/share/doc/${PF}/examples"
		dodoc -r examples
	fi

	distutils-r1_python_install_all
}

pkg_postinst() {
	optfeature "MySQL support" dev-python/mysqlclient dev-python/pymysql \
		dev-python/mysql-connector-python
	optfeature "mssql support" dev-python/pymssql
	optfeature "postgresql support" dev-python/psycopg:2
}
