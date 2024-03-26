# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"
SUBSLOT="18"

JAVA_PKG_OPT_USE="jdbc"

inherit systemd flag-o-matic prefix toolchain-funcs \
	multiprocessing java-pkg-opt-2 cmake

HOMEPAGE="https://mariadb.org/"
SRC_URI="mirror://mariadb/${PN}-${PV}/source/${P}.tar.gz
	https://github.com/hydrapolic/gentoo-dist/raw/master/mariadb/mariadb-10.6.13-patches-01.tar.xz"

DESCRIPTION="An enhanced, drop-in replacement for MySQL"
LICENSE="GPL-2 LGPL-2.1+"
SLOT="$(ver_cut 1-2)/${SUBSLOT:-0}"
IUSE="+backup bindist columnstore cracklib debug extraengine galera innodb-lz4
	innodb-lzo innodb-snappy jdbc jemalloc kerberos latin1 mroonga
	numa odbc oqgraph pam +perl profiling rocksdb selinux +server sphinx
	sst-rsync sst-mariabackup static systemd systemtap s3 tcmalloc
	test xml yassl"

RESTRICT="!bindist? ( bindist ) !test? ( test )"

REQUIRED_USE="jdbc? ( extraengine server !static )
	?? ( tcmalloc jemalloc )
	static? ( yassl !pam )
	test? ( extraengine )"

KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

# Shorten the path because the socket path length must be shorter than 107 chars
# and we will run a mysql server during test phase
S="${WORKDIR}/mysql"

# Be warned, *DEPEND are version-dependant
# These are used for both runtime and compiletime
COMMON_DEPEND="
	>=dev-libs/libpcre2-10.34:=
	>=sys-apps/texinfo-4.7-r1
	sys-libs/ncurses:0=
	>=sys-libs/zlib-1.2.3:0=
	virtual/libcrypt:=
	!bindist? (
		sys-libs/binutils-libs:0=
		>=sys-libs/readline-4.1:0=
	)
	jemalloc? ( dev-libs/jemalloc:0= )
	kerberos? ( virtual/krb5 )
	kernel_linux? (
		dev-libs/libaio:0=
		sys-libs/liburing:=
		sys-process/procps:0=
	)
	server? (
		app-arch/bzip2
		app-arch/xz-utils
		backup? ( app-arch/libarchive:0= )
		columnstore? (
			app-arch/snappy:=
			dev-libs/boost:=
			dev-libs/libxml2:2=
		)
		cracklib? ( sys-libs/cracklib:0= )
		extraengine? (
			odbc? ( dev-db/unixODBC:0= )
			xml? ( dev-libs/libxml2:2= )
		)
		innodb-lz4? ( app-arch/lz4 )
		innodb-lzo? ( dev-libs/lzo )
		innodb-snappy? ( app-arch/snappy:= )
		mroonga? ( app-text/groonga-normalizer-mysql >=app-text/groonga-7.0.4 )
		numa? ( sys-process/numactl )
		oqgraph? (
			dev-libs/boost:=
			dev-libs/judy:0=
		)
		pam? ( sys-libs/pam:0= )
		s3? ( net-misc/curl )
		systemd? ( sys-apps/systemd:= )
	)
	systemtap? ( >=dev-debug/systemtap-1.3:0= )
	tcmalloc? ( dev-util/google-perftools:0= )
	yassl? ( net-libs/gnutls:0= )
	!yassl? (
		>=dev-libs/openssl-1.0.0:0=
	)
"
BDEPEND="app-alternatives/yacc"
DEPEND="${COMMON_DEPEND}
	server? (
		extraengine? ( jdbc? ( >=virtual/jdk-1.8 ) )
		test? ( acct-group/mysql acct-user/mysql )
	)
	static? ( sys-libs/ncurses[static-libs] )
"
RDEPEND="${COMMON_DEPEND}
	!dev-db/mysql !dev-db/mariadb-galera !dev-db/percona-server !dev-db/mysql-cluster
	!dev-db/mariadb:0
	!dev-db/mariadb:5.5
	!dev-db/mariadb:10.1
	!dev-db/mariadb:10.2
	!dev-db/mariadb:10.3
	!dev-db/mariadb:10.4
	!dev-db/mariadb:10.5
	!dev-db/mariadb:10.7
	!dev-db/mariadb:10.8
	!dev-db/mariadb:10.9
	!dev-db/mariadb:10.10
	!dev-db/mariadb:10.11
	!dev-db/mariadb:11.0
	!<virtual/mysql-5.6-r11
	!<virtual/libmysqlclient-18-r1
	selinux? ( sec-policy/selinux-mysql )
	server? (
		columnstore? ( dev-db/mariadb-connector-c )
		extraengine? ( jdbc? ( >=virtual/jre-1.8 ) )
		galera? (
			sys-apps/iproute2
			=sys-cluster/galera-26*
			sst-rsync? ( sys-process/lsof )
			sst-mariabackup? ( net-misc/socat[ssl] )
		)
		!prefix? ( dev-db/mysql-init-scripts acct-group/mysql acct-user/mysql )
	)
"
# For other stuff to bring us in
# dev-perl/DBD-mysql is needed by some scripts installed by MySQL
PDEPEND="perl? ( >=dev-perl/DBD-mysql-2.9004 )"

QA_CONFIG_IMPL_DECL_SKIP=(
	# These don't exist on Linux
	pthread_threadid_np
	getthrid
)

mysql_init_vars() {
	MY_SHAREDSTATEDIR=${MY_SHAREDSTATEDIR="${EPREFIX}/usr/share/mariadb"}
	MY_SYSCONFDIR=${MY_SYSCONFDIR="${EPREFIX}/etc/mysql"}
	MY_LOCALSTATEDIR=${MY_LOCALSTATEDIR="${EPREFIX}/var/lib/mysql"}
	MY_LOGDIR=${MY_LOGDIR="${EPREFIX}/var/log/mysql"}

	if [[ -z "${MY_DATADIR}" ]] ; then
		MY_DATADIR=""
		if [[ -f "${MY_SYSCONFDIR}/my.cnf" ]] ; then
			MY_DATADIR=$(my_print_defaults mysqld 2>/dev/null \
				| sed -ne '/datadir/s|^--datadir=||p' \
				| tail -n1)
			if [[ -z "${MY_DATADIR}" ]] ; then
				MY_DATADIR=$(grep ^datadir "${MY_SYSCONFDIR}/my.cnf" \
				| sed -e 's/.*=\s*//' \
				| tail -n1)
			fi
		fi
		if [[ -z "${MY_DATADIR}" ]] ; then
			MY_DATADIR="${MY_LOCALSTATEDIR}"
			einfo "Using default MY_DATADIR"
		fi
		elog "MySQL MY_DATADIR is ${MY_DATADIR}"

		if [[ -z "${PREVIOUS_DATADIR}" ]] ; then
			if [[ -e "${MY_DATADIR}" ]] ; then
				# If you get this and you're wondering about it, see bug #207636
				elog "MySQL datadir found in ${MY_DATADIR}"
				elog "A new one will not be created."
				PREVIOUS_DATADIR="yes"
			else
				PREVIOUS_DATADIR="no"
			fi
			export PREVIOUS_DATADIR
		fi
	else
		if [[ ${EBUILD_PHASE} == "config" ]]; then
			local new_MY_DATADIR
			new_MY_DATADIR=$(my_print_defaults mysqld 2>/dev/null \
				| sed -ne '/datadir/s|^--datadir=||p' \
				| tail -n1)

			if [[ ( -n "${new_MY_DATADIR}" ) && ( "${new_MY_DATADIR}" != "${MY_DATADIR}" ) ]]; then
				ewarn "MySQL MY_DATADIR has changed"
				ewarn "from ${MY_DATADIR}"
				ewarn "to ${new_MY_DATADIR}"
				MY_DATADIR="${new_MY_DATADIR}"
			fi
		fi
	fi

	export MY_SHAREDSTATEDIR MY_SYSCONFDIR
	export MY_LOCALSTATEDIR MY_LOGDIR
	export MY_DATADIR
}

