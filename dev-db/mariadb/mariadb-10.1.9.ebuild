# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
MY_EXTRAS_VER="20151123-1643Z"
WSREP_REVISION="25"
SUBSLOT="18"
HAS_TOOLS_PATCH="yes"

inherit toolchain-funcs mysql-multilib
# only to make repoman happy. it is really set in the eclass
IUSE="$IUSE mroonga systemd"

# REMEMBER: also update eclass/mysql*.eclass before committing!
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~hppa ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~sparc-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"

# When MY_EXTRAS is bumped, the index should be revised to exclude these.
#EPATCH_EXCLUDE=''

DEPEND="|| ( >=sys-devel/gcc-3.4.6 >=sys-devel/gcc-apple-4.0 )
	mroonga? ( app-text/groonga-normalizer-mysql )
	systemd? ( sys-apps/systemd:= )"
RDEPEND="${RDEPEND}"

# Official test instructions:
# USE='client-libs embedded extraengine perl server openssl static-libs tools' \
# FEATURES='test userpriv -usersandbox' \
# ebuild mariadb-X.X.XX.ebuild \
# digest clean package
multilib_src_test() {

	if ! multilib_is_native_abi ; then
		einfo "Server tests not available on non-native abi".
		return 0;
	fi

	local TESTDIR="${BUILD_DIR}/mysql-test"
	local retstatus_unit
	local retstatus_tests

	if use server ; then

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

		# Create a symlink to provided binaries so the tests can find them when client-libs is off
		if ! use client-libs ; then
			ln -srf /usr/bin/my_print_defaults "${BUILD_DIR}/client/my_print_defaults" || die
			ln -srf /usr/bin/perror "${BUILD_DIR}/client/perror" || die
			mysql-multilib_disable_test main.perror "String mismatch due to not building local perror"
		fi

		# Ensure that parallel runs don't die
		export MTR_BUILD_THREAD="$((${RANDOM} % 100))"
		# Enable parallel testing, auto will try to detect number of cores
		# You may set this by hand.
		# The default maximum is 8 unless MTR_MAX_PARALLEL is increased
		export MTR_PARALLEL="${MTR_PARALLEL:-auto}"

		# create directories because mysqladmin might run out of order
		mkdir -p "${T}"/var-tests{,/log}

		# These are failing in MariaDB 10.0 for now and are believed to be
		# false positives:
		#
		# main.information_schema, binlog.binlog_statement_insert_delayed,
		# main.mysqld--help, funcs_1.is_triggers, funcs_1.is_tables_mysql,
		# funcs_1.is_columns_mysql main.bootstrap
		# fails due to USE=-latin1 / utf8 default
		#
		# main.mysql_client_test, main.mysql_client_test_nonblock
		# main.mysql_client_test_comp:
		# segfaults at random under Portage only, suspect resource limits.
		#
		# plugins.cracklib_password_check
		# Can randomly fail due to cracklib return message

		for t in main.mysql_client_test main.mysql_client_test_nonblock \
			main.mysql_client_test_comp main.bootstrap \
			binlog.binlog_statement_insert_delayed main.information_schema \
			main.mysqld--help plugins.cracklib_password_check \
			funcs_1.is_triggers funcs_1.is_tables_mysql funcs_1.is_columns_mysql ; do
				mysql-multilib_disable_test  "$t" "False positives in Gentoo"
		done

		# Run mysql tests
		pushd "${TESTDIR}"

		# run mysql-test tests
		perl mysql-test-run.pl --force --vardir="${T}/var-tests" --reorder

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
