# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
SUBSLOT="18"

JAVA_PKG_OPT_USE="jdbc"

inherit eutils systemd flag-o-matic prefix toolchain-funcs \
	multiprocessing java-pkg-opt-2 cmake

# Patch version
PATCH_SET="https://dev.gentoo.org/~whissi/dist/${PN}/${PN}-10.3.24-patches-01.tar.xz"

SRC_URI="https://downloads.mariadb.org/interstitial/${P}/source/${P}.tar.gz
	${PATCH_SET}"

HOMEPAGE="https://mariadb.org/"
DESCRIPTION="An enhanced, drop-in replacement for MySQL"
LICENSE="GPL-2 LGPL-2.1+"
SLOT="10.3/${SUBSLOT:-0}"
IUSE="+backup bindist client-libs cracklib debug extraengine galera innodb-lz4
	innodb-lzo innodb-snappy jdbc jemalloc kerberos latin1 libressl mroonga
	numa odbc oqgraph pam +perl profiling rocksdb selinux +server sphinx
	sst-rsync sst-mariabackup static systemd systemtap tcmalloc
	test tokudb xml yassl"

# Tests always fail when libressl is enabled due to hard-coded ciphers in the tests
RESTRICT="!bindist? ( bindist ) libressl? ( test ) !test? ( test )"

REQUIRED_USE="jdbc? ( extraengine server !static )
	server? ( tokudb? ( jemalloc !tcmalloc ) )
	?? ( tcmalloc jemalloc )
	static? ( yassl !pam )"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"

# Shorten the path because the socket path length must be shorter than 107 chars
# and we will run a mysql server during test phase
S="${WORKDIR}/mysql"

# Be warned, *DEPEND are version-dependant
# These are used for both runtime and compiletime
COMMON_DEPEND="
	kernel_linux? (
		sys-process/procps:0=
		dev-libs/libaio:0=
	)
	>=sys-apps/sed-4
	>=sys-apps/texinfo-4.7-r1
	jemalloc? ( dev-libs/jemalloc:0= )
	tcmalloc? ( dev-util/google-perftools:0= )
	systemtap? ( >=dev-util/systemtap-1.3:0= )
	>=sys-libs/zlib-1.2.3:0=
	kerberos? ( virtual/krb5 )
	yassl? ( net-libs/gnutls:0= )
	!yassl? (
		!libressl? ( >=dev-libs/openssl-1.0.0:0= )
		libressl? ( dev-libs/libressl:0= )
	)
	sys-libs/ncurses:0=
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
		)
		innodb-lz4? ( app-arch/lz4 )
		innodb-lzo? ( dev-libs/lzo )
		innodb-snappy? ( app-arch/snappy )
		mroonga? ( app-text/groonga-normalizer-mysql >=app-text/groonga-7.0.4 )
		numa? ( sys-process/numactl )
		oqgraph? ( >=dev-libs/boost-1.40.0:0= dev-libs/judy:0= )
		pam? ( sys-libs/pam:0= )
		systemd? ( sys-apps/systemd:= )
		tokudb? ( app-arch/snappy )
	)
	>=dev-libs/libpcre-8.41-r1:3=
"
BDEPEND="virtual/yacc
	|| ( >=sys-devel/gcc-3.4.6 >=sys-devel/gcc-apple-4.0 )
"
DEPEND="static? ( sys-libs/ncurses[static-libs] )
	server? (
		extraengine? ( jdbc? ( >=virtual/jdk-1.6 ) )
		test? ( acct-group/mysql acct-user/mysql )
	)
	${COMMON_DEPEND}"
