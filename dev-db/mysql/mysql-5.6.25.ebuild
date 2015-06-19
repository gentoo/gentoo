# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/mysql/mysql-5.6.25.ebuild,v 1.1 2015/06/01 16:18:23 grknight Exp $

EAPI="5"

MY_EXTRAS_VER="20150410-1944Z"
MY_PV="${PV//_alpha_pre/-m}"
MY_PV="${MY_PV//_/-}"

inherit toolchain-funcs mysql-multilib
# only to make repoman happy. it is really set in the eclass
IUSE="$IUSE"

# REMEMBER: also update eclass/mysql*.eclass before committing!
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~sparc-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"

# When MY_EXTRAS is bumped, the index should be revised to exclude these.
EPATCH_EXCLUDE=''

DEPEND="|| ( >=sys-devel/gcc-3.4.6 >=sys-devel/gcc-apple-4.0 )"
RDEPEND="${RDEPEND}"

# Please do not add a naive src_unpack to this ebuild
# If you want to add a single patch, copy the ebuild to an overlay
# and create your own mysql-extras tarball, looking at 000_index.txt

# Official test instructions:
# USE='embedded extraengine perl ssl static-libs community' \
# FEATURES='test userpriv -usersandbox' \
# ebuild mysql-X.X.XX.ebuild \
# digest clean package
multilib_src_test() {

	if ! multilib_is_native_abi ; then
		einfo "Server tests not available on non-native abi".
		return 0;
	fi

	local TESTDIR="${BUILD_DIR}/mysql-test"
	local retstatus_unit
	local retstatus_tests

	# Bug #213475 - MySQL _will_ object strenously if your machine is named
	# localhost. Also causes weird failures.
	[[ "${HOSTNAME}" == "localhost" ]] && die "Your machine must NOT be named localhost"

	if ! use "minimal" ; then

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

		# create symlink for the tests to find mysql_tzinfo_to_sql
		ln -s "${BUILD_DIR}/sql/mysql_tzinfo_to_sql" "${S}/sql/"

		# These are failing in MySQL 5.5/5.6 for now and are believed to be
		# false positives:
		#
		# main.information_schema, binlog.binlog_statement_insert_delayed,
		# funcs_1.is_triggers funcs_1.is_tables_mysql,
		# funcs_1.is_columns_mysql, binlog.binlog_mysqlbinlog_filter,
		# perfschema.binlog_edge_mix, perfschema.binlog_edge_stmt,
		# mysqld--help-notwin, funcs_1.is_triggers, funcs_1.is_tables_mysql, funcs_1.is_columns_mysql
		# perfschema.binlog_edge_stmt, perfschema.binlog_edge_mix, binlog.binlog_mysqlbinlog_filter
		# fails due to USE=-latin1 / utf8 default
		#
		# main.mysql_client_test:
		# segfaults at random under Portage only, suspect resource limits.
		#
		# rpl.rpl_plugin_load
		# fails due to included file not listed in expected result
		# appears to be poor planning
		#
		# main.mysqlhotcopy_archive main.mysqlhotcopy_myisam
		# fails due to bad cleanup of previous tests when run in parallel
		# The tool is deprecated anyway
		# Bug 532288
		for t in \
			binlog.binlog_mysqlbinlog_filter \
			binlog.binlog_statement_insert_delayed \
			funcs_1.is_columns_mysql \
			funcs_1.is_tables_mysql \
			funcs_1.is_triggers \
			main.information_schema \
			main.mysql_client_test \
			main.mysqld--help-notwin \
			perfschema.binlog_edge_mix \
			perfschema.binlog_edge_stmt \
			rpl.rpl_plugin_load \
			main.mysqlhotcopy_archive main.mysqlhotcopy_myisam \
		; do
				mysql-multilib_disable_test  "$t" "False positives in Gentoo"
		done

		if ! use extraengine ; then
			# bug 401673, 530766
			for t in federated.federated_plugin ; do
				mysql-multilib_disable_test  "$t" "Test $t requires USE=extraengine (Need federated engine)"
			done
		fi

		# Run mysql tests
		pushd "${TESTDIR}"

		# Set file limits higher so tests run
		ulimit -n 3000

		# run mysql-test tests
		perl mysql-test-run.pl --force --vardir="${T}/var-tests" \
			--suite-timeout=5000
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
