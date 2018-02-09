# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
MY_EXTRAS_VER="20170926-1321Z"
# The wsrep API version must match between upstream WSREP and sys-cluster/galera major number
WSREP_REVISION="25"
SUBSLOT="18"
MYSQL_PV_MAJOR="5.6"

JAVA_PKG_OPT_USE="jdbc"

inherit toolchain-funcs java-pkg-opt-2 mysql-multilib-r1

HOMEPAGE="http://mariadb.org/"
DESCRIPTION="An enhanced, drop-in replacement for MySQL"

IUSE="+backup bindist cracklib galera kerberos innodb-lz4 innodb-lzo innodb-snappy jdbc mroonga odbc oqgraph pam sphinx sst-rsync sst-mariabackup sst-xtrabackup tokudb systemd xml"
RESTRICT="!bindist? ( bindist )"

REQUIRED_USE="jdbc? ( extraengine server !static ) server? ( tokudb? ( jemalloc !tcmalloc ) ) static? ( !pam )"

# REMEMBER: also update eclass/mysql*.eclass before committing!
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"

MY_PATCH_DIR="${WORKDIR}/mysql-extras-${MY_EXTRAS_VER}"

PATCHES=(
	"${MY_PATCH_DIR}"/20006_all_cmake_elib-mariadb-10.1.27.patch
	"${MY_PATCH_DIR}"/20009_all_mariadb_myodbc_symbol_fix-5.5.38.patch
	"${MY_PATCH_DIR}"/20015_all_mariadb-pkgconfig-location.patch
	"${MY_PATCH_DIR}"/20018_all_mariadb-10.1.16-without-clientlibs-tools.patch
	"${MY_PATCH_DIR}"/20025_all_mariadb-10.1.26-gssapi-detect.patch
)

COMMON_DEPEND="
	mroonga? ( app-text/groonga-normalizer-mysql )
	kerberos? ( virtual/krb5[${MULTILIB_USEDEP}] )
	!bindist? (
		sys-libs/binutils-libs:0=
		>=sys-libs/readline-4.1:0=
	)
	server? (
		backup? ( app-arch/libarchive:0= )
		cracklib? ( sys-libs/cracklib:0= )
		extraengine? (
			odbc? ( dev-db/unixODBC:0= )
			xml? ( dev-libs/libxml2:2= )
			sys-libs/zlib[minizip]
		)
		innodb-lz4? ( app-arch/lz4 )
		innodb-lzo? ( dev-libs/lzo )
		innodb-snappy? ( app-arch/snappy )
		oqgraph? ( >=dev-libs/boost-1.40.0:0= dev-libs/judy:0= )
		pam? ( virtual/pam:0= )
		systemd? ( sys-apps/systemd:= )
		tokudb? ( app-arch/snappy )
	)
	>=dev-libs/libpcre-8.41-r1:3=
"
DEPEND="|| ( >=sys-devel/gcc-3.4.6 >=sys-devel/gcc-apple-4.0 )
	server? ( extraengine? ( jdbc? ( >=virtual/jdk-1.6 ) ) )
	${COMMON_DEPEND}"
RDEPEND="${RDEPEND} ${COMMON_DEPEND}
	galera? (
		sys-apps/iproute2
		=sys-cluster/galera-${WSREP_REVISION}*
		sst-rsync? ( sys-process/lsof )
		sst-mariabackup? ( net-misc/socat[ssl] )
		sst-xtrabackup? ( net-misc/socat[ssl] )
	)
	perl? ( !dev-db/mytop
		virtual/perl-Getopt-Long
		dev-perl/TermReadKey
		virtual/perl-Term-ANSIColor
		virtual/perl-Time-HiRes )
	server? ( extraengine? ( jdbc? ( >=virtual/jre-1.6 ) ) )
