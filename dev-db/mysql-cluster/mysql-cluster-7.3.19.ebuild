# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
MY_EXTRAS_VER="20171108-2050Z"
SUBSLOT="18"
MYSQL_PV_MAJOR="5.6"
#fails to build with ninja
CMAKE_MAKEFILE_GENERATOR=emake

inherit java-utils-2 mysql-multilib-r1
# only to make repoman happy. it is really set in the eclass
IUSE="$IUSE numa"

# REMEMBER: also update eclass/mysql*.eclass before committing!
KEYWORDS="~amd64 ~x86"
COMMON_DEPEND="numa? ( sys-process/numactl ) dev-libs/libevent:0= ${JAVA_PKG_E_DEPEND}"
DEPEND="${COMMON_DEPEND} || ( >=sys-devel/gcc-3.4.6 >=sys-devel/gcc-apple-4.0 ) >=virtual/jdk-1.6 test? ( dev-perl/JSON )"
RDEPEND="${COMMON_DEPEND} !media-sound/amarok[embedded] >=virtual/jre-1.6"

MY_PATCH_DIR="${WORKDIR}/mysql-extras-${MY_EXTRAS_VER}"

PATCHES=(
	"${MY_PATCH_DIR}"/01050_all_mysql_config_cleanup-5.6.patch
	"${MY_PATCH_DIR}"/02040_all_embedded-library-shared-5.5.10.patch
	"${MY_PATCH_DIR}"/20007_all_cmake-debug-werror-5.6.22.patch
	"${MY_PATCH_DIR}"/20009_all_mysql_myodbc_symbol_fix-5.6.patch
#	"${MY_PATCH_DIR}"/20018_all_mysql-5.6.25-without-clientlibs-tools.patch
	"${MY_PATCH_DIR}"/20027_all_mysql-5.5-perl5.26-includes.patch
	"${MY_PATCH_DIR}"/30000_all_mysql-cluster-multilib-property.patch
)

MULTILIB_WRAPPED_HEADERS+=( /usr/include/mysql/storage/ndb/ndb_types.h )

# Please do not add a naive src_unpack to this ebuild
# If you want to add a single patch, copy the ebuild to an overlay
# and create your own mysql-extras tarball, looking at 000_index.txt

pkg_setup() {
	mysql-multilib-r1_pkg_setup
	java-pkg_init
}

src_prepare() {
	mysql-multilib-r1_src_prepare
	java-utils-2_src_prepare
	if use libressl ; then
		sed -i 's/OPENSSL_MAJOR_VERSION STREQUAL "1"/OPENSSL_MAJOR_VERSION STREQUAL "2"/' \
			"${S}/cmake/ssl.cmake" || die
	fi
}

src_configure() {
	# validate_password plugin uses exceptions when it shouldn't yet (until 5.7)
	# disable until we see what happens with it
	local MYSQL_CMAKE_NATIVE_DEFINES=(
		-DWITHOUT_VALIDATE_PASSWORD=1
		-DWITH_NUMA=$(usex numa ON OFF)
		-DWITH_NDBCLUSTER=1 -DWITH_PARTITION_STORAGE_ENGINE=1
		-DWITHOUT_PARTITION_STORAGE_ENGINE=0 )
	mysql-multilib-r1_src_configure
}

pkg_preinst() {
	java-utils-2_pkg_preinst
	mysql-multilib-r1_pkg_preinst
}

# Official test instructions:
# USE='extraengine perl openssl' \
# FEATURES='test userpriv -usersandbox' \
# ebuild mysql-cluster-X.X.XX.ebuild \
# digest clean package
multilib_src_test() {

	if ! multilib_is_native_abi ; then
		einfo "Server tests not available on non-native abi".
		return 0;
	fi

	_disable_test() {
		local rawtestname reason
		rawtestname="${1}" ; shift
		reason="${@}"
		ewarn "test '${rawtestname}' disabled: '${reason}'"
		echo ${rawtestname} : ${reason} >> "${T}/disabled.def"
	}

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

		touch "${T}/disabled.def"
		# These are failing in MySQL 5.5/5.6 for now and are believed to be
		# false positives:
		#
		# main.information_schema, binlog.binlog_statement_insert_delayed,
		# main.mysqld--help-notwin, funcs_1.is_triggers funcs_1.is_tables_mysql,
		# funcs_1.is_columns_mysql, binlog.binlog_mysqlbinlog_filter,
		# perfschema.binlog_edge_mix, perfschema.binlog_edge_stmt,
		# mysqld--help-notwin, funcs_1.is_triggers, funcs_1.is_tables_mysql, funcs_1.is_columns_mysql
		# perfschema.binlog_edge_stmt, perfschema.binlog_edge_mix, binlog.binlog_mysqlbinlog_filter
		# fails due to USE=-latin1 / utf8 default
		#
		# main.mysql_client_test:
		# segfaults at random under Portage only, suspect resource limits.
		#
		for t in \
			binlog.binlog_mysqlbinlog_filter \
			binlog.binlog_statement_insert_delayed \
			funcs_1.is_columns_mysql \
			funcs_1.is_tables_mysql \
			funcs_1.is_triggers \
			main.information_schema \
			main.mysqld--help-notwinfuncs_1.is_triggers \
			main.mysql_client_test \
			mysqld--help-notwin \
			main.mysqlhotcopy_archive main.mysqlhotcopy_myisam \
			perfschema.binlog_edge_mix \
			perfschema.binlog_edge_stmt \
			rpl.rpl_plugin_load main.mysql \
			main.mysql_upgrade \
		; do
				_disable_test  "$t" "False positives in Gentoo"
		done
		# ndb.ndbinfo, ndb_binlog.ndb_binlog_index: latin1/utf8
		for t in \
			ndb.ndbinfo ndb.ndb_tools_connect \
			ndb_binlog.ndb_binlog_index ; do
				_disable_test  "$t" "False positives in Gentoo (NDB) (Latin1/UTF8)"
		done

		# Set file limits higher so tests run
		ulimit -n 3000

		# Run mysql tests
		pushd "${TESTDIR}" > /dev/null || die

		# run mysql-test tests
		perl mysql-test-run.pl --force --vardir="${T}/var-tests" \
			--suite-timeout=5000 --reorder --skip-test-list="${T}/disabled.def" \
			--nounit-tests
		retstatus_tests=$?

		popd > /dev/null || die

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
