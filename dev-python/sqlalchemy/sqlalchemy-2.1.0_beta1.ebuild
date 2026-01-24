# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYPI_PN=SQLAlchemy
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )
PYTHON_REQ_USE="sqlite?"

inherit distutils-r1 optfeature pypi

DESCRIPTION="Python SQL toolkit and Object Relational Mapper"
HOMEPAGE="
	https://www.sqlalchemy.org/
	https://pypi.org/project/SQLAlchemy/
	https://github.com/sqlalchemy/sqlalchemy/
"

LICENSE="MIT"
SLOT="0"
if [[ ${PV} != *_beta* ]]; then
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos ~x64-solaris"
fi
IUSE="examples +sqlite test"

RDEPEND="
	>=dev-python/typing-extensions-4.6.0[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	test? (
		$(python_gen_impl_dep sqlite)
	)
"

EPYTEST_PLUGINS=()
EPYTEST_RERUNS=5
EPYTEST_XDIST=1
distutils_enable_tests pytest

src_prepare() {
	sed -i -e '/greenlet/d' setup.cfg || die
	distutils-r1_src_prepare
}

python_test() {
	local EPYTEST_IGNORE=(
		test/ext/mypy/test_mypy_plugin_py3k.py
		test/typing/test_mypy.py
		# hardcode call counts specific to Python versions
		test/aaa_profiling
	)
	local EPYTEST_DESELECT=(
		# warning tests are unreliable
		test/base/test_warnings.py
		# TODO: flaky? xdist?
		test/base/test_concurrency_py3k.py::TestAsyncioCompat::test_await_fallback_no_greenlet
	)
	local sqlite_version=$(sqlite3 --version | cut -d' ' -f1)
	case ${EPYTHON} in
		pypy3.11)
			EPYTEST_DESELECT+=(
				# TODO: looks like cursor cleanup failure
				"test/dialect/test_suite.py::ReturningGuardsTest_sqlite+pysqlite_${sqlite_version//./_}"
				# mismatched exception messages
				"test/dialect/sqlite/test_types.py::TestTypes_sqlite+pysqlite_${sqlite_version//./_}::test_cant_parse_datetime_message"
				"test/engine/test_execute.py::ExecuteDriverTest_sqlite+pysqlite_${sqlite_version//./_}::test_exception_wrapping_orig_accessors"
				test/ext/test_associationproxy.py::DictOfTupleUpdateTest::test_update_multi_elem_varg
				test/ext/test_associationproxy.py::DictOfTupleUpdateTest::test_update_one_elem_varg
				test/ext/test_associationproxy.py::ProxyHybridTest::test_msg_fails_on_cls_access
				test/engine/test_processors.py::PyDateProcessorTest::test_time_invalid_string
				"test/engine/test_processors.py::PyDateProcessorTest::test_invalid_string[str_to_time]"
				# TODO
				test/orm/test_utils.py::ContextualWarningsTest::test_autoflush_implicit
				test/orm/test_utils.py::ContextualWarningsTest::test_configure_mappers_explicit
				"test/sql/test_resultset.py::CursorResultTest_sqlite+pysqlite_${sqlite_version//./_}::test_new_row_no_dict_behaviors"
				"test/sql/test_compare.py::HasCacheKeySubclass::test_init_args_in_traversal[_MemoizedSelectEntities]"
				test/sql/test_lambdas.py::LambdaElementTest::test_bindparam_not_cached
				test/sql/test_compare.py::CompareAndCopyTest::test_all_present
				test/sql/test_compare.py::CacheKeyTest::test_cache_key
			)
			;;
	esac
	if ! has_version "dev-python/greenlet[${PYTHON_USEDEP}]"; then
		EPYTEST_DESELECT+=(
			test/ext/asyncio/test_engine_py3k.py::TextSyncDBAPI::test_sync_driver_execution
			test/ext/asyncio/test_engine_py3k.py::TextSyncDBAPI::test_sync_driver_run_sync
			"test/engine/test_pool.py::PoolEventsTest::test_checkin_event_gc[False-True]"
			"test/engine/test_pool.py::PoolEventsTest::test_checkin_event_gc[True-True]"
			"test/engine/test_pool.py::PoolEventsTest::test_checkin_event_gc[has_terminate-is_asyncio]"
			"test/engine/test_pool.py::PoolEventsTest::test_checkin_event_gc[not_has_terminate-is_asyncio]"
			"test/engine/test_pool.py::QueuePoolTest::test_userspace_disconnectionerror_weakref_finalizer[True-_exclusions0]"
			"test/engine/test_pool.py::QueuePoolTest::test_userspace_disconnectionerror_weakref_finalizer[True]"
		)
	fi

	# upstream's test suite is horribly hacky; it relies on disabling
	# the warnings plugin and turning warnings into errors;  this also
	# means that any DeprecationWarnings from third-party plugins cause
	# everything to explode
	epytest --reruns-delay=2 -m "not gc_intensive and not timing_intensive and not mypy"
}

python_install_all() {
	if use examples; then
		docompress -x "/usr/share/doc/${PF}/examples"
		dodoc -r examples
	fi

	distutils-r1_python_install_all
}

pkg_postinst() {
	optfeature "asyncio support" dev-python/greenlet
	optfeature "MySQL support" \
		dev-python/mysqlclient \
		dev-python/pymysql
	optfeature "postgresql support" dev-python/psycopg:2
}
