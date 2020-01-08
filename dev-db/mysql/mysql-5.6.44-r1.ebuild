# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
MY_EXTRAS_VER="20190817-0024Z"

CMAKE_MAKEFILE_GENERATOR=emake

# Keeping eutils in EAPI=6 for emktemp in pkg_config

inherit eutils flag-o-matic prefix toolchain-funcs \
	user cmake-utils multilib-build

SRC_URI="http://cdn.mysql.com/Downloads/MySQL-5.6/${P}.tar.gz
	https://cdn.mysql.com/archives/mysql-5.6/${P}.tar.gz
	http://downloads.mysql.com/archives/MySQL-5.6/${P}.tar.gz"

# Gentoo patches to MySQL
if [[ "${MY_EXTRAS_VER}" != "live" && "${MY_EXTRAS_VER}" != "none" ]]; then
	SRC_URI="${SRC_URI}
		mirror://gentoo/mysql-extras-${MY_EXTRAS_VER}.tar.bz2
		https://gitweb.gentoo.org/proj/mysql-extras.git/snapshot/mysql-extras-${MY_EXTRAS_VER}.tar.bz2
		https://dev.gentoo.org/~grknight/distfiles/mysql-extras-${MY_EXTRAS_VER}.tar.bz2
		https://dev.gentoo.org/~robbat2/distfiles/mysql-extras-${MY_EXTRAS_VER}.tar.bz2
		https://dev.gentoo.org/~jmbsvicetto/distfiles/mysql-extras-${MY_EXTRAS_VER}.tar.bz2"
fi

HOMEPAGE="https://www.mysql.com/"
DESCRIPTION="A fast, multi-threaded, multi-user SQL database server"
LICENSE="GPL-2"
SLOT="0/18"
IUSE="client-libs cracklib debug jemalloc latin1 libressl numa +perl profiling selinux
	+server static static-libs systemtap tcmalloc test yassl"

# Tests always fail when libressl is enabled due to hard-coded ciphers in the tests
RESTRICT="!test? ( test ) libressl? ( test )"

REQUIRED_USE="?? ( tcmalloc jemalloc ) static? ( yassl )"

KEYWORDS="alpha amd64 arm ~hppa ia64 ~mips ppc ppc64 ~s390 ~sparc x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"

# Shorten the path because the socket path length must be shorter than 107 chars
# and we will run a mysql server during test phase
S="${WORKDIR}/mysql"

