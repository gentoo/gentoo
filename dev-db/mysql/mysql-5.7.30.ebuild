# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

CMAKE_MAKEFILE_GENERATOR=emake

# Keeping eutils in EAPI=6 for emktemp in pkg_config

inherit cmake-utils eutils flag-o-matic linux-info \
	prefix toolchain-funcs multilib-minimal

# Patch version
PATCH_SET="https://dev.gentoo.org/~whissi/dist/mysql/${PN}-5.7.30-patches-01.tar.xz"

SRC_URI="https://cdn.mysql.com/Downloads/MySQL-5.7/${PN}-boost-${PV}.tar.gz
	https://cdn.mysql.com/archives/mysql-5.7/mysql-boost-${PV}.tar.gz
	http://downloads.mysql.com/archives/MySQL-5.7/${PN}-boost-${PV}.tar.gz
	${PATCH_SET}"

HOMEPAGE="https://www.mysql.com/"
DESCRIPTION="A fast, multi-threaded, multi-user SQL database server"
LICENSE="GPL-2"
SLOT="0/18"
IUSE="cjk client-libs cracklib debug experimental jemalloc latin1 libressl numa +perl profiling
	selinux +server static static-libs systemtap tcmalloc test yassl"

# Tests always fail when libressl is enabled due to hard-coded ciphers in the tests
RESTRICT="!test? ( test ) libressl? ( test )"

REQUIRED_USE="?? ( tcmalloc jemalloc ) static? ( yassl )"

KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"

# Shorten the path because the socket path length must be shorter than 107 chars
# and we will run a mysql server during test phase
S="${WORKDIR}/mysql"

# Be warned, *DEPEND are version-dependant
# These are used for both runtime and compiletime
# MULTILIB_USEDEP only set for libraries used by the client library
COMMON_DEPEND="net-misc/curl:=
	>=sys-apps/sed-4
	>=sys-apps/texinfo-4.7-r1
	sys-libs/ncurses:0=
	client-libs? ( >=sys-libs/zlib-1.2.3:0=[${MULTILIB_USEDEP},static-libs?] )
	!client-libs? (
		dev-db/mysql-connector-c[${MULTILIB_USEDEP},static-libs?]
		>=sys-libs/zlib-1.2.3:0=
	)
	jemalloc? ( dev-libs/jemalloc:0= )
	kernel_linux? (
		dev-libs/libaio:0=
		sys-process/procps:0=
	)
	server? (
		>=app-arch/lz4-0_p131:=
		cjk? ( app-text/mecab:= )
		experimental? (
			dev-libs/libevent:=
			dev-libs/protobuf:=
			net-libs/libtirpc:=
		)
		numa? ( sys-process/numactl )
	)
	systemtap? ( >=dev-util/systemtap-1.3:0= )
	tcmalloc? ( dev-util/google-perftools:0= )
	!yassl? (
		client-libs? (
			!libressl? ( >=dev-libs/openssl-1.0.0:0=[${MULTILIB_USEDEP},static-libs?] )
			libressl? ( dev-libs/libressl:0=[${MULTILIB_USEDEP},static-libs?] )
		)
		!client-libs? (
			!libressl? ( >=dev-libs/openssl-1.0.0:0= )
			libressl? ( dev-libs/libressl:0= )
		)
	)
"
DEPEND="${COMMON_DEPEND}
	|| ( >=sys-devel/gcc-3.4.6 >=sys-devel/gcc-apple-4.0 )
	dev-libs/protobuf
	virtual/yacc
	server? (
		dev-libs/libevent
		experimental? ( net-libs/rpcsvc-proto )
	)
	static? ( sys-libs/ncurses[static-libs] )
	test? (
		acct-group/mysql acct-user/mysql
		dev-perl/JSON
	)
"
RDEPEND="${COMMON_DEPEND}
	!dev-db/mariadb !dev-db/mariadb-galera !dev-db/percona-server !dev-db/mysql-cluster
	client-libs? ( !dev-db/mariadb-connector-c[mysqlcompat] !dev-db/mysql-connector-c dev-libs/protobuf:= )
	selinux? ( sec-policy/selinux-mysql )
	server? (
		!prefix? (
			acct-group/mysql acct-user/mysql
			dev-db/mysql-init-scripts
		)
	)
