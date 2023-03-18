# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{9..11} )
PYTHON_REQ_USE="sqlite?"

inherit distutils-r1 optfeature pypi

MY_PN="SQLAlchemy"
DESCRIPTION="Python SQL toolkit and Object Relational Mapper"
HOMEPAGE="
	https://www.sqlalchemy.org/
	https://pypi.org/project/SQLAlchemy/
	https://github.com/sqlalchemy/sqlalchemy/
"
SRC_URI="$(pypi_sdist_url --no-normalize "${MY_PN}")"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="examples +sqlite test"

RDEPEND="
	>=dev-python/typing-extensions-4.2.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		$(python_gen_impl_dep sqlite)
	)
"

distutils_enable_tests pytest

EPYTEST_IGNORE=(
	# hardcode call counts specific to Python versions
	test/aaa_profiling
)

src_prepare() {
	sed -i -e '/greenlet/d' setup.cfg || die
	distutils-r1_src_prepare
}

python_test() {
	local EPYTEST_IGNORE=(
		test/ext/mypy/test_mypy_plugin_py3k.py

	)
	local EPYTEST_DESELECT=(
		# warning tests are unreliable
		test/base/test_warnings.py
		# TODO
		test/orm/test_versioning.py::ServerVersioningTest_sqlite+pysqlite_3_40_1::test_sql_expr_w_mods_bump
		test/sql/test_resultset.py::CursorResultTest_sqlite+pysqlite_3_41_0::test_pickle_rows_other_process
	)
	[[ ${EPYTHON} == pypy3 ]] && EPYTEST_DESELECT+=(
		test/ext/test_associationproxy.py::ProxyHybridTest::test_msg_fails_on_cls_access
		test/ext/test_associationproxy.py::DictOfTupleUpdateTest::test_update_multi_elem_varg
		test/ext/test_associationproxy.py::DictOfTupleUpdateTest::test_update_one_elem_varg
		test/engine/test_processors.py::PyDateProcessorTest::test_date_invalid_string
		test/engine/test_processors.py::PyDateProcessorTest::test_datetime_invalid_string
		test/engine/test_processors.py::PyDateProcessorTest::test_time_invalid_string
		test/dialect/test_sqlite.py::TestTypes_sqlite+pysqlite_3_40_1::test_cant_parse_datetime_message
		test/dialect/test_sqlite.py::TestTypes_sqlite+pysqlite_3_41_0::test_cant_parse_datetime_message
		test/dialect/test_suite.py::ReturningGuardsTest_sqlite+pysqlite_3_40_1::test_delete_single
		test/dialect/test_suite.py::ReturningGuardsTest_sqlite+pysqlite_3_40_1::test_insert_single
		test/dialect/test_suite.py::ReturningGuardsTest_sqlite+pysqlite_3_40_1::test_update_single
		test/dialect/test_suite.py::ReturningGuardsTest_sqlite+pysqlite_3_41_0::test_delete_single
		test/dialect/test_suite.py::ReturningGuardsTest_sqlite+pysqlite_3_41_0::test_insert_single
		test/dialect/test_suite.py::ReturningGuardsTest_sqlite+pysqlite_3_41_0::test_update_single
		test/base/test_utils.py::ImmutableDictTest::test_pep584
	)
	if ! has_version "dev-python/greenlet[${PYTHON_USEDEP}]"; then
		EPYTEST_DESELECT+=(
			test/ext/asyncio/test_engine_py3k.py::TextSyncDBAPI::test_sync_driver_execution
			test/ext/asyncio/test_engine_py3k.py::TextSyncDBAPI::test_sync_driver_run_sync
			"test/engine/test_pool.py::PoolEventsTest::test_checkin_event_gc[False-True]"
			"test/engine/test_pool.py::PoolEventsTest::test_checkin_event_gc[True-True]"
			"test/engine/test_pool.py::QueuePoolTest::test_userspace_disconnectionerror_weakref_finalizer[True-_exclusions0]"
		)
	fi

	# upstream's test suite is horribly hacky; it relies on disabling
	# the warnings plugin and turning warnings into errors;  this also
	# means that any DeprecationWarnings from third-party plugins cause
	# everything to explode
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	local -x PYTEST_PLUGINS=
	# upstream automagically depends on xdist when it is importable
	if has_version "dev-python/pytest-xdist[${PYTHON_USEDEP}]"; then
		PYTEST_PLUGINS+=xdist.plugin
	fi
	epytest
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
		dev-python/pymysql \
		dev-python/mysql-connector-python
	optfeature "postgresql support" dev-python/psycopg:2
}
