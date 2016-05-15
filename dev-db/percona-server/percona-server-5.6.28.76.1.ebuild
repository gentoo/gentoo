# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
MY_EXTRAS_VER="20151105-2051Z"
SUBSLOT="18"
PYTHON_COMPAT=( python2_7 )
inherit python-any-r1 mysql-multilib-r1

IUSE="pam tokudb tokudb-backup-plugin"

# REMEMBER: also update eclass/mysql*.eclass before committing!
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~sparc-fbsd ~x86-fbsd ~x86-linux"
HOMEPAGE="http://www.percona.com/software/percona-server"
DESCRIPTION="An enhanced, drop-in replacement for MySQL from the Percona team"

# When MY_EXTRAS is bumped, the index should be revised to exclude these.
EPATCH_EXCLUDE=''

COMMON_DEPEND="server? ( pam? ( virtual/pam:0= ) )
	tokudb? ( app-arch/snappy )
	tokudb-backup-plugin? ( dev-util/valgrind )
	"

DEPEND="${COMMON_DEPEND}
	|| ( >=sys-devel/gcc-3.4.6 >=sys-devel/gcc-apple-4.0 )
	test? ( $(python_gen_any_dep 'dev-python/mysql-python[${PYTHON_USEDEP}]') )"
RDEPEND="${COMMON_DEPEND}"

REQUIRED_USE="tokudb? ( jemalloc ) tokudb-backup-plugin? ( tokudb )"

# Please do not add a naive src_unpack to this ebuild
# If you want to add a single patch, copy the ebuild to an overlay
# and create your own mysql-extras tarball, looking at 000_index.txt

python_check_deps() {
	has_version "dev-python/mysql-python[${PYTHON_USEDEP}]"
}

src_configure() {
	local MYSQL_CMAKE_NATIVE_DEFINES=( -DWITH_PAM=$(usex pam)
			$(mysql-cmake_use_plugin tokudb TOKUDB)
	)
	if use tokudb ; then
		# TokuDB Backup plugin requires valgrind unconditionally
		MYSQL_CMAKE_NATIVE_DEFINES+=(
			$(usex tokudb-backup-plugin '' -DTOKUDB_BACKUP_DISABLED=1)
		)
	fi
	mysql-multilib-r1_src_configure
}

# Official test instructions:
# USE='extraengine perl openssl static-libs' \
# FEATURES='test userpriv -usersandbox' \
# ebuild percona-server-X.X.XX.ebuild \
# digest clean package
multilib_src_test() {

	if ! multilib_is_native_abi ; then
		einfo "Server tests not available on non-native abi".
		return 0;
	fi

	if ! use server ; then
		einfo "Skipping server tests due to minimal build."
		return 0
	fi

	local TESTDIR="${CMAKE_BUILD_DIR}/mysql-test"
	local retstatus_unit
	local retstatus_tests

	# Bug #213475 - MySQL _will_ object strenously if your machine is named
	# localhost. Also causes weird failures.
	[[ "${HOSTNAME}" == "localhost" ]] && die "Your machine must NOT be named localhost"

	if [[ $UID -eq 0 ]]; then
		die "Testing with FEATURES=-userpriv is no longer supported by upstream. Tests MUST be run as non-root."
	fi
	has usersandbox $FEATURES && eerror "Some tests may fail with FEATURES=usersandbox"

	einfo ">>> Test phase [test]: ${CATEGORY}/${PF}"
	addpredict /this-dir-does-not-exist/t9.MYI

	# Run CTest (test-units)
	cmake-utils_src_test
	retstatus_unit=$?
	[[ $retstatus_unit -eq 0 ]] || eerror "test-unit failed"

	# Ensure that parallel runs don't die
	export MTR_BUILD_THREAD="$((${RANDOM} % 100))"
	# Enable parallel testing, auto will try to detect number of cores
	# You may set this by hand.
	# The default maximum is 8 unless MTR_MAX_PARALLEL is increased
	export MTR_PARALLEL="${MTR_PARALLEL:-auto}"

	# create directories because mysqladmin might right out of order
	mkdir -p "${T}"/var-tests{,/log}

	# These are failing in Percona 5.6 for now and are believed to be
	# false positives:
	#
	# main.information_schema, binlog.binlog_statement_insert_delayed,
	# main.mysqld--help-notwin, binlog.binlog_mysqlbinlog_filter
	# perfschema.binlog_edge_mix, perfschema.binlog_edge_stmt
	# funcs_1.is_columns_mysql funcs_1.is_tables_mysql funcs_1.is_triggers
	# engines/funcs.db_alter_character_set engines/funcs.db_alter_character_set_collate
	# engines/funcs.db_alter_collate_ascii engines/funcs.db_alter_collate_utf8
	# engines/funcs.db_create_character_set engines/funcs.db_create_character_set_collate
	# fails due to USE=-latin1 / utf8 default
	#
	# main.mysql_client_test:
	# segfaults at random under Portage only, suspect resource limits.
	#
	# main.percona_bug1289599
	# Looks to be a syntax error in the test file itself
	#
	# main.variables main.myisam main.merge_recover
	# fails due to ulimit not able to open enough files (needs 5000)
	#
	# main.mysqlhotcopy_archive main.mysqlhotcopy_myisam
	# Called with bad parameters should be reported upstream
	#

	for t in main.mysql_client_test \
		binlog.binlog_statement_insert_delayed main.information_schema \
		main.mysqld--help-notwin binlog.binlog_mysqlbinlog_filter \
		perfschema.binlog_edge_mix perfschema.binlog_edge_stmt \
		funcs_1.is_columns_mysql funcs_1.is_tables_mysql funcs_1.is_triggers \
		main.variables main.myisam main.merge_recover \
		engines/funcs.db_alter_character_set engines/funcs.db_alter_character_set_collate \
		engines/funcs.db_alter_collate_ascii engines/funcs.db_alter_collate_utf8 \
		engines/funcs.db_create_character_set engines/funcs.db_create_character_set_collate \
		main.percona_bug1289599 main.mysqlhotcopy_archive main.mysqlhotcopy_myisam ; do
			mysql-multilib-r1_disable_test  "$t" "False positives in Gentoo"
	done

	if ! use extraengine ; then
		# bug 401673, 530766
		for t in federated.federated_plugin ; do
			mysql-multilib-r1_disable_test "$t" "Test $t requires USE=extraengine (Need federated engine)"
		done
	fi

	# Run mysql tests
	pushd "${TESTDIR}" || die

	# Set file limits higher so tests run
	ulimit -n 3000
	python_setup
	# run mysql-test tests
	perl mysql-test-run.pl --force --vardir="${T}/var-tests" \
		--testcase-timeout=30 --reorder
	retstatus_tests=$?
	[[ $retstatus_tests -eq 0 ]] || eerror "tests failed"
	has usersandbox $FEATURES && eerror "Some tests may fail with FEATURES=usersandbox"

	popd || die

	# Cleanup is important for these testcases.
	pkill -9 -f "${S}/ndb" 2>/dev/null
	pkill -9 -f "${S}/sql" 2>/dev/null

	failures=""
	[[ $retstatus_unit -eq 0 ]] || failures="${failures} test-unit"
	[[ $retstatus_tests -eq 0 ]] || failures="${failures} tests"
	has usersandbox $FEATURES && eerror "Some tests may fail with FEATURES=usersandbox"

	[[ -z "$failures" ]] || die "Test failures: $failures"
	einfo "Tests successfully completed"
}