"
# For other stuff to bring us in
# dev-perl/DBD-mysql is needed by some scripts installed by MySQL
PDEPEND="perl? ( >=dev-perl/DBD-mysql-2.9004 )"

mysql_init_vars() {
	MY_SHAREDSTATEDIR=${MY_SHAREDSTATEDIR="${EPREFIX}/usr/share/mysql"}
	MY_SYSCONFDIR=${MY_SYSCONFDIR="${EPREFIX}/etc/mysql"}
	MY_LOCALSTATEDIR=${MY_LOCALSTATEDIR="${EPREFIX}/var/lib/mysql"}
	MY_LOGDIR=${MY_LOGDIR="${EPREFIX}/var/log/mysql"}

	if [[ -z "${MY_DATADIR}" ]] ; then
		MY_DATADIR=""
		if [[ -f "${MY_SYSCONFDIR}/my.cnf" ]] ; then
			MY_DATADIR=`"my_print_defaults" mysqld 2>/dev/null \
				| sed -ne '/datadir/s|^--datadir=||p' \
				| tail -n1`
			if [[ -z "${MY_DATADIR}" ]] ; then
				MY_DATADIR=`grep ^datadir "${MY_SYSCONFDIR}/my.cnf" \
				| sed -e 's/.*=\s*//' \
				| tail -n1`
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
		if [[ ${EBUILD_PHASE} == "config" ]] ; then
			local new_MY_DATADIR
			new_MY_DATADIR=`"my_print_defaults" mysqld 2>/dev/null \
				| sed -ne '/datadir/s|^--datadir=||p' \
				| tail -n1`

			if [[ ( -n "${new_MY_DATADIR}" ) && ( "${new_MY_DATADIR}" != "${MY_DATADIR}" ) ]] ; then
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

pkg_pretend() {
	if use numa ; then
		local CONFIG_CHECK="~NUMA"

		local WARNING_NUMA="This package expects NUMA support in kernel which this system does not have at the moment;"
		WARNING_NUMA+=" Either expect runtime errors, enable NUMA support in kernel or rebuild the package without NUMA support"

		check_extra_config
	fi
}

pkg_setup() {
	if [[ ${MERGE_TYPE} != binary ]] ; then
		local GCC_MAJOR_SET=$(gcc-major-version)
		local GCC_MINOR_SET=$(gcc-minor-version)
		# Bug 565584: InnoDB now requires atomic functions introduced with gcc-4.7 on
		# non x86{,_64} arches
		if ! use amd64 && ! use x86 && [[ ${GCC_MAJOR_SET} -lt 4 || \
			${GCC_MAJOR_SET} -eq 4 && ${GCC_MINOR_SET} -lt 7 ]] ; then
			eerror "${PN} needs to be built with gcc-4.7 or later."
			eerror "Please use gcc-config to switch to gcc-4.7 or later version."
			die
		fi
	fi

	if has test ${FEATURES} && \
		use server && ! has userpriv ${FEATURES} ; then
			eerror "Testing with FEATURES=-userpriv is no longer supported by upstream. Tests MUST be run as non-root."
	fi
}

pkg_preinst() {
	# Here we need to see if the implementation switched client libraries
	# We check if this is a new instance of the package and a client library already exists
	local SHOW_ABI_MESSAGE libpath
	if use client-libs && [[ -z ${REPLACING_VERSIONS} && -e "${EROOT}usr/$(get_libdir)/libmysqlclient.so" ]] ; then
		libpath=$(readlink "${EROOT}usr/$(get_libdir)/libmysqlclient.so")
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
	[[ -d "${ROOT}${MY_LOGDIR}" ]] || install -d -m0750 -o mysql -g mysql "${ROOT}${MY_LOGDIR}"

	if use server ; then
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
	fi

	# Note about configuration change
	einfo
	elog "This version of ${PN} reorganizes the configuration from a single my.cnf"
	elog "to several files in /etc/mysql/mysql.d."
	elog "Please backup any changes you made to /etc/mysql/my.cnf"
	elog "and add them as a new file under /etc/mysql/mysql.d with a .cnf extension."
	elog "You may have as many files as needed and they are read alphabetically."
	elog "Be sure the options have the appropriate section headers, i.e. [mysqld]."
	einfo
}

src_unpack() {
	unpack ${A}

	mv -f "${WORKDIR}/${P}" "${S}" || die
}

src_prepare() {
	eapply "${WORKDIR}"/mysql-patches

	cmake-utils_src_prepare

	if use jemalloc ; then
		echo "TARGET_LINK_LIBRARIES(mysqld jemalloc)" >> "${S}/sql/CMakeLists.txt" || die
	fi

	if use tcmalloc ; then
		echo "TARGET_LINK_LIBRARIES(mysqld tcmalloc)" >> "${S}/sql/CMakeLists.txt" || die
	fi

	# Remove the centos and rhel selinux policies to support mysqld_safe under SELinux
	if [[ -d "${S}/support-files/SELinux" ]] ; then
		echo > "${S}/support-files/SELinux/CMakeLists.txt" || die
	fi

	# Remove bundled libs so we cannot accidentally use them
	# We keep extra/lz4 directory because we use extra/lz4/xxhash.c via sql/CMakeLists.txt:394
	rm -rv \
		"${S}"/extra/protobuf \
		"${S}"/extra/libevent \
		"${S}"/zlib \
		|| die

	# Don't clash with dev-db/mysql-connector-c
	rm \
		man/my_print_defaults.1 \
		man/perror.1 \
		man/zlib_decompress.1 \
		|| die

	if use libressl ; then
		sed -i 's/OPENSSL_MAJOR_VERSION STREQUAL "1"/OPENSSL_MAJOR_VERSION STREQUAL "2"/' \
			"${S}/cmake/ssl.cmake" || die
	fi

	sed -i 's~ADD_SUBDIRECTORY(storage/ndb)~~' CMakeLists.txt || die
}

src_configure() {
	# Bug #114895, bug #110149
	filter-flags "-O" "-O[01]"

	append-cxxflags -felide-constructors

	# bug #283926, with GCC4.4, this is required to get correct behavior.
	append-flags -fno-strict-aliasing

	if use client-libs ; then
		multilib-minimal_src_configure
	else
		multilib_src_configure
	fi
}

multilib_src_configure() {
	debug-print-function ${FUNCNAME} "$@"

	if ! multilib_is_native_abi && ! use client-libs ; then
		return
	fi

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
		-DINSTALL_MYSQLSHAREDIR=share/mysql
		-DINSTALL_PLUGINDIR=$(get_libdir)/mysql/plugin
		-DINSTALL_SCRIPTDIR=share/mysql/scripts
		-DINSTALL_MYSQLDATADIR="${EPREFIX}/var/lib/mysql"
		-DINSTALL_SBINDIR=sbin
		-DINSTALL_SUPPORTFILESDIR="${EPREFIX}/usr/share/mysql"
		-DCOMPILATION_COMMENT="Gentoo Linux ${PF}"
		-DWITH_UNIT_TESTS=$(usex test ON OFF)
		### TODO: make this system but issues with UTF-8 prevent it
		-DWITH_EDITLINE=bundled
		-DWITH_ZLIB=system
		-DWITH_LIBWRAP=0
		-DENABLED_LOCAL_INFILE=1
		-DMYSQL_UNIX_ADDR="${EPREFIX}/var/run/mysqld/mysqld.sock"
		-DWITH_DEFAULT_COMPILER_OPTIONS=0
		-DWITH_DEFAULT_FEATURE_SET=0
		# The build forces this to be defined when cross-compiling. We pass it
		# all the time for simplicity and to make sure it is actually correct.
		-DSTACK_DIRECTION=$(tc-stack-grows-down && echo -1 || echo 1)
		-DWITH_CURL=system
		-DWITH_BOOST="${S}/boost"
	)
	if use test ; then
		mycmakeargs+=( -DINSTALL_MYSQLTESTDIR=share/mysql/mysql-test )
	else
		mycmakeargs+=( -DINSTALL_MYSQLTESTDIR='' )
	fi

	if ! use yassl ; then
		mycmakeargs+=( -DWITH_SSL=system )
	else
		mycmakeargs+=( -DWITH_SSL=bundled )
	fi

	if ! use client-libs ; then
		mycmakeargs+=( -DWITHOUT_CLIENTLIBS=YES )
	fi

	# bfd.h is only used starting with 10.1 and can be controlled by NOT_FOR_DISTRIBUTION
	# systemtap only works on native ABI, bug 530132
	if multilib_is_native_abi ; then
		mycmakeargs+=(
			-DENABLE_DTRACE=$(usex systemtap)
		)
	else
		mycmakeargs+=(
			-DWITHOUT_TOOLS=1
			-DWITH_READLINE=1
			-DENABLE_DTRACE=0
		)
	fi

	if multilib_is_native_abi && use server ; then
		mycmakeargs+=(
			-DWITH_LIBEVENT=system
			-DWITH_LZ4=system
			-DWITH_PROTOBUF=system
			-DWITH_MECAB=$(usex cjk system OFF)
			-DWITH_NUMA=$(usex numa ON OFF)
			-DWITH_RAPID=$(usex experimental ON OFF)
		)

		if [[ ( -n ${MYSQL_DEFAULT_CHARSET} ) && ( -n ${MYSQL_DEFAULT_COLLATION} ) ]] ; then
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
			-DDISABLE_SHARED=$(usex static YES NO)
			-DWITH_DEBUG=$(usex debug)
			-DWITH_EMBEDDED_SERVER=OFF
		)

		if use profiling ; then
			# Setting to OFF doesn't work: Once set, profiling options will be added
			# to `mysqld --help` output via sql/sys_vars.cc causing
			# "main.mysqld--help-notwin" test to fail
			mycmakeargs+=( -DENABLED_PROFILING=ON )
		fi

		if use static ; then
			mycmakeargs+=( -DWITH_PIC=1 )
		fi

		# Storage engines
		mycmakeargs+=(
			-DWITH_EXAMPLE_STORAGE_ENGINE=0
			-DWITH_ARCHIVE_STORAGE_ENGINE=1
			-DWITH_BLACKHOLE_STORAGE_ENGINE=1
			-DWITH_CSV_STORAGE_ENGINE=1
			-DWITH_FEDERATED_STORAGE_ENGINE=1
			-DWITH_HEAP_STORAGE_ENGINE=1
			-DWITH_INNOBASE_STORAGE_ENGINE=1
			-DWITH_INNODB_MEMCACHED=0
			-DWITH_MYISAMMRG_STORAGE_ENGINE=1
			-DWITH_MYISAM_STORAGE_ENGINE=1
			-DWITH_PARTITION_STORAGE_ENGINE=1
		)

	else
		mycmakeargs+=(
			-DWITHOUT_SERVER=1
			-DWITH_EMBEDDED_SERVER=OFF
			-DEXTRA_CHARSETS=none
		)
	fi

	cmake-utils_src_configure
}