pkg_setup() {
	if [[ ${MERGE_TYPE} != binary ]] ; then
		if has test ${FEATURES} ; then
			# Bug #213475 - MySQL _will_ object strenuously if your machine is named
			# localhost. Also causes weird failures.
			[[ "${HOSTNAME}" == "localhost" ]] && die "Your machine must NOT be named localhost"

			if ! has userpriv ${FEATURES} ; then
				die "Testing with FEATURES=-userpriv is no longer supported by upstream. Tests MUST be run as non-root."
			fi
		fi
	fi

	java-pkg-opt-2_pkg_setup
}

src_unpack() {
	unpack ${A}

	mv -f "${WORKDIR}/${P/_rc/}" "${S}" || die
}

src_prepare() {
	eapply "${WORKDIR}"/mariadb-patches
	eapply "${FILESDIR}"/${PN}-10.6.11-gssapi.patch
	eapply "${FILESDIR}"/${PN}-10.6.11-include.patch
	eapply "${FILESDIR}"/${PN}-10.6.12-gcc-13.patch

	eapply_user

	_disable_plugin() {
		echo > "${S}/plugin/${1}/CMakeLists.txt" || die
	}
	_disable_engine() {
		echo > "${S}/storage/${1}/CMakeLists.txt" || die
	}

	if use jemalloc; then
		echo "TARGET_LINK_LIBRARIES(mariadbd LINK_PUBLIC jemalloc)" >> "${S}/sql/CMakeLists.txt"
	elif use tcmalloc; then
		echo "TARGET_LINK_LIBRARIES(mariadbd LINK_PUBLIC tcmalloc)" >> "${S}/sql/CMakeLists.txt"
	fi

	local plugin
	local server_plugins=( handler_socket auth_socket feedback metadata_lock_info
				locale_info qc_info server_audit sql_errlog auth_ed25519 )
	local test_plugins=( audit_null auth_examples daemon_example fulltext
				debug_key_management example_key_management versioning )
	if ! use server; then # These plugins are for the server
		for plugin in "${server_plugins[@]}" ; do
			_disable_plugin "${plugin}"
		done
	fi

	if ! use test; then # These plugins are only used during testing
		for plugin in "${test_plugins[@]}" ; do
			_disable_plugin "${plugin}"
		done
		_disable_engine test_sql_discovery
		echo > "${S}/plugin/auth_pam/testing/CMakeLists.txt" || die
	fi

	_disable_engine example

	if ! use oqgraph ; then # avoids extra library checks
		_disable_engine oqgraph
	fi

	if use mroonga ; then
		# Remove the bundled groonga
		# There is no CMake flag, it simply checks for existance
		rm -r "${S}"/storage/mroonga/vendor/groonga || die "could not remove packaged groonga"
	else
		_disable_engine mroonga
	fi

	# Fix static bindings in galera replication
	sed -i -e 's~add_library(wsrep_api_v26$~add_library(wsrep_api_v26 STATIC~' \
		"${S}"/wsrep-lib/wsrep-API/CMakeLists.txt || die
	sed -i -e 's~add_library(wsrep-lib$~add_library(wsrep-lib STATIC~' \
		"${S}"/wsrep-lib/src/CMakeLists.txt || die

	# Fix galera_recovery.sh script
	sed -i -e "s~@bindir@/my_print_defaults~${EPREFIX}/usr/libexec/mariadb/my_print_defaults~" \
		scripts/galera_recovery.sh || die

	sed -i -e 's~ \$basedir/lib/\*/mariadb19/plugin~~' \
		"${S}"/scripts/mysql_install_db.sh || die

	cmake_src_prepare
	java-pkg-opt-2_src_prepare
}