if [[ "${MY_EXTRAS_VER}" == "live" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://anongit.gentoo.org/git/proj/mysql-extras.git"
	EGIT_CHECKOUT_DIR="${WORKDIR}/mysql-extras"
	EGIT_CLONE_TYPE=shallow
	MY_PATCH_DIR="${WORKDIR}/mysql-extras"
else
	MY_PATCH_DIR="${WORKDIR}/mysql-extras-${MY_EXTRAS_VER}"
fi

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
	"${MY_PATCH_DIR}"/20031_all_mysql-5.6-fix-monitor.test.patch
	"${MY_PATCH_DIR}"/20036_all_mysql-5.6-fix-rpl_semi_sync_shutdown_hang.test.patch
	"${MY_PATCH_DIR}"/20018_all_mysql-5.6.44-fix-libressl-support.patch
	"${MY_PATCH_DIR}"/20018_all_mysql-5.6.44-add-openssl-1.1-support.patch
)

# Be warned, *DEPEND are version-dependant
# These are used for both runtime and compiletime
COMMON_DEPEND="
	kernel_linux? (
		sys-process/procps:0=
		dev-libs/libaio:0=
	)
	net-misc/curl
	>=sys-apps/sed-4
	>=sys-apps/texinfo-4.7-r1
	jemalloc? ( dev-libs/jemalloc:0= )
	tcmalloc? ( dev-util/google-perftools:0= )
	systemtap? ( >=dev-util/systemtap-1.3:0= )
	!yassl? (
		!libressl? ( >=dev-libs/openssl-1.0.0:0= )
		libressl? ( =dev-libs/libressl-2.6.5*:0= )
	)
	>=sys-libs/zlib-1.2.3:0=
	sys-libs/ncurses:0=
	server? (
		numa? ( sys-process/numactl )
	)
	!client-libs? ( dev-db/mysql-connector-c[${MULTILIB_USEDEP},static-libs?] )
"
DEPEND="virtual/yacc
	static? ( sys-libs/ncurses[static-libs] )
	test? ( dev-perl/JSON )
	|| ( >=sys-devel/gcc-3.4.6 >=sys-devel/gcc-apple-4.0 )
	${COMMON_DEPEND}"
RDEPEND="selinux? ( sec-policy/selinux-mysql )
	client-libs? ( !dev-db/mariadb-connector-c[mysqlcompat] !dev-db/mysql-connector-c )
	!dev-db/mariadb !dev-db/mariadb-galera !dev-db/percona-server !dev-db/mysql-cluster
	server? ( !prefix? ( dev-db/mysql-init-scripts ) )
	${COMMON_DEPEND}
"
# For other stuff to bring us in
# dev-perl/DBD-mysql is needed by some scripts installed by MySQL
PDEPEND="perl? ( >=dev-perl/DBD-mysql-2.9004 )"

pkg_setup() {
	if [[ ${MERGE_TYPE} != binary ]] ; then
		local GCC_MAJOR_SET=$(gcc-major-version)
		local GCC_MINOR_SET=$(gcc-minor-version)
		# Bug 565584.  InnoDB now requires atomic functions introduced with gcc-4.7 on
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

	# This should come after all of the die statements
	enewgroup mysql 60 || die "problem adding 'mysql' group"
	enewuser mysql 60 -1 /dev/null mysql || die "problem adding 'mysql' user"
}

pkg_preinst() {
	# Here we need to see if the implementation switched client libraries
	# We check if this is a new instance of the package and a client library already exists
	local SHOW_ABI_MESSAGE libpath
	if use client-libs && [[ -z ${REPLACING_VERSIONS} && -e "${EROOT%/}/usr/$(get_libdir)/libmysqlclient.so" ]] ; then
		libpath=$(readlink "${EROOT%/}/usr/$(get_libdir)/libmysqlclient.so")
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
}

src_unpack() {
	unpack ${A}
	# Grab the patches
	[[ "${MY_EXTRAS_VER}" == "live" ]] && S="${WORKDIR}/mysql-extras" git-r3_src_unpack

	mv -f "${WORKDIR}/${P}" "${S}" || die
}

src_prepare() {
	_disable_engine() {
		echo > "${S%/}/storage/${1}/CMakeLists.txt" || die
	}

	_disable_plugin() {
		echo > "${S%/}/plugin/${1}/CMakeLists.txt" || die
	}

	if use jemalloc ; then
		echo "TARGET_LINK_LIBRARIES(mysqld jemalloc)" >> "${S}/sql/CMakeLists.txt" || die
	fi
	if use tcmalloc; then
		echo "TARGET_LINK_LIBRARIES(mysqld tcmalloc)" >> "${S}/sql/CMakeLists.txt" || die
	fi
	# Remove the centos and rhel selinux policies to support mysqld_safe under SELinux
	if [[ -d "${S}/support-files/SELinux" ]] ; then
		echo > "${S}/support-files/SELinux/CMakeLists.txt" || die
	fi

	if use libressl ; then
		sed -i 's/OPENSSL_MAJOR_VERSION STREQUAL "1"/OPENSSL_MAJOR_VERSION STREQUAL "2"/' \
			"${S}/cmake/ssl.cmake" || die
	fi

	sed -i 's~ADD_SUBDIRECTORY(storage/ndb)~~' CMakeLists.txt || die

	local plugin
	local server_plugins=( semisync )
	local test_plugins=( audit_null daemon_example fulltext )
	if ! use server; then # These plugins are for the server
		for plugin in "${server_plugins[@]}" ; do
			_disable_plugin "${plugin}"
		done
	fi

	if ! use test; then # These plugins are only used during testing
		for plugin in "${test_plugins[@]}" ; do
			_disable_plugin "${plugin}"
		done
	fi

	# Don't build example
	_disable_engine example
	_disable_engine ndb
	_disable_plugin innodb_memcached

	cmake-utils_src_prepare
}

src_configure(){
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
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr"
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
		# The build forces this to be defined when cross-compiling.  We pass it
		# all the time for simplicity and to make sure it is actually correct.
		-DSTACK_DIRECTION=$(tc-stack-grows-down && echo -1 || echo 1)
		-DWITH_LIBEVENT=NO
		-DWITHOUT_CLIENTLIBS=YES
		-DENABLE_DTRACE=$(usex systemtap)
		-DWITH_SSL=$(usex yassl bundled system)
		-DINSTALL_MYSQLTESTDIR=$(usex test 'share/mysql/mysql-test' '')
		-DWITHOUT_VALIDATE_PASSWORD=1
	)

	if use server ; then

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
			-DWITH_NUMA=$(usex numa ON OFF)
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

		if use static; then
			mycmakeargs+=( -DWITH_PIC=1 )
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
			-DWITH_INNODB_MEMCACHED=0
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
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install

	# Kill old libmysqclient_r symlinks if they exist.  Time to fix what depends on them.
	find "${D}" -name 'libmysqlclient_r.*' -type l -delete || die
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

	if [[ -d "${ED%/}/usr/sql-bench" ]] ; then
		mv "${ED%/}/usr/sql-bench" "${ED%/}/usr/share/mysql/" || die
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
	[[ -f "${S%/}/scripts/mysqlaccess.conf" ]] && doins "${S%/}"/scripts/mysqlaccess.conf
	local mycnf_src="my.cnf-5.6"
	sed -e "s!@DATADIR@!${MY_DATADIR}!g" \
		"${FILESDIR%/}/${mycnf_src}" \
		> "${TMPDIR%/}/my.cnf.ok" || die
	use prefix && sed -i -r -e '/^user[[:space:]]*=[[:space:]]*mysql$/d' "${TMPDIR%/}/my.cnf.ok"
	if use latin1 ; then
		sed -i \
			-e "/character-set/s|utf8|latin1|g" \
			"${TMPDIR%/}/my.cnf.ok" || die
	fi
	eprefixify "${TMPDIR%/}/my.cnf.ok"
	newins "${TMPDIR}/my.cnf.ok" my.cnf

	if use server ; then
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
	fi

	#Remove mytop if perl is not selected
	[[ -e "${ED}/usr/bin/mytop" ]] && ! use perl && rm -f "${ED}/usr/bin/mytop"
}

