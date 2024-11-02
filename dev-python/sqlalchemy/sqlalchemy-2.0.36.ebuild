# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYPI_PN=SQLAlchemy
PYTHON_COMPAT=( pypy3 python3_{10..13} )
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
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~loong ~m68k ~mips ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="examples +sqlite test"

RDEPEND="
	>=dev-python/typing-extensions-4.6.0[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	test? (
		$(python_gen_impl_dep sqlite)
		dev-python/pytest-rerunfailures[${PYTHON_USEDEP}]
	)
"

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
	)
	local sqlite_version=$(sqlite3 --version | cut -d' ' -f1)
	case ${EPYTHON} in
		pypy3)
			EPYTEST_DESELECT+=(
				test/ext/test_associationproxy.py::ProxyHybridTest::test_msg_fails_on_cls_access
				test/ext/test_associationproxy.py::DictOfTupleUpdateTest::test_update_multi_elem_varg
				test/ext/test_associationproxy.py::DictOfTupleUpdateTest::test_update_one_elem_varg
				test/engine/test_processors.py::PyDateProcessorTest::test_date_invalid_string
				test/engine/test_processors.py::PyDateProcessorTest::test_datetime_invalid_string
				test/engine/test_processors.py::PyDateProcessorTest::test_time_invalid_string
				"test/dialect/test_sqlite.py::TestTypes_sqlite+pysqlite_${sqlite_version//./_}::test_cant_parse_datetime_message"
				"test/dialect/test_suite.py::ReturningGuardsTest_sqlite+pysqlite_${sqlite_version//./_}"::test_{delete,insert,update}_single
				test/base/test_utils.py::ImmutableDictTest::test_pep584
				'test/sql/test_compare.py::HasCacheKeySubclass::test_init_args_in_traversal[_MemoizedSelectEntities]'
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
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -p rerunfailures --reruns=10 --reruns-delay=2
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