src_configure() {
	# bug #855233 (MDEV-11914, MDEV-25633) at least
	filter-lto
	# bug 508724 mariadb cannot use ld.gold
	tc-ld-disable-gold
	# Bug #114895, bug #110149
	filter-flags "-O" "-O[01]"

	# It fails on alpha without this
	use alpha && append-ldflags "-Wl,--no-relax"

	append-cxxflags -felide-constructors

	# bug #283926, with GCC4.4, this is required to get correct behavior.
	append-flags -fno-strict-aliasing

	CMAKE_BUILD_TYPE="RelWithDebInfo"

	# debug hack wrt #497532
	local mycmakeargs=(
		-DCMAKE_C_FLAGS_RELWITHDEBINFO="$(usex debug '' '-DNDEBUG')"
		-DCMAKE_CXX_FLAGS_RELWITHDEBINFO="$(usex debug '' '-DNDEBUG')"
		-DMYSQL_DATADIR="${EPREFIX}/var/lib/mysql"
		-DSYSCONFDIR="${EPREFIX}/etc/mysql"
		-DINSTALL_BINDIR=bin
		-DINSTALL_DOCDIR=share/doc/${PF}
		-DINSTALL_DOCREADMEDIR=share/doc/${PF}
		-DINSTALL_INCLUDEDIR=include/mysql
		-DINSTALL_INFODIR=share/info
		-DINSTALL_LIBDIR=$(get_libdir)
		-DINSTALL_MANDIR=share/man
		-DINSTALL_MYSQLSHAREDIR=share/mariadb
		-DINSTALL_PLUGINDIR=$(get_libdir)/mariadb/plugin
		-DINSTALL_SCRIPTDIR=bin
		-DINSTALL_MYSQLDATADIR="${EPREFIX}/var/lib/mysql"
		-DINSTALL_SBINDIR=sbin
		-DINSTALL_SUPPORTFILESDIR="${EPREFIX}/usr/share/mariadb"
		-DWITH_COMMENT="Gentoo Linux ${PF}"
		-DWITH_UNIT_TESTS=$(usex test ON OFF)
		-DWITH_LIBEDIT=0
		-DWITH_ZLIB=system
		-DWITHOUT_LIBWRAP=1
		-DENABLED_LOCAL_INFILE=1
		-DMYSQL_UNIX_ADDR="${EPREFIX}/var/run/mysqld/mysqld.sock"
		-DINSTALL_UNIX_ADDRDIR="${EPREFIX}/var/run/mysqld/mysqld.sock"
		-DWITH_DEFAULT_COMPILER_OPTIONS=0
		-DWITH_DEFAULT_FEATURE_SET=0
		-DINSTALL_SYSTEMD_UNITDIR="$(systemd_get_systemunitdir)"
		# The build forces this to be defined when cross-compiling.  We pass it
		# all the time for simplicity and to make sure it is actually correct.
		-DSTACK_DIRECTION=$(tc-stack-grows-down && echo -1 || echo 1)
		-DPKG_CONFIG_EXECUTABLE="${EPREFIX}/usr/bin/$(tc-getPKG_CONFIG)"
		-DPLUGIN_AUTH_GSSAPI=$(usex kerberos DYNAMIC NO)
		-DAUTH_GSSAPI_PLUGIN_TYPE=$(usex kerberos DYNAMIC OFF)
		-DCONC_WITH_EXTERNAL_ZLIB=YES
		-DWITH_EXTERNAL_ZLIB=YES
		-DSUFFIX_INSTALL_DIR=""
		-DWITH_UNITTEST=OFF
		-DWITHOUT_CLIENTLIBS=YES
		-DCLIENT_PLUGIN_DIALOG=OFF
		-DCLIENT_PLUGIN_AUTH_GSSAPI_CLIENT=OFF
		-DCLIENT_PLUGIN_CLIENT_ED25519=OFF
		-DCLIENT_PLUGIN_MYSQL_CLEAR_PASSWORD=STATIC
		-DCLIENT_PLUGIN_CACHING_SHA2_PASSWORD=OFF
	)
	if use test ; then
		mycmakeargs+=( -DINSTALL_MYSQLTESTDIR=share/mariadb/mysql-test )
	else
		mycmakeargs+=( -DINSTALL_MYSQLTESTDIR='' )
	fi

	if ! use yassl ; then
		mycmakeargs+=( -DWITH_SSL=system -DCLIENT_PLUGIN_SHA256_PASSWORD=STATIC )
	else
		mycmakeargs+=( -DWITH_SSL=bundled )
	fi

	# bfd.h is only used starting with 10.1 and can be controlled by NOT_FOR_DISTRIBUTION
	mycmakeargs+=(
		-DWITH_READLINE=$(usex bindist 1 0)
		-DNOT_FOR_DISTRIBUTION=$(usex bindist 0 1)
		-DENABLE_DTRACE=$(usex systemtap)
	)

	if use server ; then
		# Connect and Federated{,X} must be treated special
		# otherwise they will not be built as plugins
		if ! use extraengine ; then
			mycmakeargs+=(
				-DPLUGIN_CONNECT=NO
				-DPLUGIN_FEDERATED=NO
				-DPLUGIN_FEDERATEDX=NO
			)
		fi

		mycmakeargs+=(
			-DWITH_PCRE=system
			-DPLUGIN_OQGRAPH=$(usex oqgraph DYNAMIC NO)
			-DPLUGIN_SPHINX=$(usex sphinx YES NO)
			-DPLUGIN_AUTH_PAM=$(usex pam YES NO)
			-DPLUGIN_AWS_KEY_MANAGEMENT=NO
			-DPLUGIN_CRACKLIB_PASSWORD_CHECK=$(usex cracklib YES NO)
			-DPLUGIN_SEQUENCE=$(usex extraengine YES NO)
			-DPLUGIN_SPIDER=$(usex extraengine YES NO)
			-DPLUGIN_S3=$(usex s3 YES NO)
			-DPLUGIN_COLUMNSTORE=$(usex columnstore YES NO)
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
			-DPLUGIN_MROONGA=$(usex mroonga DYNAMIC NO)
			-DPLUGIN_AUTH_GSSAPI=$(usex kerberos DYNAMIC NO)
			-DWITH_MARIABACKUP=$(usex backup ON OFF)
			-DWITH_LIBARCHIVE=$(usex backup ON OFF)
			-DINSTALL_SQLBENCHDIR=""
			-DPLUGIN_ROCKSDB=$(usex rocksdb DYNAMIC NO)
			# systemd is only linked to for server notification
			-DWITH_SYSTEMD=$(usex systemd yes no)
			-DWITH_NUMA=$(usex numa ON OFF)
		)

		if use test ; then
			# This is needed for the new client lib which tests a real, open server
			mycmakeargs+=( -DSKIP_TESTS=ON )
		fi

		if [[ ( -n ${MYSQL_DEFAULT_CHARSET} ) && ( -n ${MYSQL_DEFAULT_COLLATION} ) ]]; then
			ewarn "You are using a custom charset of ${MYSQL_DEFAULT_CHARSET}"
			ewarn "and a collation of ${MYSQL_DEFAULT_COLLATION}."
			ewarn "You MUST file bugs without these variables set."

			mycmakeargs+=(
				-DDEFAULT_CHARSET=${MYSQL_DEFAULT_CHARSET}
				-DDEFAULT_COLLATION=${MYSQL_DEFAULT_COLLATION}
			)

		elif ! use latin1 ; then
			mycmakeargs+=(
				-DDEFAULT_CHARSET=utf8mb4
				-DDEFAULT_COLLATION=utf8mb4_unicode_520_ci
			)
		else
			mycmakeargs+=(
				-DDEFAULT_CHARSET=latin1
				-DDEFAULT_COLLATION=latin1_swedish_ci
			)
		fi
		mycmakeargs+=(
			-DEXTRA_CHARSETS=all
			-DMYSQL_USER=mysql
			-DDISABLE_SHARED=$(usex static YES NO)
			-DWITH_DEBUG=$(usex debug)
			-DWITH_EMBEDDED_SERVER=OFF
			-DWITH_PROFILING=$(usex profiling)
		)

		if use static; then
			mycmakeargs+=( -DWITH_PIC=1 )
		fi

		if use jemalloc || use tcmalloc ; then
			mycmakeargs+=( -DWITH_SAFEMALLOC=OFF )
		fi

		# Storage engines
		mycmakeargs+=(
			-DWITH_ARCHIVE_STORAGE_ENGINE=1
			-DWITH_BLACKHOLE_STORAGE_ENGINE=1
			-DWITH_CSV_STORAGE_ENGINE=1
			-DWITH_HEAP_STORAGE_ENGINE=1
			-DWITH_INNOBASE_STORAGE_ENGINE=1
			-DWITH_MYISAMMRG_STORAGE_ENGINE=1
			-DWITH_MYISAM_STORAGE_ENGINE=1
			-DWITH_PARTITION_STORAGE_ENGINE=1
		)
	else
		mycmakeargs+=(
			-DWITHOUT_SERVER=1
			-DWITH_EMBEDDED_SERVER=OFF
			-DEXTRA_CHARSETS=none
			-DINSTALL_SQLBENCHDIR=
			-DWITH_SYSTEMD=no
		)
	fi

	cmake_src_configure
}

src_compile() {
	cmake_src_compile
}