# Official test instructions:
# USE='perl server static-libs' \
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
	mkdir -p "${T}"/var-tests{,/log} || die

	# Run mysql tests
	pushd "${TESTDIR}" > /dev/null || die

	touch "${T}/disabled.def"
	# These are failing in MySQL 5.6 for now and are believed to be
	# false positives:
	#
	local t

	for t in auth_sec.keyring_udf federated.federated_plugin ; do
			_disable_test  "$t" "False positives in Gentoo"
	done

	if ! use latin1 ; then
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
		; do
			_disable_test  "$t" "Requires DEFAULT_CHARSET=latin1 but USE=-latin1 is set"
		done
	fi

	if has_version '>=dev-libs/openssl-1.1.0' ; then
		# Tests are expecting <openssl-1.1 default cipher
		for t in \
			main.openssl_1 \
			main.plugin_auth_sha256_tls \
			main.ssl \
			main.ssl_8k_key \
			main.ssl_ca \
			main.ssl_cipher\
			main.ssl_compress \
			main.ssl_crl \
			main.ssl-sha512 \
		; do
			_disable_test  "$t" "Requires <dev-libs/openssl-1.1.0"
		done
	fi

	_disable_test main.gis-precise "Known rounding error with latest AMD processors"

	# run mysql-test tests
	perl mysql-test-run.pl --force --vardir="${T}/var-tests" --reorder --skip-test=tokudb --skip-test-list="${T}/disabled.def"
	retstatus_tests=$?

	popd > /dev/null || die

	# Cleanup is important for these testcases.
	pkill -9 -f "${S}/ndb" 2>/dev/null
	pkill -9 -f "${S}/sql" 2>/dev/null

	local failures=""
	[[ $retstatus_unit -eq 0 ]] || failures="${failures} test-unit"
	[[ $retstatus_tests -eq 0 ]] || failures="${failures} tests"

	[[ -z "$failures" ]] || die "Test failures: $failures"
	einfo "Tests successfully completed"
}

