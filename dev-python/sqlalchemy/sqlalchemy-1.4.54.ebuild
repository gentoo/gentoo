# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYPI_PN=SQLAlchemy
PYTHON_COMPAT=( pypy3 python3_{10..12} )
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
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="examples +sqlite test"

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
	local EPYTEST_DESELECT=(
		# warning tests are unreliable
		test/base/test_warnings.py

		# TODO
		'test/orm/test_cache_key.py::EmbeddedSubqTest::test_cache_key_gen[memory-_exclusions1]'

		# deprecations
		test/engine/test_parseconnect.py::TestRegNewDBAPI::test_wrapper_hooks
		test/engine/test_parseconnect.py::URLTest::test_component_set
		test/engine/test_parseconnect.py::URLTest::test_password_custom_obj
		test/engine/test_parseconnect.py::URLTest::test_update_query_dict
		test/engine/test_parseconnect.py::URLTest::test_update_query_string
	)
	local sqlite_version=$(sqlite3 --version | cut -d' ' -f1)
	[[ ${EPYTHON} == pypy3 ]] && EPYTEST_DESELECT+=(
		test/ext/test_associationproxy.py::ProxyHybridTest::test_msg_fails_on_cls_access
		# https://github.com/sqlalchemy/sqlalchemy/issues/8762
		test/orm/test_query.py::YieldTest_sqlite+pysqlite_${sqlite_version//./_}::test_yield_per_close_on_interrupted_iteration_legacy
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
	# note that we can't use xdist because it causes nodes to randomly
	# crash on init
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
		dev-python/pymysql
	optfeature "postgresql support" dev-python/psycopg:2
}