"
# xtrabackup-bin causes a circular dependency if DBD-mysql is not already installed
PDEPEND="galera? ( sst-xtrabackup? ( || ( >=dev-db/xtrabackup-bin-2.2.4 dev-db/percona-xtrabackup ) ) )"

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
	local MYSQL_CMAKE_EXTRA_DEFINES=(
			-DPLUGIN_AUTH_GSSAPI_CLIENT=$(usex kerberos YES NO)
	)
	if use server ; then
		# Federated{,X} must be treated special otherwise they will not be built as plugins
		if ! use extraengine ; then
			MYSQL_CMAKE_NATIVE_DEFINES+=(
				-DPLUGIN_FEDERATED=NO
				-DPLUGIN_FEDERATEDX=NO )
		fi

		MYSQL_CMAKE_NATIVE_DEFINES+=(
			-DPLUGIN_OQGRAPH=$(usex oqgraph YES NO)
			-DPLUGIN_SPHINX=$(usex sphinx YES NO)
			-DPLUGIN_TOKUDB=$(usex tokudb YES NO)
			-DPLUGIN_AUTH_PAM=$(usex pam YES NO)
			-DPLUGIN_CRACKLIB_PASSWORD_CHECK=$(usex cracklib YES NO)
			-DPLUGIN_CASSANDRA=NO
			-DPLUGIN_SEQUENCE=$(usex extraengine YES NO)
			-DPLUGIN_SPIDER=$(usex extraengine YES NO)
			-DPLUGIN_CONNECT=$(usex extraengine YES NO)
			-DCONNECT_WITH_MYSQL=1
			-DCONNECT_WITH_LIBXML2=$(usex xml)
			-DCONNECT_WITH_ODBC=$(usex odbc)
			-DCONNECT_WITH_JDBC=$(usex jdbc)
			# Build failure and autodep wrt bug 639144
			-DCONNECT_WITH_MONGO=OFF
			-DWITH_WSREP=$(usex galera)
			-DWITH_INNODB_LZ4=$(usex innodb-lz4 ON OFF)
			-DWITH_INNODB_LZO=$(usex innodb-lzo ON OFF)
			-DWITH_INNODB_SNAPPY=$(usex innodb-snappy ON OFF)
			-DPLUGIN_MROONGA=$(usex mroonga YES NO)
			-DPLUGIN_AUTH_GSSAPI=$(usex kerberos YES NO)
			-DWITH_MARIABACKUP=$(usex backup ON OFF)
			-DWITH_LIBARCHIVE=$(usex backup ON OFF)
		)
	fi
	mysql-multilib-r1_src_configure
}

# Official test instructions:
# USE='extraengine perl server openssl static-libs' \
# FEATURES='test userpriv -usersandbox' \
# ebuild mariadb-X.X.XX.ebuild \
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
	local TESTDIR="${BUILD_DIR}/mysql-test"
	local retstatus_unit
	local retstatus_tests

	if ! use server ; then
		einfo "Skipping server tests due to minimal build."
		return 0
	fi

	# Bug #213475 - MySQL _will_ object strenously if your machine is named
	# localhost. Also causes weird failures.
	[[ "${HOSTNAME}" == "localhost" ]] && die "Your machine must NOT be named localhost"

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

	# create directories because mysqladmin might run out of order
	mkdir -p "${T}"/var-tests{,/log}

	# Run mysql tests
	pushd "${TESTDIR}" || die

	touch "${T}/disabled.def"
	# These are failing in MariaDB 10.0 for now and are believed to be
	# false positives:
	#
	# main.mysql_client_test, main.mysql_client_test_nonblock
	# main.mysql_client_test_comp:
	# segfaults at random under Portage only, suspect resource limits.

	local t
	for t in plugins.cracklib_password_check plugins.two_password_validations ; do
		_disable_test  "$t" "False positive due to varying policies"
	done

	for t in main.mysql_client_test main.mysql_client_test_nonblock \
		main.mysql_client_test_comp ; do
			_disable_test  "$t" "False positives in Gentoo"
	done

	# run mysql-test tests
	perl mysql-test-run.pl --force --vardir="${T}/var-tests" --reorder --skip-test-list="${T}/disabled.def"
	retstatus_tests=$?

	popd || die

	# Cleanup is important for these testcases.
	pkill -9 -f "${S}/ndb" 2>/dev/null
	pkill -9 -f "${S}/sql" 2>/dev/null

	local failures=""
	[[ $retstatus_unit -eq 0 ]] || failures="${failures} test-unit"
	[[ $retstatus_tests -eq 0 ]] || failures="${failures} tests"

	[[ -z "$failures" ]] || eerror "Test failures: $failures"
	einfo "Tests successfully completed"
}
