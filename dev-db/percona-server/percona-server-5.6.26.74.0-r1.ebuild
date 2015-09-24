# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
MY_EXTRAS_VER="20150717-1707Z"
HAS_TOOLS_PATCH="1"
SUBSLOT="18"

inherit toolchain-funcs mysql-multilib
# only to make repoman happy. it is really set in the eclass
IUSE="$IUSE tokudb tokudb-backup-plugin"

# REMEMBER: also update eclass/mysql*.eclass before committing!
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~sparc-fbsd ~x86-fbsd ~x86-linux"

# When MY_EXTRAS is bumped, the index should be revised to exclude these.
EPATCH_EXCLUDE=''

DEPEND="|| ( >=sys-devel/gcc-3.4.6 >=sys-devel/gcc-apple-4.0 )
	tokudb? ( app-arch/snappy )
	tokudb-backup-plugin? ( dev-util/valgrind )"
RDEPEND="${RDEPEND}"

REQUIRED_USE="tokudb? ( jemalloc ) tokudb-backup-plugin? ( tokudb )"

# Please do not add a naive src_unpack to this ebuild
# If you want to add a single patch, copy the ebuild to an overlay
# and create your own mysql-extras tarball, looking at 000_index.txt

# Official test instructions:
# USE='extraengine perl ssl static-libs community' \
# FEATURES='test userpriv -usersandbox' \
# ebuild percona-server-X.X.XX.ebuild \
# digest clean package
multilib_src_test() {

	if ! multilib_is_native_abi ; then
		einfo "Server tests not available on non-native abi".
		return 0;
	fi

	local TESTDIR="${CMAKE_BUILD_DIR}/mysql-test"
	local retstatus_unit
	local retstatus_tests

	# Bug #213475 - MySQL _will_ object strenously if your machine is named
	# localhost. Also causes weird failures.
	[[ "${HOSTNAME}" == "localhost" ]] && die "Your machine must NOT be named localhost"

	if use server ; then

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

		# Create a symlink to provided binaries so the tests can find them when client-libs is off
		if ! use client-libs ; then
			ln -srf /usr/bin/my_print_defaults "${BUILD_DIR}/client/my_print_defaults" || die
			ln -srf /usr/bin/perror "${BUILD_DIR}/client/perror" || die
			mysql-multilib_disable_test main.perror "String mismatch due to not building local perror"
		fi

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
		# innodb_stress.innodb_stress
		# innodb_stress.innodb_stress_blob innodb_stress.innodb_stress_blob_nocompress
		# innodb_stress.innodb_stress_crash innodb_stress.innodb_stress_crash_blob
		# innodb_stress.innodb_stress_crash_blob_nocompress innodb_stress.innodb_stress_crash_nocompress
		# innodb_stress.innodb_stress_nocompress
		# Dependent on python2 being the system python

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
				mysql-multilib_disable_test  "$t" "False positives in Gentoo"
		done

		for t in innodb_stress.innodb_stress \
			innodb_stress.innodb_stress_blob innodb_stress.innodb_stress_blob_nocompress \
			innodb_stress.innodb_stress_crash innodb_stress.innodb_stress_crash_blob \
			innodb_stress.innodb_stress_crash_blob_nocompress innodb_stress.innodb_stress_crash_nocompress \
			innodb_stress.innodb_stress_nocompress ; do
				mysql-multilib_disable_test "$t" "False positives due to python exception syntax"
		done

		# Run mysql tests
		pushd "${TESTDIR}"

		# Set file limits higher so tests run
		ulimit -n 3000

		# run mysql-test tests
		perl mysql-test-run.pl --force --vardir="${T}/var-tests" \
			--testcase-timeout=30 --reorder
		retstatus_tests=$?
		[[ $retstatus_tests -eq 0 ]] || eerror "tests failed"
		has usersandbox $FEATURES && eerror "Some tests may fail with FEATURES=usersandbox"

		popd

		# Cleanup is important for these testcases.
		pkill -9 -f "${S}/ndb" 2>/dev/null
		pkill -9 -f "${S}/sql" 2>/dev/null

		failures=""
		[[ $retstatus_unit -eq 0 ]] || failures="${failures} test-unit"
		[[ $retstatus_tests -eq 0 ]] || failures="${failures} tests"
		has usersandbox $FEATURES && eerror "Some tests may fail with FEATURES=usersandbox"

		[[ -z "$failures" ]] || die "Test failures: $failures"
		einfo "Tests successfully completed"

	else

		einfo "Skipping server tests due to minimal build."
	fi
}
