# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

MY_EXTRAS_VER="20171121-1518Z"
MY_PV="${PV//_alpha_pre/-m}"
MY_PV="${MY_PV//_/-}"
HAS_TOOLS_PATCH="1"
SUBSLOT="18"
#fails to build with ninja
CMAKE_MAKEFILE_GENERATOR=emake

inherit mysql-multilib-r1
# only to make repoman happy. it is really set in the eclass
IUSE="$IUSE numa"

# REMEMBER: also update eclass/mysql*.eclass before committing!
KEYWORDS="~alpha amd64 ~arm ~hppa ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"

COMMON_DEPEND="numa? ( sys-process/numactl:= )"

DEPEND="${COMMON_DEPEND}
	|| ( >=sys-devel/gcc-3.4.6 >=sys-devel/gcc-apple-4.0 )
	test? ( dev-perl/JSON )"
RDEPEND="${COMMON_DEPEND}"

MY_PATCH_DIR="${WORKDIR}/mysql-extras-${MY_EXTRAS_VER}"

PATCHES=(
	"${MY_PATCH_DIR}"/01050_all_mysql_config_cleanup-5.6.patch
	"${MY_PATCH_DIR}"/02040_all_embedded-library-shared-5.5.10.patch
	"${MY_PATCH_DIR}"/20006_all_cmake_elib-mysql-5.6.35.patch
	"${MY_PATCH_DIR}"/20007_all_cmake-debug-werror-5.6.22.patch
	"${MY_PATCH_DIR}"/20008_all_mysql-tzinfo-symlink-5.6.37.patch
	"${MY_PATCH_DIR}"/20009_all_mysql_myodbc_symbol_fix-5.6.patch
	"${MY_PATCH_DIR}"/20018_all_mysql-5.6.25-without-clientlibs-tools.patch
	"${MY_PATCH_DIR}"/20027_all_mysql-5.5-perl5.26-includes.patch
	"${MY_PATCH_DIR}"/20028_all_mysql-5.6-gcc7.patch
)

# Please do not add a naive src_unpack to this ebuild
# If you want to add a single patch, copy the ebuild to an overlay
# and create your own mysql-extras tarball, looking at 000_index.txt

src_prepare() {
	mysql-multilib-r1_src_prepare
	if use libressl ; then
		sed -i 's/OPENSSL_MAJOR_VERSION STREQUAL "1"/OPENSSL_MAJOR_VERSION STREQUAL "2"/' \
			"${S}/cmake/ssl.cmake" || die
	fi
}

src_configure() {
	# validate_password plugin uses exceptions when it shouldn't yet (until 5.7)
	# disable until we see what happens with it
	local MYSQL_CMAKE_NATIVE_DEFINES=( -DWITHOUT_VALIDATE_PASSWORD=1 -DWITH_NUMA=$(usex numa ON OFF) )
	mysql-multilib-r1_src_configure
}

# Official test instructions:
# USE='server extraengine perl openssl static-libs' \
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

	if use server ; then

		if [[ $UID -eq 0 ]]; then
			die "Testing with FEATURES=-userpriv is no longer supported by upstream. Tests MUST be run as non-root."
		fi
		has usersandbox $FEATURES && ewarn "Some tests may fail with FEATURES=usersandbox"

		einfo ">>> Test phase [test]: ${CATEGORY}/${PF}"

		# Run CTest (test-units)
		cmake-utils_src_test
		retstatus_unit=$?

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
		#
		# main.events_2
		# Fails on date in past without preserve causing the drop to fail

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
			main.events_2 \
		; do
				mysql-multilib-r1_disable_test  "$t" "False positives in Gentoo"
		done

		if ! use extraengine ; then
			# bug 401673, 530766
			for t in federated.federated_plugin ; do
				mysql-multilib-r1_disable_test  "$t" "Test $t requires USE=extraengine (Need federated engine)"
			done
		fi

		for t in main.mysql main.mysql_upgrade ; do
			mysql-multilib-r1_disable_test  "$t" "Test $t broken upstream - error return value not updated"
		done

		# Run mysql tests
		pushd "${TESTDIR}"

		# Set file limits higher so tests run
		ulimit -n 3000

		# run mysql-test tests
		perl mysql-test-run.pl --force --vardir="${T}/var-tests" \
			--suite-timeout=5000 --reorder
		retstatus_tests=$?
#		[[ $retstatus_tests -eq 0 ]] || eerror "tests failed"
#		has usersandbox $FEATURES && eerror "Some tests may fail with FEATURES=usersandbox"

		popd

		# Cleanup is important for these testcases.
		pkill -9 -f "${S}/ndb" 2>/dev/null
		pkill -9 -f "${S}/sql" 2>/dev/null

		failures=""
		[[ $retstatus_unit -eq 0 ]] || failures="${failures} test-unit"
		[[ $retstatus_tests -eq 0 ]] || failures="${failures} tests"
#		has usersandbox $FEATURES && eerror "Some tests may fail with FEATURES=usersandbox"

		[[ -z "$failures" ]] || die "Test failures: $failures"
		einfo "Tests successfully completed"

	else
		einfo "Skipping server tests due to minimal build."
	fi
}