src_compile() {
	if use client-libs ; then
		multilib-minimal_src_compile
	else
		multilib_src_compile
	fi
}

multilib_src_compile() {
	cmake-utils_src_compile
}

# Official test instructions:
# ulimit -n 16500 && \
# USE='latin1 perl server' \
# FEATURES='test userpriv -usersandbox' \
# ebuild mysql-X.X.XX.ebuild \
# digest clean package
src_test() {
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

	if [[ $UID -eq 0 ]] ; then
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
	mkdir -p "${T}"/var-tests{,/log} || die

	# Run mysql tests
	pushd "${TESTDIR}" &>/dev/null || die

	touch "${T}/disabled.def"
	# These are failing in MySQL 5.7 for now and are believed to be
	# false positives:
	#
	local t

	for t in auth_sec.keyring_udf ; do
			_disable_test "$t" "False positives in Gentoo"
	done

	# Unstable tests
	# - main.xa_prepared_binlog_off: https://bugs.mysql.com/bug.php?id=83340
	# - rpl.rpl_innodb_info_tbl_slave_tmp_tbl_mismatch: https://bugs.mysql.com/bug.php?id=89223
	# - rpl.rpl_non_direct_stm_mixing_engines: MDEV-14489
	for t in \
		main.xa_prepared_binlog_off \
		rpl.rpl_innodb_info_tbl_slave_tmp_tbl_mismatch \
		rpl.rpl_non_direct_stm_mixing_engines \
	; do
		_disable_test "$t" "Unstable test"
	done

	for t in \
		gis.geometry_class_attri_prop \
		gis.geometry_property_function_issimple \
		gis.gis_bugs_crashes \
		gis.spatial_op_testingfunc_mix \
		gis.spatial_analysis_functions_buffer \
		gis.spatial_analysis_functions_distance \
		gis.spatial_utility_function_distance_sphere \
		gis.spatial_utility_function_simplify \
		gis.spatial_analysis_functions_centroid \
	; do
		_disable_test "$t" "Known rounding error with latest AMD processors"
	done

	if use numa && use kernel_linux ; then
		# bug 584880
		if ! linux_config_exists || ! linux_chkconfig_present NUMA ; then
			for t in sys_vars.innodb_numa_interleave_basic ; do
				_disable_test "$t" "Test $t requires system with NUMA support"
			done
		fi
	fi

	if ! use latin1 ; then
		# The following tests will fail if DEFAULT_CHARSET
		# isn't set to latin1:
		for t in \
			binlog.binlog_mysqlbinlog_filter \
			binlog.binlog_xa_prepared_disconnect \
			funcs_1.is_columns_mysql \
			funcs_1.is_tables_mysql \
			funcs_1.is_triggers \
			innodb.innodb_pagesize_max_recordsize \
			innodb.innodb-system-table-view \
			innodb.mysqldump_max_recordsize \
			main.mysql_client_test \
			main.mysqld--help-notwin \
			main.type_string \
			main.information_schema \
			perfschema.binlog_edge_mix \
			perfschema.binlog_edge_stmt \
			rpl.rpl_xa_survive_disconnect \
			rpl.rpl_xa_survive_disconnect_lsu_off \
			rpl.rpl_xa_survive_disconnect_table \
		; do
			_disable_test "$t" "Requires DEFAULT_CHARSET=latin1 but USE=-latin1 is set"
		done
	fi

	if has_version '>=dev-libs/openssl-1.1.1' ; then
		# Tests are expecting <openssl-1.1.1 default cipher
		for t in \
			auth_sec.cert_verify \
			auth_sec.mysql_ssl_connection \
			auth_sec.openssl_cert_generation \
			auth_sec.ssl_auto_detect \
			auth_sec.ssl_mode \
			auth_sec.tls \
			binlog.binlog_grant_alter_user \
			encryption.innodb_onlinealter_encryption \
			main.grant_alter_user_qa \
			main.grant_user_lock_qa \
			main.mysql_ssl_default \
			main.openssl_1 \
			main.plugin_auth_sha256_tls \
			main.ssl \
			main.ssl_8k_key \
			main.ssl_bug75311 \
			main.ssl_ca \
			main.ssl_cipher \
			main.ssl_compress \
			main.ssl_crl \
			main.ssl_ecdh \
			main.ssl_verify_identity \
			x.connection_tls_version \
			x.connection_openssl \
		; do
			_disable_test  "$t" "Requires <dev-libs/openssl-1.1.1"
		done
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

	# run mysql-test tests
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
	local MULTILIB_WRAPPED_HEADERS
	local MULTILIB_CHOST_TOOLS
	if use client-libs ; then
		# headers with ABI specific data
		MULTILIB_WRAPPED_HEADERS=(
			/usr/include/mysql/server/my_config.h
			/usr/include/mysql/server/mysql_version.h )

		# wrap the config scripts
		MULTILIB_CHOST_TOOLS=( /usr/bin/mysql_config )
		multilib-minimal_src_install
	else
		multilib_src_install
		multilib_src_install_all
	fi
}