RDEPEND="selinux? ( sec-policy/selinux-mysql )
	!dev-db/mysql !dev-db/mariadb-galera !dev-db/percona-server !dev-db/mysql-cluster
	!dev-db/mariadb:0
	!dev-db/mariadb:5.5
	!dev-db/mariadb:10.1
	!dev-db/mariadb:10.2
	!dev-db/mariadb:10.4
	!dev-db/mariadb:10.5
	!<virtual/mysql-5.6-r11
	${COMMON_DEPEND}
	server? (
		galera? (
			sys-apps/iproute2
			=sys-cluster/galera-25*
			sst-rsync? ( sys-process/lsof )
			sst-mariabackup? ( net-misc/socat[ssl] )
		)
		!prefix? ( dev-db/mysql-init-scripts acct-group/mysql acct-user/mysql )
		extraengine? ( jdbc? ( >=virtual/jre-1.6 ) )
	)
	perl? (
		!dev-db/mytop
		virtual/perl-Getopt-Long
		dev-perl/TermReadKey
		virtual/perl-Term-ANSIColor
		virtual/perl-Time-HiRes
	)
"
# For other stuff to bring us in
# dev-perl/DBD-mysql is needed by some scripts installed by MySQL
PDEPEND="perl? ( >=dev-perl/DBD-mysql-2.9004 )"

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
		local GCC_MAJOR_SET=$(gcc-major-version)
		local GCC_MINOR_SET=$(gcc-minor-version)

		if use tokudb && [[ ${GCC_MAJOR_SET} -lt 4 || \
			${GCC_MAJOR_SET} -eq 4 && ${GCC_MINOR_SET} -lt 7 ]] ; then
			eerror "${PN} with tokudb needs to be built with gcc-4.7 or later."
			eerror "Please use gcc-config to switch to gcc-4.7 or later version."
			die
		fi

		# Bug 565584.  InnoDB now requires atomic functions introduced with gcc-4.7 on
		# non x86{,_64} arches
		if ! use amd64 && ! use x86 && [[ ${GCC_MAJOR_SET} -lt 4 || \
			${GCC_MAJOR_SET} -eq 4 && ${GCC_MINOR_SET} -lt 7 ]] ; then
			eerror "${PN} needs to be built with gcc-4.7 or later."
			eerror "Please use gcc-config to switch to gcc-4.7 or later version."
			die
		fi

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

	eapply_user

	_disable_plugin() {
		echo > "${S}/plugin/${1}/CMakeLists.txt" || die
	}
	_disable_engine() {
		echo > "${S}/storage/${1}/CMakeLists.txt" || die
	}

	if use jemalloc; then
		echo "TARGET_LINK_LIBRARIES(mysqld jemalloc)" >> "${S}/sql/CMakeLists.txt"
	elif use tcmalloc; then
		echo "TARGET_LINK_LIBRARIES(mysqld tcmalloc)" >> "${S}/sql/CMakeLists.txt"
	fi

	# Don't build bundled xz-utils for tokudb
	echo > "${S}/storage/tokudb/PerconaFT/cmake_modules/TokuThirdParty.cmake" || die
	sed -i -e 's/ build_lzma//' -e 's/ build_snappy//' "${S}/storage/tokudb/PerconaFT/ft/CMakeLists.txt" || die
	sed -i -e 's/add_dependencies\(tokuportability_static_conv build_jemalloc\)//' "${S}/storage/tokudb/PerconaFT/portability/CMakeLists.txt" || die

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

	# Fix galera_recovery.sh script
	sed -i -e "s~@bindir@/my_print_defaults~${EPREFIX}/usr/libexec/mariadb/my_print_defaults~" \
		scripts/galera_recovery.sh || die

	cmake_src_prepare
	java-pkg-opt-2_src_prepare
}

