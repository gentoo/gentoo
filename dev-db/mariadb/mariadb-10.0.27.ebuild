# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"
MY_EXTRAS_VER="20160629-1442Z"
SUBSLOT="18"
MYSQL_PV_MAJOR="5.6"

JAVA_PKG_OPT_USE="jdbc"

inherit toolchain-funcs java-pkg-opt-2 mysql-multilib-r1

HOMEPAGE="http://mariadb.org/"
DESCRIPTION="An enhanced, drop-in replacement for MySQL"

IUSE="bindist jdbc odbc oqgraph pam sphinx tokudb xml"
RESTRICT="!bindist? ( bindist )"

REQUIRED_USE="server? ( tokudb? ( jemalloc ) ) static? ( !pam )"

# REMEMBER: also update eclass/mysql*.eclass before committing!
KEYWORDS="alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~sparc-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"

MY_PATCH_DIR="${WORKDIR}/mysql-extras-${MY_EXTRAS_VER}"
PATCHES=(
	"${MY_PATCH_DIR}/01050_all_mariadb_mysql_config_cleanup-5.5.41.patch"
	"${MY_PATCH_DIR}/20006_all_cmake_elib-mariadb-10.0.26.patch"
	"${MY_PATCH_DIR}/20009_all_mariadb_myodbc_symbol_fix-5.5.38.patch"
	"${MY_PATCH_DIR}/20018_all_mariadb-10.0.20-without-clientlibs-tools.patch"
)
COMMON_DEPEND="
	!bindist? ( >=sys-libs/readline-4.1:0=	)
	server? (
		extraengine? (
			odbc? ( dev-db/unixODBC:0= )
			xml? ( dev-libs/libxml2:2= )
		)
		oqgraph? ( >=dev-libs/boost-1.40.0:0= dev-libs/judy:0= )
		pam? ( virtual/pam:0= )
		tokudb? ( app-arch/snappy )
	)
	>=dev-libs/libpcre-8.35:3=
"
DEPEND="|| ( >=sys-devel/gcc-3.4.6 >=sys-devel/gcc-apple-4.0 )
	server? ( extraengine? ( jdbc? ( >=virtual/jdk-1.6 ) ) )
	${COMMON_DEPEND}"
RDEPEND="${RDEPEND} ${COMMON_DEPEND}
	perl? ( !dev-db/mytop
		virtual/perl-Getopt-Long
		dev-perl/TermReadKey
		virtual/perl-Term-ANSIColor
		virtual/perl-Time-HiRes )
	server? ( extraengine? ( jdbc? ( >=virtual/jre-1.6 ) ) )
"
MULTILIB_WRAPPED_HEADERS+=( /usr/include/mysql/mysql_version.h
	/usr/include/mysql/private/probes_mysql_nodtrace.h
	/usr/include/mysql/private/probes_mysql_dtrace.h )

pkg_setup() {
	java-pkg-opt-2_pkg_setup
	mysql-multilib-r1_pkg_setup
}

pkg_preinst() {
	java-pkg-opt-2_pkg_preinst
	mysql-multilib-r1_pkg_preinst
}

src_prepare() {
	java-pkg-opt-2_src_prepare
	mysql-multilib-r1_src_prepare
}

src_configure(){
	# bug 508724 mariadb cannot use ld.gold
	tc-ld-disable-gold
	local MYSQL_CMAKE_NATIVE_DEFINES=(
			-DWITH_JEMALLOC=$(usex jemalloc system)
			-DWITH_PCRE=system
	)
	if use server ; then
		# Federated{,X} must be treated special otherwise they will not be built as plugins
		if ! use extraengine ; then
			MYSQL_CMAKE_NATIVE_DEFINES+=(
				-DWITHOUT_FEDERATED=1
				-DWITHOUT_FEDERATEDX=1 )
		fi

		MYSQL_CMAKE_NATIVE_DEFINES+=(
			$(mysql-cmake_use_plugin oqgraph OQGRAPH)
			$(mysql-cmake_use_plugin sphinx SPHINX)
			$(mysql-cmake_use_plugin tokudb TOKUDB)
			$(mysql-cmake_use_plugin pam AUTH_PAM)
			-DWITHOUT_CASSANDRA=0
			$(mysql-cmake_use_plugin extraengine SEQUENCE)
			$(mysql-cmake_use_plugin extraengine SPIDER)
			$(mysql-cmake_use_plugin extraengine CONNECT)
			-DCONNECT_WITH_MYSQL=1
			-DCONNECT_WITH_LIBXML2=$(usex xml)
			-DCONNECT_WITH_ODBC=$(usex odbc)
			-DCONNECT_WITH_JDBC=$(usex jdbc)
			-DWITHOUT_MROONGA=1
		)
	fi
	mysql-multilib-r1_src_configure
}

# Official test instructions:
# USE='embedded extraengine perl server openssl static-libs' \
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
		# archive.mysqlhotcopy_archive main.mysqlhotcopy_myisam
		# fails due to bad cleanup of previous tests when run in parallel
		# The tool is deprecated anyway
		# Bug 532288

#main.bootstrap \
#		for t in main.mysql_client_test main.mysql_client_test_nonblock \
#			main.mysql_client_test_comp \
#			binlog.binlog_statement_insert_delayed main.information_schema \
#			main.mysqld--help \
#			archive.mysqlhotcopy_archive main.mysqlhotcopy_myisam \
#			funcs_1.is_triggers funcs_1.is_tables_mysql funcs_1.is_columns_mysql ; do
#				mysql-multilib-r1_disable_test  "$t" "False positives in Gentoo"
#		done

		# Run mysql tests
		pushd "${TESTDIR}" || die

		# run mysql-test tests
		perl mysql-test-run.pl --force --vardir="${T}/var-tests" --reorder

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

	else
		einfo "Skipping server tests due to minimal build."
	fi
}