# Intentionally override eclass function
multilib_src_install() {

	cmake-utils_src_install

	# Kill old libmysqclient_r symlinks if they exist. Time to fix what depends on them.
	find "${D}" -name 'libmysqlclient_r.*' -type l -delete || die
}

multilib_src_install_all() {
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
	cp "${FILESDIR}/my.cnf-5.7" "${TMPDIR}/my.cnf" || die
	eprefixify "${TMPDIR}/my.cnf"
	doins "${TMPDIR}/my.cnf"
	insinto "${MY_SYSCONFDIR#${EPREFIX}}/mysql.d"
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
	fi

	#Remove mytop if perl is not selected
	[[ -e "${ED}/usr/bin/mytop" ]] && ! use perl && rm -f "${ED}/usr/bin/mytop"
}

pkg_config() {
	_getoptval() {
		local mypd="${EROOT%/}"/usr/bin/my_print_defaults
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
	if [[ ! -x "${EROOT%/}/usr/sbin/mysqld" ]] ; then
		die "Minimal builds do NOT include the MySQL server"
	fi

	if [[ ( -n "${MY_DATADIR}" ) && ( "${MY_DATADIR}" != "${old_MY_DATADIR}" ) ]] ; then
		local MY_DATADIR_s="${ROOT%/}/${MY_DATADIR}"
		MY_DATADIR_s="${MY_DATADIR_s%%/}"
		local old_MY_DATADIR_s="${ROOT%/}/${old_MY_DATADIR}"
		old_MY_DATADIR_s="${old_MY_DATADIR_s%%/}"

		if [[ ( -d "${old_MY_DATADIR_s}" ) && ( "${old_MY_DATADIR_s}" != / ) ]] ; then
			if [[ -d "${MY_DATADIR_s}" ]] ; then
				ewarn "Both ${old_MY_DATADIR_s} and ${MY_DATADIR_s} exist"
				ewarn "Attempting to use ${MY_DATADIR_s} and preserving ${old_MY_DATADIR_s}"
			else
				elog "Moving MY_DATADIR from ${old_MY_DATADIR_s} to ${MY_DATADIR_s}"
				mv --strip-trailing-slashes -T "${old_MY_DATADIR_s}" "${MY_DATADIR_s}" \
				|| die "Moving MY_DATADIR failed"
			fi
		else
			ewarn "Previous MY_DATADIR (${old_MY_DATADIR_s}) does not exist"
			if [[ -d "${MY_DATADIR_s}" ]] ; then
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
	MYSQL_TMPDIR="$(_getoptval mysqld tmpdir)"
	# These are dir+prefix
	MYSQL_RELAY_LOG="$(_getoptval mysqld relay-log)"
	MYSQL_RELAY_LOG=${MYSQL_RELAY_LOG%/*}
	MYSQL_LOG_BIN="$(_getoptval mysqld log-bin)"
	MYSQL_LOG_BIN=${MYSQL_LOG_BIN%/*}

	if [[ ! -d "${EROOT%/}/$MYSQL_TMPDIR" ]] ; then
		einfo "Creating MySQL tmpdir $MYSQL_TMPDIR"
		install -d -m 770 -o mysql -g mysql "${EROOT%/}/$MYSQL_TMPDIR"
	fi

	if [[ ! -d "${EROOT%/}/$MYSQL_LOG_BIN" ]] ; then
		einfo "Creating MySQL log-bin directory $MYSQL_LOG_BIN"
		install -d -m 770 -o mysql -g mysql "${EROOT%/}/$MYSQL_LOG_BIN"
	fi

	if [[ ! -d "${EROOT%/}/$MYSQL_RELAY_LOG" ]] ; then
		einfo "Creating MySQL relay-log directory $MYSQL_RELAY_LOG"
		install -d -m 770 -o mysql -g mysql "${EROOT%/}/$MYSQL_RELAY_LOG"
	fi

	if [[ -d "${ROOT%/}/${MY_DATADIR}/mysql" ]] ; then
		ewarn "You have already a MySQL database in place."
		ewarn "(${ROOT%/}/${MY_DATADIR}/*)"
		ewarn "Please rename or delete it if you wish to replace it."
		die "MySQL database already exists!"
	fi

	# Bug #213475 - MySQL _will_ object strenously if your machine is named
	# localhost. Also causes weird failures.
	[[ "${HOSTNAME}" == "localhost" ]] && die "Your machine must NOT be named localhost"

	if [[ -z "${MYSQL_ROOT_PASSWORD}" ]] ; then

		einfo "Please provide a password for the mysql 'root' user now"
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
	# see http://bugs.mysql.com/bug.php?id=31312
	use prefix && options="${options} '--defaults-file=${MY_SYSCONFDIR}/my.cnf'"

	# Figure out which options we need to disable to do the setup
	local helpfile="${TMPDIR%/}/mysqld-help"
	"${EROOT%/}/usr/sbin/mysqld" --verbose --help >"${helpfile}" 2>/dev/null
	for opt in host-cache name-resolve networking slave-start \
		federated ssl log-bin relay-log slow-query-log external-locking \
		log-slave-updates \
		; do
		optexp="--(skip-)?${opt}" optfull="--loose-skip-${opt}"
		egrep -sq -- "${optexp}" "${helpfile}" && options="${options} ${optfull}"
	done

	einfo "Creating the mysql database and setting proper permissions on it ..."

	# Now that /var/run is a tmpfs mount point, we need to ensure it exists before using it
	PID_DIR="${EROOT%/}/var/run/mysqld"
	if [[ ! -d "${PID_DIR}" ]] ; then
		install -d -m 755 -o mysql -g mysql "${PID_DIR}" || die "Could not create pid directory"
	fi

	if [[ ! -d "${MY_DATADIR}" ]] ; then
		install -d -m 750 -o mysql -g mysql "${MY_DATADIR}" || die "Could not create data directory"
	fi

	pushd "${TMPDIR}" &>/dev/null || die

	# Filling timezones, see
	# http://dev.mysql.com/doc/mysql/en/time-zone-support.html
	echo "USE mysql;" >"${sqltmp}"
	"${EROOT%/}/usr/bin/mysql_tzinfo_to_sql" "${EROOT%/}/usr/share/zoneinfo" >> "${sqltmp}" 2>/dev/null
	chown mysql "${sqltmp}" || die

	# --initialize-insecure will not set root password
	# --initialize would set a random one in the log which we don't need as we set it ourselves
	local cmd=( "${EROOT%/}/usr/sbin/mysqld" "--initialize-insecure" "--init-file='${sqltmp}'" )
	cmd+=( "--basedir=${EPREFIX}/usr" ${options} "--datadir=${ROOT%/}${MY_DATADIR}" "--tmpdir=${ROOT%/}${MYSQL_TMPDIR}" )
	einfo "Command: ${cmd[*]}"
	su -s /bin/sh -c "${cmd[*]}" mysql \
		>"${TMPDIR%/}"/mysql_install_db.log 2>&1
	if [[ $? -ne 0 ]] ; then
		grep -B5 -A999 -i "ERROR" "${TMPDIR%/}"/mysql_install_db.log 1>&2
		die "Failed to initialize mysqld. Please review ${EPREFIX}/var/log/mysql/mysqld.err AND ${TMPDIR%/}/mysql_install_db.log"
	fi
	popd &>/dev/null || die
	[[ -f "${ROOT%/}/${MY_DATADIR}/mysql/user.frm" ]] \
	|| die "MySQL databases not installed"

	use prefix || options="${options} --user=mysql"

	local socket="${EROOT%/}/var/run/mysqld/mysqld${RANDOM}.sock"
	local pidfile="${EROOT%/}/var/run/mysqld/mysqld${RANDOM}.pid"
	local mysqld="${EROOT%/}/usr/sbin/mysqld \
		${options} \
		$(use prefix || echo --user=mysql) \
		--log-warnings=0 \
		--basedir=${EROOT%/}/usr \
		--datadir=${ROOT%/}/${MY_DATADIR} \
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

	if ! [[ -S "${socket}" ]] ; then
		die "Completely failed to start up mysqld with: ${mysqld}"
	fi

	ebegin "Setting root password"
	# Do this from memory, as we don't want clear text passwords in temp files
	local sql="ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '${MYSQL_ROOT_PASSWORD}'"
	"${EROOT%/}/usr/bin/mysql" \
		--no-defaults \
		"--socket=${socket}" \
		-hlocalhost \
		-e "${sql}"
	eend $?

	# Stop the server and cleanup
	einfo "Stopping the server ..."
	kill $(< "${pidfile}" )
	rm -f "${sqltmp}"
	wait %1
	einfo "Done"
}