src_configure() {
	# bug 508724 mariadb cannot use ld.gold
	tc-ld-disable-gold
	# Bug #114895, bug #110149
	filter-flags "-O" "-O[01]"

	append-cxxflags -felide-constructors

	# bug #283926, with GCC4.4, this is required to get correct behavior.
	append-flags -fno-strict-aliasing

	CMAKE_BUILD_TYPE="RelWithDebInfo"

	# debug hack wrt #497532
	mycmakeargs=(
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
		-DINSTALL_SCRIPTDIR=share/mariadb/scripts
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

		# Federated{,X} must be treated special otherwise they will not be built as plugins
		if ! use extraengine ; then
			mycmakeargs+=(
				-DPLUGIN_FEDERATED=NO
				-DPLUGIN_FEDERATEDX=NO )
		fi

		mycmakeargs+=(
			-DWITH_PCRE=system
			-DPLUGIN_OQGRAPH=$(usex oqgraph DYNAMIC NO)
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

		# Workaround for MDEV-14524
		use tokudb && mycmakeargs+=( -DTOKUDB_OK=1 )

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
				-DDEFAULT_CHARSET=utf8
				-DDEFAULT_COLLATION=utf8_general_ci
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
	local retstatus_unit
	local retstatus_tests

	if ! use server ; then
		einfo "Skipping server tests due to minimal build."
		return 0
	fi

	einfo ">>> Test phase [test]: ${CATEGORY}/${PF}"

	# Run CTest (test-units)
	cmake_src_test
	retstatus_unit=$?

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

	cp "${S}"/mysql-test/unstable-tests "${T}/disabled.def" || die

	local -a disabled_tests
	disabled_tests+=( "compat/oracle.plugin;0;Needs example plugin which Gentoo disables" )
	disabled_tests+=( "main.explain_non_select;0;Sporadically failing test" )
	disabled_tests+=( "main.func_time;0;Dependent on time test was written" )
	disabled_tests+=( "main.grant;0;Sporadically failing test" )
	disabled_tests+=( "main.plugin_auth;0;Needs client libraries built" )
	disabled_tests+=( "main.stat_tables;0;Sporadically failing test" )
	disabled_tests+=( "main.stat_tables_innodb;0;Sporadically failing test" )
	disabled_tests+=( "mariabackup.*;0;Broken test suite" )
	disabled_tests+=( "plugins.auth_ed25519;0;Needs client libraries built" )
	disabled_tests+=( "plugins.cracklib_password_check;0;False positive due to varying policies" )
	disabled_tests+=( "plugins.two_password_validations;0;False positive due to varying policies" )
	disabled_tests+=( "roles.acl_statistics;0;False positive due to a user count mismatch caused by previous test" )

	if ! use latin1 ; then
		disabled_tests+=( "funcs_1.is_columns_mysql;0;Requires USE=latin1" )
		disabled_tests+=( "main.information_schema;0;Requires USE=latin1" )
		disabled_tests+=( "main.system_mysql_db;0;Requires USE=latin1" )
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
	perl mysql-test-run.pl --force --vardir="${T}/var-tests" --reorder --skip-test=tokudb --skip-test-list="${T}/disabled.def"
	retstatus_tests=$?

	popd &>/dev/null || die

	# Cleanup is important for these testcases.
	pkill -9 -f "${S}/ndb" 2>/dev/null
	pkill -9 -f "${S}/sql" 2>/dev/null

	local failures=""
	[[ $retstatus_unit -eq 0 ]] || failures="${failures} test-unit"
	[[ $retstatus_tests -eq 0 ]] || failures="${failures} tests"

	[[ -z "$failures" ]] || die "Test failures: $failures"
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
	fi

	# Remove mytop if perl is not selected
	if [[ -e "${ED}/usr/bin/mytop" ]] && ! use perl ; then
		rm -f "${ED}/usr/bin/mytop" || die
	fi

	# Fix a dangling symlink when galera is not built
	if [[ -L "${ED}/usr/bin/wsrep_sst_rsync_wan" ]] && ! use galera ; then
		rm "${ED}/usr/bin/wsrep_sst_rsync_wan" || die
	fi

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

	# Here we need to see if the implementation switched client libraries
	# We check if this is a new instance of the package and a client library already exists
	local SHOW_ABI_MESSAGE libpath
	if [[ -z ${REPLACING_VERSIONS} && -e "${EROOT}/usr/$(get_libdir)/libmysqlclient.so" ]] ; then
		libpath=$(readlink "${EROOT}/usr/$(get_libdir)/libmysqlclient.so")
		elog "Due to ABI changes when switching between different client libraries,"
		elog "revdep-rebuild must find and rebuild all packages linking to libmysqlclient."
		elog "Please run: revdep-rebuild --library ${libpath}"
		ewarn "Failure to run revdep-rebuild may cause issues with other programs or libraries"
	fi
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
		local mypd="${EROOT}"/usr/libexec/mariadb/my_print_defaults
		local section="$1"
		local flag="--${2}="
		local extra_options="${3}"
		"${mypd}" $extra_options $section | sed -n "/^${flag}/s,${flag},,gp"
	}
	local old_MY_DATADIR="${MY_DATADIR}"
	local old_HOME="${HOME}"
	# my_print_defaults needs to read stuff in $HOME/.my.cnf
	export HOME=${EPREFIX}/root

	# Make sure the vars are correctly initialized
	mysql_init_vars

	[[ -z "${MY_DATADIR}" ]] && die "Sorry, unable to find MY_DATADIR"
	if [[ ! -x "${EROOT}/usr/sbin/mysqld" ]] ; then
		die "Minimal builds do NOT include the MySQL server"
	fi

	if [[ ( -n "${MY_DATADIR}" ) && ( "${MY_DATADIR}" != "${old_MY_DATADIR}" ) ]]; then
		local MY_DATADIR_s="${ROOT}/${MY_DATADIR}"
		MY_DATADIR_s="${MY_DATADIR_s%%/}"
		local old_MY_DATADIR_s="${ROOT}/${old_MY_DATADIR}"
		old_MY_DATADIR_s="${old_MY_DATADIR_s%%/}"

		if [[ ( -d "${old_MY_DATADIR_s}" ) && ( "${old_MY_DATADIR_s}" != / ) ]]; then
			if [[ -d "${MY_DATADIR_s}" ]]; then
				ewarn "Both ${old_MY_DATADIR_s} and ${MY_DATADIR_s} exist"
				ewarn "Attempting to use ${MY_DATADIR_s} and preserving ${old_MY_DATADIR_s}"
			else
				elog "Moving MY_DATADIR from ${old_MY_DATADIR_s} to ${MY_DATADIR_s}"
				mv --strip-trailing-slashes -T "${old_MY_DATADIR_s}" "${MY_DATADIR_s}" \
				|| die "Moving MY_DATADIR failed"
			fi
		else
			ewarn "Previous MY_DATADIR (${old_MY_DATADIR_s}) does not exist"
			if [[ -d "${MY_DATADIR_s}" ]]; then
				ewarn "Attempting to use ${MY_DATADIR_s}"
			else
				eerror "New MY_DATADIR (${MY_DATADIR_s}) does not exist"
				die "Configuration Failed! Please reinstall ${CATEGORY}/${PN}"
			fi
		fi
	fi

	local pwd1="a"
	local pwd2="b"
	local maxtry=15

	if [ -z "${MYSQL_ROOT_PASSWORD}" ]; then
		local tmp_mysqld_password_source=

		for tmp_mysqld_password_source in mysql client; do
			einfo "Trying to get password for mysql 'root' user from '${tmp_mysqld_password_source}' section ..."
			MYSQL_ROOT_PASSWORD="$(_getoptval "${tmp_mysqld_password_source}" password)"
			if [[ -n "${MYSQL_ROOT_PASSWORD}" ]]; then
				if [[ ${MYSQL_ROOT_PASSWORD} == *$'\n'* ]]; then
					ewarn "Ignoring password from '${tmp_mysqld_password_source}' section due to newline character (do you have multiple password options set?)!"
					MYSQL_ROOT_PASSWORD=
					continue
				fi

				einfo "Found password in '${tmp_mysqld_password_source}' section!"
				break
			fi
		done

		# Sometimes --show is required to display passwords in some implementations of my_print_defaults
		if [[ "${MYSQL_ROOT_PASSWORD}" == '*****' ]]; then
			MYSQL_ROOT_PASSWORD="$(_getoptval "${tmp_mysqld_password_source}" password --show)"
		fi

		unset tmp_mysqld_password_source
	fi
	MYSQL_TMPDIR="$(_getoptval mysqld tmpdir | tail -n1)"
	# These are dir+prefix
	MYSQL_RELAY_LOG="$(_getoptval mysqld relay-log | tail -n1)"
	MYSQL_RELAY_LOG=${MYSQL_RELAY_LOG%/*}
	MYSQL_LOG_BIN="$(_getoptval mysqld log-bin | tail -n1)"
	MYSQL_LOG_BIN=${MYSQL_LOG_BIN%/*}

	if [[ ! -d "${ROOT}/$MYSQL_TMPDIR" ]]; then
		einfo "Creating MySQL tmpdir $MYSQL_TMPDIR"
		install -d -m 770 -o mysql -g mysql "${EROOT}/$MYSQL_TMPDIR"
	fi
	if [[ ! -d "${ROOT}/$MYSQL_LOG_BIN" ]]; then
		einfo "Creating MySQL log-bin directory $MYSQL_LOG_BIN"
		install -d -m 770 -o mysql -g mysql "${EROOT}/$MYSQL_LOG_BIN"
	fi
	if [[ ! -d "${EROOT}/$MYSQL_RELAY_LOG" ]]; then
		einfo "Creating MySQL relay-log directory $MYSQL_RELAY_LOG"
		install -d -m 770 -o mysql -g mysql "${EROOT}/$MYSQL_RELAY_LOG"
	fi

	if [[ -d "${ROOT}/${MY_DATADIR}/mysql" ]] ; then
		ewarn "You have already a MySQL database in place."
		ewarn "(${ROOT}/${MY_DATADIR}/*)"
		ewarn "Please rename or delete it if you wish to replace it."
		die "MySQL database already exists!"
	fi

	# Bug #213475 - MySQL _will_ object strenously if your machine is named
	# localhost. Also causes weird failures.
	[[ "${HOSTNAME}" == "localhost" ]] && die "Your machine must NOT be named localhost"

	if [[ -z "${MYSQL_ROOT_PASSWORD}" ]]; then

		einfo "Please provide a password for the mysql 'root'@'localhost' user now"
		einfo "or through the ${HOME}/.my.cnf file."
		ewarn "Avoid [\"'\\_%] characters in the password"
		read -rsp "    >" pwd1 ; echo

		einfo "Retype the password"
		read -rsp "    >" pwd2 ; echo

		if [[ "x$pwd1" != "x$pwd2" ]] ; then
			die "Passwords are not the same"
		fi

		MYSQL_ROOT_PASSWORD="${pwd1}"
		unset pwd1 pwd2
	fi

	local options
	local sqltmp="$(emktemp)"

	# Fix bug 446200. Don't reference host my.cnf, needs to come first,
	# see https://bugs.mysql.com/bug.php?id=31312
	use prefix && options="${options} '--defaults-file=${MY_SYSCONFDIR}/my.cnf'"

	# Figure out which options we need to disable to do the setup
	local helpfile="${TMPDIR}/mysqld-help"
	"${EROOT}/usr/sbin/mysqld" --verbose --help >"${helpfile}" 2>/dev/null
	for opt in grant-tables host-cache name-resolve networking slave-start \
		federated ssl log-bin relay-log slow-query-log external-locking \
		log-slave-updates \
		; do
		optexp="--(skip-)?${opt}" optfull="--loose-skip-${opt}"
		egrep -sq -- "${optexp}" "${helpfile}" && options="${options} ${optfull}"
	done

	einfo "Creating the mysql database and setting proper permissions on it ..."

	# Now that /var/run is a tmpfs mount point, we need to ensure it exists before using it
	PID_DIR="${EROOT}/var/run/mysqld"
	if [[ ! -d "${PID_DIR}" ]]; then
		install -d -m 755 -o mysql -g mysql "${PID_DIR}" || die "Could not create pid directory"
	fi

	if [[ ! -d "${MY_DATADIR}" ]]; then
		install -d -m 750 -o mysql -g mysql "${MY_DATADIR}" || die "Could not create data directory"
	fi

	pushd "${TMPDIR}" &>/dev/null || die

	# Filling timezones, see
	# https://dev.mysql.com/doc/mysql/en/time-zone-support.html
	"${EROOT}/usr/bin/mysql_tzinfo_to_sql" "${EROOT}/usr/share/zoneinfo" > "${sqltmp}" 2>/dev/null

	local cmd=( "${EROOT}/usr/share/mariadb/scripts/mysql_install_db" )
	[[ -f "${cmd}" ]] || cmd=( "${EROOT}/usr/bin/mysql_install_db" )
	cmd+=( "--basedir=${EPREFIX}/usr" ${options} "--datadir=${ROOT}/${MY_DATADIR}" "--tmpdir=${ROOT}/${MYSQL_TMPDIR}" )
	einfo "Command: ${cmd[*]}"
	su -s /bin/sh -c "${cmd[*]}" mysql \
		>"${TMPDIR}"/mysql_install_db.log 2>&1
	if [[ $? -ne 0 ]]; then
		grep -B5 -A999 -i "ERROR" "${TMPDIR}"/mysql_install_db.log 1>&2
		die "Failed to initialize mysqld. Please review ${EPREFIX}/var/log/mysql/mysqld.err AND ${TMPDIR}/mysql_install_db.log"
	fi
	popd &>/dev/null || die
	[[ -f "${ROOT}/${MY_DATADIR}/mysql/user.frm" ]] \
		|| die "MySQL databases not installed"

	use prefix || options="${options} --user=mysql"

	local socket="${EROOT}/var/run/mysqld/mysqld${RANDOM}.sock"
	local pidfile="${EROOT}/var/run/mysqld/mysqld${RANDOM}.pid"
	local mysqld="${EROOT}/usr/sbin/mysqld \
		${options} \
		--log-warnings=0 \
		--basedir=${EROOT}/usr \
		--datadir=${ROOT}/${MY_DATADIR} \
		--max_allowed_packet=8M \
		--net_buffer_length=16K \
		--socket=${socket} \
		--pid-file=${pidfile} \
		--tmpdir=${ROOT}/${MYSQL_TMPDIR}"
	#einfo "About to start mysqld: ${mysqld}"
	ebegin "Starting mysqld"
	einfo "Command ${mysqld}"
	${mysqld} &
	rc=$?
	while ! [[ -S "${socket}" || "${maxtry}" -lt 1 ]] ; do
		maxtry=$((${maxtry}-1))
		echo -n "."
		sleep 1
	done
	eend $rc

	if ! [[ -S "${socket}" ]]; then
		die "Completely failed to start up mysqld with: ${mysqld}"
	fi

	ebegin "Setting root password"
	# Do this from memory, as we don't want clear text passwords in temp files
	local sql="UPDATE mysql.user SET Password = PASSWORD('${MYSQL_ROOT_PASSWORD}') WHERE USER='root'; FLUSH PRIVILEGES"
	"${EROOT}/usr/bin/mysql" \
		"--socket=${socket}" \
		-hlocalhost \
		-e "${sql}"
	eend $?

	if [[ -n "${sqltmp}" ]] ; then
		ebegin "Loading \"zoneinfo\", this step may require a few seconds"
		"${EROOT}/usr/bin/mysql" \
			"--socket=${socket}" \
			-hlocalhost \
			-uroot \
			--password="${MYSQL_ROOT_PASSWORD}" \
			mysql < "${sqltmp}"
		rc=$?
		eend $?
		[[ $rc -ne 0 ]] && ewarn "Failed to load zoneinfo!"
	fi

	# Stop the server and cleanup
	einfo "Stopping the server ..."
	kill $(< "${pidfile}" )
	rm -f "${sqltmp}"
	wait %1
	einfo "Done"
}