mysql_init_vars() {
	MY_SHAREDSTATEDIR=${MY_SHAREDSTATEDIR="${EPREFIX%/}/usr/share/mysql"}
	MY_SYSCONFDIR=${MY_SYSCONFDIR="${EPREFIX%/}/etc/mysql"}
	MY_LOCALSTATEDIR=${MY_LOCALSTATEDIR="${EPREFIX%/}/var/lib/mysql"}
	MY_LOGDIR=${MY_LOGDIR="${EPREFIX%/}/var/log/mysql"}

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
		if [[ ${EBUILD_PHASE} == "config" ]]; then
			local new_MY_DATADIR
			new_MY_DATADIR=`"my_print_defaults" mysqld 2>/dev/null \
				| sed -ne '/datadir/s|^--datadir=||p' \
				| tail -n1`

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
	export HOME=${EPREFIX%/}/root

	# Make sure the vars are correctly initialized
	mysql_init_vars

	[[ -z "${MY_DATADIR}" ]] && die "Sorry, unable to find MY_DATADIR"
	if [[ ! -x "${EROOT%/}/usr/sbin/mysqld" ]] ; then
		die "Minimal builds do NOT include the MySQL server"
	fi

	if [[ ( -n "${MY_DATADIR}" ) && ( "${MY_DATADIR}" != "${old_MY_DATADIR}" ) ]]; then
		local MY_DATADIR_s="${ROOT%/}/${MY_DATADIR}"
		MY_DATADIR_s="${MY_DATADIR_s%%/}"
		local old_MY_DATADIR_s="${ROOT%/}/${old_MY_DATADIR}"
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
	MYSQL_TMPDIR="$(_getoptval mysqld tmpdir)"
	# These are dir+prefix
	MYSQL_RELAY_LOG="$(_getoptval mysqld relay-log)"
	MYSQL_RELAY_LOG=${MYSQL_RELAY_LOG%/*}
	MYSQL_LOG_BIN="$(_getoptval mysqld log-bin)"
	MYSQL_LOG_BIN=${MYSQL_LOG_BIN%/*}

	if [[ ! -d "${EROOT%/}/$MYSQL_TMPDIR" ]]; then
		einfo "Creating MySQL tmpdir $MYSQL_TMPDIR"
		install -d -m 770 -o mysql -g mysql "${EROOT%/}/$MYSQL_TMPDIR"
	fi
	if [[ ! -d "${EROOT%/}/$MYSQL_LOG_BIN" ]]; then
		einfo "Creating MySQL log-bin directory $MYSQL_LOG_BIN"
		install -d -m 770 -o mysql -g mysql "${EROOT%/}/$MYSQL_LOG_BIN"
	fi
	if [[ ! -d "${EROOT%/}/$MYSQL_RELAY_LOG" ]]; then
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

	if [ -z "${MYSQL_ROOT_PASSWORD}" ]; then

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

	local help_tables="${EROOT%/}${MY_SHAREDSTATEDIR}/fill_help_tables.sql"
	[[ -r "${help_tables}" ]] \
	&& cp "${help_tables}" "${TMPDIR}/fill_help_tables.sql" \
	|| touch "${TMPDIR}/fill_help_tables.sql"
	help_tables="${TMPDIR}/fill_help_tables.sql"

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
	if [[ ! -d "${PID_DIR}" ]]; then
		install -d -m 755 -o mysql -g mysql "${PID_DIR}" || die "Could not create pid directory"
	fi

	if [[ ! -d "${MY_DATADIR}" ]]; then
		install -d -m 750 -o mysql -g mysql "${MY_DATADIR}" || die "Could not create data directory"
	fi

	pushd "${TMPDIR}" &>/dev/null || die

	# Filling timezones, see
	# http://dev.mysql.com/doc/mysql/en/time-zone-support.html
	"${EROOT%/}/usr/bin/mysql_tzinfo_to_sql" "${EROOT%/}/usr/share/zoneinfo" >> "${sqltmp}" 2>/dev/null
	chown mysql "${sqltmp}" || die

	local cmd=( "${EROOT%/}/usr/share/mysql/scripts/mysql_install_db" )
	[[ -f "${cmd}" ]] || cmd=( "${EROOT%/}/usr/bin/mysql_install_db" )
	if [[ -r "${help_tables}" ]] ; then
		cat "${help_tables}" >> "${sqltmp}"
	fi
	cmd+=( "--basedir=${EPREFIX%/}/usr" ${options} "--datadir=${ROOT%/}${MY_DATADIR}" "--tmpdir=${ROOT%/}${MYSQL_TMPDIR}" )
	einfo "Command: ${cmd[*]}"
	su -s /bin/sh -c "${cmd[*]}" mysql \
		>"${TMPDIR%/}"/mysql_install_db.log 2>&1
	if [ $? -ne 0 ]; then
		grep -B5 -A999 -i "ERROR" "${TMPDIR%/}"/mysql_install_db.log 1>&2
		die "Failed to initialize mysqld. Please review ${EPREFIX%/}/var/log/mysql/mysqld.err AND ${TMPDIR%/}/mysql_install_db.log"
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

	if ! [[ -S "${socket}" ]]; then
		die "Completely failed to start up mysqld with: ${mysqld}"
	fi

	ebegin "Setting root password"
	# Do this from memory, as we don't want clear text passwords in temp files
	local sql="SET PASSWORD FOR 'root'@'localhost' = PASSWORD('${MYSQL_ROOT_PASSWORD}');"
	"${EROOT%/}/usr/bin/mysql" \
		--no-defaults \
		"--socket=${socket}" \
		-hlocalhost \
		-e "${sql}"
	eend $?

	if [[ -n "${sqltmp}" ]] ; then
		ebegin "Loading \"zoneinfo\", this step may require a few seconds"
		"${EROOT%/}/usr/bin/mysql" \
			--socket="${socket}" \
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