# Official test instructions:
# USE='extraengine perl server' \
# FEATURES='test userpriv' \
# ebuild mariadb-X.X.XX.ebuild \
# digest clean package
src_test() {
	_disable_test() {
		local rawtestname bug reason
		rawtestname="${1}" ; shift
		bug="${1}" ; shift
		reason="${@}"
		ewarn "test '${rawtestname}' disabled: '${reason}' (BUG#${bug})"
		echo "${rawtestname} : BUG#${bug} ${reason}" >> "${T}/disabled.def"
	}

	local TESTDIR="${BUILD_DIR}/mysql-test"
	local retstatus_tests

	if ! use server ; then
		einfo "Skipping server tests due to minimal build."
		return 0
	fi

	# Ensure that parallel runs don't die
	export MTR_BUILD_THREAD="$((${RANDOM} % 100))"

	if [[ -z "${MTR_PARALLEL}" ]] ; then
		local -x MTR_PARALLEL=$(makeopts_jobs)

		if [[ ${MTR_PARALLEL} -gt 4 ]] ; then
			# Running multiple tests in parallel usually require higher ulimit
			# and fs.aio-max-nr setting. In addition, tests like main.multi_update
			# are known to hit timeout when system is busy.
			# To avoid test failure we will limit MTR_PARALLEL to 4 instead of
			# using "auto".
			local info_msg="Parallel MySQL test suite jobs limited to 4 (MAKEOPTS=${MTR_PARALLEL})"
			info_msg+=" to avoid test failures. Set MTR_PARALLEL if you know what you are doing!"
			einfo "${info_msg}"
			unset info_msg
			MTR_PARALLEL=4
		fi
	else
		einfo "MTR_PARALLEL is set to '${MTR_PARALLEL}'"
	fi

	# Try to increase file limits to increase test coverage
	if ! ulimit -n 16500 1>/dev/null 2>&1 ; then
		# Upper limit comes from parts.partition_* tests
		ewarn "For maximum test coverage please raise open file limit to 16500 (ulimit -n 16500) before calling the package manager."

		if ! ulimit -n 4162 1>/dev/null 2>&1 ; then
			# Medium limit comes from '[Warning] Buffered warning: Could not increase number of max_open_files to more than 3000 (request: 4162)'
			ewarn "For medium test coverage please raise open file limit to 4162 (ulimit -n 4162) before calling the package manager."

			if ! ulimit -n 3000 1>/dev/null 2>&1 ; then
				ewarn "For minimum test coverage please raise open file limit to 3000 (ulimit -n 3000) before calling the package manager."
			else
				einfo "Will run test suite with open file limit set to 3000 (minimum test coverage)."
			fi
		else
			einfo "Will run test suite with open file limit set to 4162 (medium test coverage)."
		fi
	else
		einfo "Will run test suite with open file limit set to 16500 (best test coverage)."
	fi

	# create directories because mysqladmin might run out of order
	mkdir -p "${T}"/var-tests{,/log} || die

	if [[ ! -f "${S}/mysql-test/unstable-tests" ]] ; then
		touch "${S}"/mysql-test/unstable-tests || die
	fi

	cp "${S}"/mysql-test/unstable-tests "${T}/disabled.def" || die

	local -a disabled_tests
	disabled_tests+=( "compat/oracle.plugin;0;Needs example plugin which Gentoo disables" )
	disabled_tests+=( "innodb_gis.1;25095;Known rounding error with latest AMD processors" )
	disabled_tests+=( "innodb_gis.gis;25095;Known rounding error with latest AMD processors" )
	disabled_tests+=( "main.gis;25095;Known rounding error with latest AMD processors" )
	disabled_tests+=( "main.explain_non_select;0;Sporadically failing test" )
	disabled_tests+=( "main.func_time;0;Dependent on time test was written" )
	disabled_tests+=( "main.mysql_upgrade;27044;Sporadically failing test" )
	disabled_tests+=( "main.plugin_auth;0;Needs client libraries built" )
	disabled_tests+=( "main.selectivity_no_engine;26320;Sporadically failing test" )
	disabled_tests+=( "main.stat_tables;0;Sporadically failing test" )
	disabled_tests+=( "main.stat_tables_innodb;0;Sporadically failing test" )
	disabled_tests+=( "main.upgrade_MDEV-19650;25096;Known to be broken" )
	disabled_tests+=( "mariabackup.*;0;Broken test suite" )
	disabled_tests+=( "perfschema.nesting;23458;Known to be broken" )
	disabled_tests+=( "perfschema.prepared_statements;0;Broken test suite" )
	disabled_tests+=( "perfschema.privilege_table_io;27045;Sporadically failing test" )
	disabled_tests+=( "plugins.auth_ed25519;0;Needs client libraries built" )
	disabled_tests+=( "plugins.cracklib_password_check;0;False positive due to varying policies" )
	disabled_tests+=( "plugins.two_password_validations;0;False positive due to varying policies" )
	disabled_tests+=( "roles.acl_statistics;0;False positive due to a user count mismatch caused by previous test" )
	disabled_tests+=( "spider.*;0;Fails with network sandbox" )
	disabled_tests+=( "sys_vars.wsrep_on_without_provider;25625;Known to be broken" )

	if ! use latin1 ; then
		disabled_tests+=( "funcs_1.is_columns_mysql;0;Requires USE=latin1" )
		disabled_tests+=( "main.information_schema;0;Requires USE=latin1" )
		disabled_tests+=( "main.sp2;24177;Requires USE=latin1" )
		disabled_tests+=( "main.system_mysql_db;0;Requires USE=latin1" )
		disabled_tests+=( "main.upgrade_MDEV-19650;24178;Requires USE=latin1" )
	fi

	local test_infos_str test_infos_arr
	for test_infos_str in "${disabled_tests[@]}" ; do
		IFS=';' read -r -a test_infos_arr <<< "${test_infos_str}"

		if [[ ${#test_infos_arr[@]} != 3 ]] ; then
			die "Invalid test data set, not matching format: ${test_infos_str}"
		fi

		_disable_test "${test_infos_arr[0]}" "${test_infos_arr[1]}" "${test_infos_arr[2]}"
	done
	unset test_infos_str test_infos_arr

	# run mysql-test tests
	pushd "${TESTDIR}" &>/dev/null || die
	perl mysql-test-run.pl --force --vardir="${T}/var-tests" --reorder --skip-test-list="${T}/disabled.def"
	retstatus_tests=$?

	popd &>/dev/null || die

	# Cleanup is important for these testcases.
	pkill -9 -f "${S}/ndb" 2>/dev/null
	pkill -9 -f "${S}/sql" 2>/dev/null

	local failures=""
	[[ ${retstatus_tests} -eq 0 ]] || failures="${failures} tests"

	[[ -z "${failures}" ]] || die "Test failures: ${failures}"
	einfo "Tests successfully completed"
}

src_install() {
	cmake_src_install

	# Remove an unnecessary, private config header which will never match between ABIs and is not meant to be used
	if [[ -f "${ED}/usr/include/mysql/server/private/config.h" ]] ; then
		rm "${ED}/usr/include/mysql/server/private/config.h" || die
	fi

	# Make sure the vars are correctly initialized
	mysql_init_vars

	# Convenience links
	einfo "Making Convenience links for mysqlcheck multi-call binary"
	dosym "mysqlcheck" "/usr/bin/mysqlanalyze"
	dosym "mysqlcheck" "/usr/bin/mysqlrepair"
	dosym "mysqlcheck" "/usr/bin/mysqloptimize"

	# INSTALL_LAYOUT=STANDALONE causes cmake to create a /usr/data dir
	if [[ -d "${ED}/usr/data" ]] ; then
		rm -Rf "${ED}/usr/data" || die
	fi

	# Unless they explicitly specific USE=test, then do not install the
	# testsuite. It DOES have a use to be installed, esp. when you want to do a
	# validation of your database configuration after tuning it.
	if ! use test ; then
		rm -rf "${D}/${MY_SHAREDSTATEDIR}/mysql-test"
	fi

	# Configuration stuff
	einfo "Building default configuration ..."
	insinto "${MY_SYSCONFDIR#${EPREFIX}}"
	[[ -f "${S}/scripts/mysqlaccess.conf" ]] && doins "${S}"/scripts/mysqlaccess.conf
	cp "${FILESDIR}/my.cnf-10.2" "${TMPDIR}/my.cnf" || die
	eprefixify "${TMPDIR}/my.cnf"
	doins "${TMPDIR}/my.cnf"
	insinto "${MY_SYSCONFDIR#${EPREFIX}}/mariadb.d"
	cp "${FILESDIR}/my.cnf.distro-client" "${TMPDIR}/50-distro-client.cnf" || die
	eprefixify "${TMPDIR}/50-distro-client.cnf"
	doins "${TMPDIR}/50-distro-client.cnf"

	if use server ; then
		mycnf_src="my.cnf.distro-server"
		sed -e "s!@DATADIR@!${MY_DATADIR}!g" \
			"${FILESDIR}/${mycnf_src}" \
			> "${TMPDIR}/my.cnf.ok" || die
		if use prefix ; then
			sed -i -r -e '/^user[[:space:]]*=[[:space:]]*mysql$/d' \
				"${TMPDIR}/my.cnf.ok" || die
		fi
		if use latin1 ; then
			sed -i \
				-e "/character-set/s|utf8|latin1|g" \
				"${TMPDIR}/my.cnf.ok" || die
		fi
		eprefixify "${TMPDIR}/my.cnf.ok"
		newins "${TMPDIR}/my.cnf.ok" 50-distro-server.cnf

		einfo "Including support files and sample configurations"
		docinto "support-files"
		local script
		for script in \
			"${S}"/support-files/magic
		do
			[[ -f "$script" ]] && dodoc "${script}"
		done

		docinto "scripts"
		for script in "${S}"/scripts/mysql* ; do
			[[ ( -f "$script" ) && ( "${script%.sh}" == "${script}" ) ]] && dodoc "${script}"
		done
		# Manually install supporting files that conflict with other packages
		# but are needed for galera and initial installation
		exeinto /usr/libexec/mariadb
		doexe "${BUILD_DIR}/extra/my_print_defaults" "${BUILD_DIR}/extra/perror"

		if use pam ; then
			keepdir /usr/$(get_libdir)/mariadb/plugin/auth_pam_tool_dir
		fi
	fi

	# Conflicting files
	conflicting_files=()

	# We prefer my_print_defaults from dev-db/mysql-connector-c
	conflicting_files=( "${ED}/usr/share/man/man1/my_print_defaults.1" )

	# Remove bundled mytop in favor of dev-db/mytop
	conflicting_files+=( "${ED}/usr/bin/mytop" )
	conflicting_files+=( "${ED}/usr/share/man/man1/mytop.1" )

	local conflicting_file
	for conflicting_file in "${conflicting_files[@]}" ; do
		if [[ -e "${conflicting_file}" ]] ; then
			rm -v "${conflicting_file}" || die
		fi
	done

	# Fix a dangling symlink when galera is not built
	if [[ -L "${ED}/usr/bin/wsrep_sst_rsync_wan" ]] && ! use galera ; then
		rm "${ED}/usr/bin/wsrep_sst_rsync_wan" || die
	fi

	# Remove dangling symlink
	rm "${ED}/usr/$(get_libdir)/libmariadb.a" || die

	# Remove broken SST scripts that are incompatible
	local scriptremove
	for scriptremove in wsrep_sst_xtrabackup wsrep_sst_xtrabackup-v2 ; do
		if [[ -e "${ED}/usr/bin/${scriptremove}" ]] ; then
			rm "${ED}/usr/bin/${scriptremove}" || die
		fi
	done
}

pkg_preinst() {
	java-pkg-opt-2_pkg_preinst
}

pkg_postinst() {
	# Make sure the vars are correctly initialized
	mysql_init_vars

	# Create log directory securely if it does not exist
	[[ -d "${ROOT}/${MY_LOGDIR}" ]] || install -d -m0750 -o mysql -g mysql "${ROOT}/${MY_LOGDIR}"

	if use server ; then
		if use pam; then
			einfo
			elog "This install includes the PAM authentication plugin."
			elog "To activate and configure the PAM plugin, please read:"
			elog "https://mariadb.com/kb/en/mariadb/pam-authentication-plugin/"
			einfo
			chown mysql:mysql "${EROOT}/usr/$(get_libdir)/mariadb/plugin/auth_pam_tool_dir" || die
		fi

		if [[ -z "${REPLACING_VERSIONS}" ]] ; then
			einfo
			elog "You might want to run:"
			elog "\"emerge --config =${CATEGORY}/${PF}\""
			elog "if this is a new install."
			elog
			elog "If you are switching server implentations, you should run the"
			elog "mysql_upgrade tool."
			einfo
		else
			einfo
			elog "If you are upgrading major versions, you should run the"
			elog "mysql_upgrade tool."
			einfo
		fi

		if use galera ; then
			einfo
			elog "Be sure to edit the my.cnf file to activate your cluster settings."
			elog "This should be done after running \"emerge --config =${CATEGORY}/${PF}\""
			elog "The first time the cluster is activated, you should add"
			elog "--wsrep-new-cluster to the options in /etc/conf.d/mysql for one node."
			elog "This option should then be removed for subsequent starts."
			einfo
			if [[ -n "${REPLACING_VERSIONS}" ]] ; then
				local rver
				for rver in ${REPLACING_VERSIONS} ; do
					if ver_test "${rver}" -lt "10.4.0" ; then
						ewarn "Upgrading galera from a previous version requires admin restart of the entire cluster."
						ewarn "Please refer to https://mariadb.com/kb/en/library/changes-improvements-in-mariadb-104/#galera-4"
						ewarn "for more information"
					fi
				done
			fi
		fi
	fi

	# Note about configuration change
	einfo
	elog "This version of mariadb reorganizes the configuration from a single my.cnf"
	elog "to several files in /etc/mysql/${PN}.d."
	elog "Please backup any changes you made to /etc/mysql/my.cnf"
	elog "and add them as a new file under /etc/mysql/${PN}.d with a .cnf extension."
	elog "You may have as many files as needed and they are read alphabetically."
	elog "Be sure the options have the appropriate section headers, i.e. [mysqld]."
	einfo
}

pkg_config() {
	_getoptval() {
		local section="${1}"
		local option="--${2}"
		local extra_options="${3}"
		local cmd=(
			"${my_print_defaults_binary}"
			"${extra_options}"
			"${section}"
		)

		local values=()
		local parameters=( $(eval "${cmd[@]}" 2>/dev/null) )
		for parameter in "${parameters[@]}"
		do
			# my_print_defaults guarantees output of options, one per line,
			# in the form that they would be specified on the command line.
			# So checking for --option=* should be safe.
			case ${parameter} in
				${option}=*)
					values+=( "${parameter#*=}" )
					;;
			esac
		done

		if [[ ${#values[@]} -gt 0 ]] ; then
			# Option could have been set multiple times
			# in which case only the last occurrence
			# contains the current value
			echo "${values[-1]}"
		fi
	}

	_mktemp_dry() {
		# emktemp has no --dry-run option
		local template="${1}"

		if [[ -z "${template}" ]] ; then
			if [[ -z "${T}" ]] ; then
				template="/tmp/XXXXXXX"
			else
				template="${T}/XXXXXXX"
			fi
		fi

		local template_wo_X=${template//X/}
		local n_X
		let n_X=${#template}-${#template_wo_X}
		if [[ ${n_X} -lt 3 ]] ; then
			echo "${FUNCNAME[0]}: too few X's in template ‘${template}’" >&2
			return
		fi

		local attempts=0
		local character tmpfile
		while [[ true ]] ; do
			let attempts=attempts+1

			new_file=
			while read -n1 character ; do
				if [[ "${character}" == "X" ]] ; then
					tmpfile+="${RANDOM:0:1}"
				else
					tmpfile+="${character}"
				fi
			done < <(echo -n "${template}")

			if [[ ! -f "${tmpfile}" ]]
			then
				echo "${tmpfile}"
				return
			fi

			if [[ ${attempts} -ge 100 ]] ; then
				echo "${FUNCNAME[0]}: Cannot create temporary file after 100 attempts." >&2
				return
			fi
		done
	}

	local mysql_binary="${EROOT}/usr/bin/mysql"
	if [[ ! -x "${mysql_binary}" ]] ; then
		die "'${mysql_binary}' not found! Please re-install ${CATEGORY}/${PN}!"
	fi

	local mysqld_binary="${EROOT}/usr/sbin/mysqld"
	if [[ ! -x "${mysqld_binary}" ]] ; then
		die "'${mysqld_binary}' not found! Please re-install ${CATEGORY}/${PN}!"
	fi

	local mysql_install_db_binary="${EROOT}/usr/bin/mysql_install_db"
	if [[ ! -x "${mysql_install_db_binary}" ]] ; then
		die "'${mysql_install_db_binary}' not found! Please re-install ${CATEGORY}/${PN}!"
	fi

	local my_print_defaults_binary="${EROOT}/usr/bin/my_print_defaults"
	if [[ ! -x "${my_print_defaults_binary}" ]] ; then
		die "'${my_print_defaults_binary}' not found! Please re-install dev-db/mysql-connector-c!"
	fi

	if [[ -z "${MYSQL_USER}" ]] ; then
		MYSQL_USER=mysql
		if use prefix ; then
			MYSQL_USER=$(id -u -n 2>/dev/null)
			if [[ -z "${MYSQL_USER}" ]] ; then
				die "Failed to determine current username!"
			fi
		fi
	fi

	if [[ -z "${MYSQL_GROUP}" ]] ; then
		MYSQL_GROUP=mysql
		if use prefix ; then
			MYSQL_GROUP=$(id -g -n 2>/dev/null)
			if [[ -z "${MYSQL_GROUP}" ]] ; then
				die "Failed to determine current user groupname!"
			fi
		fi
	fi

	# my_print_defaults needs to read stuff in $HOME/.my.cnf
	local -x HOME="${EROOT}/root"

	# Make sure the vars are correctly initialized
	mysql_init_vars

	# Read currently set data directory
	MY_DATADIR="$(_getoptval mysqld datadir "--defaults-file='${MY_SYSCONFDIR}/my.cnf'")"

	# Bug #213475 - MySQL _will_ object strenously if your machine is named
	# localhost. Also causes weird failures.
	[[ "${HOSTNAME}" == "localhost" ]] && die "Your machine must NOT be named localhost"

	if [[ -z "${MY_DATADIR}" ]] ; then
		die "Sorry, unable to find MY_DATADIR!"
	elif [[ -d "${MY_DATADIR}/mysql" ]] ; then
		ewarn "Looks like your data directory '${MY_DATADIR}' is already initialized!"
		ewarn "Please rename or delete its content if you wish to initialize a new data directory."
		die "${PN} data directory at '${MY_DATADIR}' looks already initialized!"
	fi

	MYSQL_TMPDIR="$(_getoptval mysqld tmpdir "--defaults-file='${MY_SYSCONFDIR}/my.cnf'")"
	MYSQL_TMPDIR=${MYSQL_TMPDIR%/}
	# These are dir+prefix
	MYSQL_LOG_BIN="$(_getoptval mysqld log-bin "--defaults-file='${MY_SYSCONFDIR}/my.cnf'")"
	MYSQL_LOG_BIN=${MYSQL_LOG_BIN%/*}
	MYSQL_RELAY_LOG="$(_getoptval mysqld relay-log "--defaults-file='${MY_SYSCONFDIR}/my.cnf'")"
	MYSQL_RELAY_LOG=${MYSQL_RELAY_LOG%/*}

	# Create missing directories.
	# Always check if mysql user can write to directory even if we just
	# created directory because a parent directory might be not
	# accessible for that user.
	PID_DIR="${EROOT}/run/mysqld"
	if [[ ! -d "${PID_DIR}" ]] ; then
		einfo "Creating ${PN} PID directory '${PID_DIR}' ..."
		install -d -m 755 -o ${MYSQL_USER} -g ${MYSQL_GROUP} "${PID_DIR}" \
			|| die "Failed to create PID directory '${PID_DIR}'!"
	fi

	local _pid_dir_testfile="$(_mktemp_dry "${PID_DIR}/.pkg_config-access-test.XXXXXXXXX")"
	[[ -z "${_pid_dir_testfile}" ]] \
		&& die "_mktemp_dry() for '${PID_DIR}/.pkg_config-access-test.XXXXXXXXX' failed!"

	if use prefix ; then
		touch "${_pid_dir_testfile}" &>/dev/null
	else
		su -s /bin/sh -c "touch ${_pid_dir_testfile}" ${MYSQL_USER} &>/dev/null
	fi

	if [[ $? -ne 0 ]] ; then
		die "${MYSQL_USER} user cannot write into PID dir '${PID_DIR}'!"
	else
		rm "${_pid_dir_testfile}" || die
		unset _pid_dir_testfile
	fi

	if [[ ! -d "${MY_DATADIR}" ]] ; then
		einfo "Creating ${PN} data directory '${MY_DATADIR}' ..."
		install -d -m 770 -o ${MYSQL_USER} -g ${MYSQL_GROUP} "${MY_DATADIR}" \
			|| die "Failed to create ${PN} data directory '${MY_DATADIR}'!"
	fi

	local _my_datadir_testfile="$(_mktemp_dry "${MY_DATADIR}/.pkg_config-access-test.XXXXXXXXX")"
	[[ -z "${_my_datadir_testfile}" ]] \
		&& die "_mktemp_dry() for '${MY_DATADIR}/.pkg_config-access-test.XXXXXXXXX' failed!"

	if use prefix ; then
		touch "${_my_datadir_testfile}" &>/dev/null
	else
		su -s /bin/sh -c "touch ${_my_datadir_testfile}" ${MYSQL_USER} &>/dev/null
	fi

	if [[ $? -ne 0 ]] ; then
		die "${MYSQL_USER} user cannot write into data directory '${MY_DATADIR}'!"
	else
		rm "${_my_datadir_testfile}" || die
		unset _my_datadir_testfile
	fi

	if [[ -n "${MYSQL_TMPDIR}" && ! -d "${MYSQL_TMPDIR}" ]] ; then
		einfo "Creating ${PN} tmpdir '${MYSQL_TMPDIR}' ..."
		install -d -m 770 -o ${MYSQL_USER} -g ${MYSQL_GROUP} "${MYSQL_TMPDIR}" \
			|| die "Failed to create ${PN} tmpdir '${MYSQL_TMPDIR}'!"
	fi

	if [[ -z "${MYSQL_TMPDIR}" ]] ; then
		MYSQL_TMPDIR="$(_mktemp_dry "${EROOT}/tmp/mysqld-tmp.XXXXXXXXX")"
		[[ -z "${MYSQL_TMPDIR}" ]] \
			&& die "_mktemp_dry() for '${MYSQL_TMPDIR}' failed!"

		mkdir "${MYSQL_TMPDIR}" || die
		chown ${MYSQL_USER} "${MYSQL_TMPDIR}" || die
	fi

	# Now we need to test MYSQL_TMPDIR...
	local _my_tmpdir_testfile="$(_mktemp_dry "${MYSQL_TMPDIR}/.pkg_config-access-test.XXXXXXXXX")"
	[[ -z "${_my_tmpdir_testfile}" ]] \
		&& die "_mktemp_dry() for '${MYSQL_TMPDIR}/.pkg_config-access-test.XXXXXXXXX' failed!"

	if use prefix ; then
		touch "${_my_tmpdir_testfile}" &>/dev/null
	else
		su -s /bin/sh -c "touch ${_my_tmpdir_testfile}" ${MYSQL_USER} &>/dev/null
	fi

	if [[ $? -ne 0 ]] ; then
		die "${MYSQL_USER} user cannot write into tmpdir '${MYSQL_TMPDIR}'!"
	else
		rm "${_my_tmpdir_testfile}" || die
		unset _my_tmpdir_testfile
	fi

	if [[ "${MYSQL_LOG_BIN}" == /* && ! -d "${MYSQL_LOG_BIN}" ]] ; then
		# Only create directory when MYSQL_LOG_BIN is an absolute path
		einfo "Creating ${PN} log-bin directory '${MYSQL_LOG_BIN}' ..."
		install -d -m 770 -o ${MYSQL_USER} -g ${MYSQL_GROUP} "${MYSQL_LOG_BIN}" \
			|| die "Failed to create ${PN} log-bin directory '${MYSQL_LOG_BIN}'"
	fi

	if [[ "${MYSQL_LOG_BIN}" == /* ]] ; then
		# Only test when MYSQL_LOG_BIN is an absolute path
		local _my_logbin_testfile="$(_mktemp_dry "${MYSQL_LOG_BIN}/.pkg_config-access-test.XXXXXXXXX")"
		[[ -z "${_my_logbin_testfile}" ]] \
			&& die "_mktemp_dry() for '${MYSQL_LOG_BIN}/.pkg_config-access-test.XXXXXXXXX' failed!"

		if use prefix ; then
			touch "${_my_logbin_testfile}" &>/dev/null
		else
			su -s /bin/sh -c "touch ${_my_logbin_testfile}" ${MYSQL_USER} &>/dev/null
		fi

		if [[ $? -ne 0 ]] ; then
			die "${MYSQL_USER} user cannot write into log-bin directory '${MYSQL_LOG_BIN}'!"
		else
			rm "${_my_logbin_testfile}" || die
			unset _my_logbin_testfile
		fi
	fi

	if [[ "${MYSQL_RELAY_LOG}" == /* && ! -d "${MYSQL_RELAY_LOG}" ]] ; then
		# Only create directory when MYSQL_RELAY_LOG is an absolute path
		einfo "Creating ${PN} relay-log directory '${MYSQL_RELAY_LOG}' ..."
		install -d -m 770 -o ${MYSQL_USER} -g ${MYSQL_GROUP} "${MYSQL_RELAY_LOG}" \
			|| die "Failed to create ${PN} relay-log directory '${MYSQL_RELAY_LOG}'!"
	fi

	if [[ "${MYSQL_RELAY_LOG}" == /* ]] ; then
		# Only test when MYSQL_RELAY_LOG is an absolute path
		local _my_relaylog_testfile="$(_mktemp_dry "${MYSQL_RELAY_LOG}/.pkg_config-access-test.XXXXXXXXX")"
		[[ -z "${_my_relaylog_testfile}" ]] \
			&& die "_mktemp_dry() for '${MYSQL_RELAY_LOG}/.pkg_config-access-test.XXXXXXXXX' failed!"

		if use prefix ; then
			touch "${_my_relaylog_testfile}" &>/dev/null
		else
			su -s /bin/sh -c "touch ${_my_relaylog_testfile}" ${MYSQL_USER} &>/dev/null
		fi

		if [[ $? -ne 0 ]] ; then
			die "${MYSQL_USER} user cannot write into relay-log directory '${MYSQL_RELAY_LOG}'!"
		else
			rm "${_my_relaylog_testfile}" || die
			unset _my_relaylog_testfile
		fi
	fi

	local SETUP_TMPDIR=$(mktemp -d "/tmp/${PN}-config.XXXXXXXXX" 2>/dev/null)
	[[ -z "${SETUP_TMPDIR}" ]] && die "Failed to create setup tmpdir"

	# Limit access
	chmod 0770 "${SETUP_TMPDIR}" || die
	chown ${MYSQL_USER} "${SETUP_TMPDIR}" || die

	local mysql_install_log="${SETUP_TMPDIR}/install_db.log"
	local mysqld_logfile="${SETUP_TMPDIR}/mysqld.log"

	echo ""
	einfo "Detected settings:"
	einfo "=================="
	einfo "MySQL User:\t\t\t\t${MYSQL_USER}"
	einfo "MySQL Group:\t\t\t\t${MYSQL_GROUP}"
	einfo "MySQL DATA directory:\t\t${MY_DATADIR}"
	einfo "MySQL TMP directory:\t\t\t${MYSQL_TMPDIR}"

	if [[ "${MYSQL_LOG_BIN}" == /* ]] ; then
		# Absolute path for binary log files specified
		einfo "MySQL Binary Log File location:\t${MYSQL_LOG_BIN}"
	fi

	if [[ "${MYSQL_RELAY_LOG}" == /* ]] ; then
		# Absolute path for relay log files specified
		einfo "MySQL Relay Log File location:\t${MYSQL_RELAY_LOG}"
	fi

	einfo "PID DIR:\t\t\t\t${PID_DIR}"
	einfo "Install db log:\t\t\t${mysql_install_log}"
	einfo "Install server log:\t\t\t${mysqld_logfile}"

	echo

	if [[ -z "${MYSQL_ROOT_PASSWORD}" ]] ; then
		local tmp_mysqld_password_source=

		for tmp_mysqld_password_source in mysql client ; do
			einfo "Trying to get password for mysql 'root' user from '${tmp_mysqld_password_source}' section ..."
			MYSQL_ROOT_PASSWORD="$(_getoptval "${tmp_mysqld_password_source}" password)"
			if [[ -n "${MYSQL_ROOT_PASSWORD}" ]] ; then
				if [[ ${MYSQL_ROOT_PASSWORD} == *$'\n'* ]] ; then
					ewarn "Ignoring password from '${tmp_mysqld_password_source}' section due to newline character (do you have multiple password options set?)!"
					MYSQL_ROOT_PASSWORD=
					continue
				fi

				einfo "Found password in '${tmp_mysqld_password_source}' section!"
				break
			fi
		done

		# Sometimes --show is required to display passwords in some implementations of my_print_defaults
		if [[ "${MYSQL_ROOT_PASSWORD}" == '*****' ]] ; then
			MYSQL_ROOT_PASSWORD="$(_getoptval "${tmp_mysqld_password_source}" password --show)"
		fi

		unset tmp_mysqld_password_source
	fi

	if [[ -z "${MYSQL_ROOT_PASSWORD}" ]] ; then
		local pwd1="a"
		local pwd2="b"

		echo
		einfo "No password for mysql 'root' user was specified via environment"
		einfo "variable MYSQL_ROOT_PASSWORD and no password was found in config"
		einfo "file like '${HOME}/.my.cnf'."
		einfo "To continue please provide a password for the mysql 'root' user"
		einfo "now on console:"
		ewarn "NOTE: Please avoid [\"'\\_%] characters in the password!"
		read -rsp "    >" pwd1 ; echo

		einfo "Retype the password"
		read -rsp "    >" pwd2 ; echo

		if [[ "x${pwd1}" != "x${pwd2}" ]] ; then
			die "Passwords are not the same!"
		fi

		MYSQL_ROOT_PASSWORD="${pwd1}"
		unset pwd1 pwd2

		echo
	fi

	local -a mysqld_options

	# Fix bug 446200. Don't reference host my.cnf, needs to come first,
	# see http://bugs.mysql.com/bug.php?id=31312
	use prefix && mysqld_options+=( "--defaults-file='${MY_SYSCONFDIR}/my.cnf'" )

	# Figure out which options we need to disable to do the setup
	local helpfile="${TMPDIR}/mysqld-help"
	"${EROOT}/usr/sbin/mysqld" --verbose --help >"${helpfile}" 2>/dev/null

	local opt optexp optfull
	for opt in host-cache name-resolve networking slave-start \
		federated ssl log-bin relay-log slow-query-log external-locking \
		log-slave-updates \
	; do
		optexp="--(skip-)?${opt}" optfull="--loose-skip-${opt}"
		grep -E -sq -- "${optexp}" "${helpfile}" && mysqld_options+=( "${optfull}" )
	done

	# Prepare timezones, see
	# https://dev.mysql.com/doc/mysql/en/time-zone-support.html
	local tz_sql="${SETUP_TMPDIR}/tz.sql"

	echo "USE mysql;" >"${tz_sql}"
	"${EROOT}/usr/bin/mysql_tzinfo_to_sql" "${EROOT}/usr/share/zoneinfo" >> "${tz_sql}" 2>/dev/null
	if [[ $? -ne 0 ]] ; then
		die "mysql_tzinfo_to_sql failed!"
	fi

	local cmd=(
		"${mysql_install_db_binary}"
		"${mysqld_options[@]}"
		"--init-file='${tz_sql}'"
		"--basedir='${EROOT}/usr'"
		"--datadir='${MY_DATADIR}'"
		"--tmpdir='${MYSQL_TMPDIR}'"
		"--log-error='${mysql_install_log}'"
		"--rpm"
		"--cross-bootstrap"
		"--skip-test-db"
		"--user=${MYSQL_USER}"
	)

	einfo "Initializing ${PN} data directory: ${cmd[@]}"
	eval "${cmd[@]}" >>"${mysql_install_log}" 2>&1

	if [[ $? -ne 0 || ! -f "${MY_DATADIR}/mysql/user.frm" ]] ; then
		grep -B5 -A999 -iE "(Aborting|ERROR|errno)" "${mysql_install_log}" 1>&2
		die "Failed to initialize ${PN} data directory. Please review '${mysql_install_log}'!"
	fi

	local x=${RANDOM}
	local socket="${PID_DIR}/mysqld.${x}.sock"
	[[ -f "${socket}" ]] && die "Randomness failed; Socket ${socket} already exists!"
	local pidfile="${PID_DIR}/mysqld.${x}.pid"
	[[ -f "${pidfile}" ]] && die "Randomness failed; Pidfile ${pidfile} already exists!"
	unset x

	cmd=(
		"${mysqld_binary}"
		"${mysqld_options[@]}"
		"--basedir='${EROOT}/usr'"
		"--datadir='${MY_DATADIR}'"
		"--tmpdir='${MYSQL_TMPDIR}'"
		--max_allowed_packet=8M
		--net_buffer_length=16K
		"--socket='${socket}'"
		"--pid-file='${pidfile}'"
		"--log-error='${mysqld_logfile}'"
		"--user=${MYSQL_USER}"
	)

	einfo "Starting mysqld to finalize initialization: ${cmd[@]}"
	eval "${cmd[@]}" >>"${mysqld_logfile}" 2>&1 &

	echo -n "Waiting for mysqld to accept connections "
	local maxtry=15
	while [[ ! -S "${socket}" && "${maxtry}" -gt 1 ]] ; do
		maxtry=$((${maxtry}-1))
		echo -n "."
		sleep 1
	done

	if [[ -S "${socket}" ]] ; then
		# Even with a socket we don't know if mysqld will abort
		# start due to an error so just wait a little bit more...
		maxtry=5
		while [[ -S "${socket}" && "${maxtry}" -gt 1 ]] ; do
			maxtry=$((${maxtry}-1))
			echo -n "."
			sleep 1
		done
	fi

	echo

	if [[ ! -S "${socket}" ]] ; then
		grep -B5 -A999 -iE "(Aborting|ERROR|errno)" "${mysqld_logfile}" 1>&2
		die "mysqld was unable to start from initialized data directory. Please review '${mysqld_logfile}'!"
	fi

	local mysql_logfile="${SETUP_TMPDIR}/set_root_pw.log"
	touch "${mysql_logfile}" || die

	ebegin "Setting root password"
	# Do this from memory, as we don't want clear text passwords in temp files
	local sql="ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}'"
	cmd=(
		"${mysql_binary}"
		--no-defaults
		"--socket='${socket}'"
		-hlocalhost
		"-e \"${sql}\""
	)
	eval "${cmd[@]}" >"${mysql_logfile}" 2>&1
	local rc=$?
	eend ${rc}

	if [[ ${rc} -ne 0 ]] ; then
		# Poor man's solution which tries to avoid having password
		# in log.  NOTE: sed can fail if user didn't follow advice
		# and included character which will require escaping...
		sed -i -e "s/${MYSQL_ROOT_PASSWORD}/*****/" "${mysql_logfile}" 2>/dev/null

		grep -B5 -A999 -iE "(Aborting|ERROR|errno)" "${mysql_logfile}"
		die "Failed to set ${PN} root password. Please review '${mysql_logfile}'!"
	fi

	# Stop the server
	if [[ -f "${pidfile}" ]] && pgrep -F "${pidfile}" &>/dev/null ; then
		echo -n "Stopping the server "
		pkill -F "${pidfile}" &>/dev/null

		maxtry=10
		while [[ -f "${pidfile}" ]] && pgrep -F "${pidfile}" &>/dev/null ; do
			maxtry=$((${maxtry}-1))
			echo -n "."
			sleep 1
		done

		echo

		if [[ -f "${pidfile}" ]] && pgrep -F "${pidfile}" &>/dev/null ; then
			# We somehow failed to stop server.
			# However, not a fatal error. Just warn the user.
			ewarn "WARNING: mysqld[$(cat "${pidfile}")] is still running!"
		fi
	fi

	rm -r "${SETUP_TMPDIR}" || die

	einfo "${PN} data directory at '${MY_DATADIR}' successfully initialized!"
}
