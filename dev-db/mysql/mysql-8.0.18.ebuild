# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
MY_EXTRAS_VER="20191016-1722Z"

CMAKE_MAKEFILE_GENERATOR=emake

inherit cmake-utils flag-o-matic linux-info \
	multiprocessing prefix toolchain-funcs check-reqs

MY_PV="${PV//_pre*}"
MY_P="${PN}-${MY_PV}"

S="${WORKDIR}/${PN}-${MY_PV}"

SRC_URI="https://cdn.mysql.com/Downloads/MySQL-8.0/mysql-boost-${MY_PV}.tar.gz
	https://cdn.mysql.com/archives/mysql-8.0/mysql-boost-${MY_PV}.tar.gz
	http://downloads.mysql.com/archives/MySQL-8.0/${PN}-boost-${MY_PV}.tar.gz"

# Gentoo patches to MySQL
if [[ "${MY_EXTRAS_VER}" != "live" && "${MY_EXTRAS_VER}" != "none" ]] ; then
	SRC_URI="${SRC_URI}
		mirror://gentoo/mysql-extras-${MY_EXTRAS_VER}.tar.bz2
		https://gitweb.gentoo.org/proj/mysql-extras.git/snapshot/mysql-extras-${MY_EXTRAS_VER}.tar.bz2"
fi

HOMEPAGE="https://www.mysql.com/"
DESCRIPTION="A fast, multi-threaded, multi-user SQL database server"
LICENSE="GPL-2"
SLOT="0"
IUSE="cjk cracklib debug jemalloc latin1 libressl numa +perl profiling
	router selinux +server tcmalloc test"

# Tests always fail when libressl is enabled due to hard-coded ciphers in the tests
RESTRICT="!test? ( test ) libressl? ( test )"

REQUIRED_USE="?? ( tcmalloc jemalloc )"

KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"

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
	"${MY_PATCH_DIR}"/20001_all_fix-minimal-build-cmake-mysql-8.0.17.patch
	"${MY_PATCH_DIR}"/20007_all_cmake-debug-werror-8.0.18.patch
	"${MY_PATCH_DIR}"/20018_all_mysql-5.7.23-fix-grant_user_lock-a-root.patch
	"${MY_PATCH_DIR}"/20018_all_mysql-8.0.18-without-clientlibs-tools.patch
	"${MY_PATCH_DIR}"/20018_all_mysql-8.0.17-add-protobuf-3.8+-support.patch
	"${MY_PATCH_DIR}"/20018_all_mysql-8.0.18-fix-libressl-support.patch
)

# Be warned, *DEPEND are version-dependant
# These are used for both runtime and compiletime
COMMON_DEPEND="
	>=app-arch/lz4-0_p131:=
	dev-libs/icu:=
	dev-libs/libedit
	>=dev-libs/protobuf-3.8:=
	dev-libs/libevent:=
	net-libs/libtirpc:=
	>=sys-libs/zlib-1.2.3:0=
	cjk? ( app-text/mecab:= )
	jemalloc? ( dev-libs/jemalloc:0= )
	kernel_linux? (
		dev-libs/libaio:0=
		sys-process/procps:0=
	)
	libressl? ( dev-libs/libressl:0= )
	!libressl? ( >=dev-libs/openssl-1.0.0:0= )
	numa? ( sys-process/numactl )
	tcmalloc? ( dev-util/google-perftools:0= )
"
DEPEND="${COMMON_DEPEND}
	|| ( >=sys-devel/gcc-3.4.6 >=sys-devel/gcc-apple-4.0 )
	net-libs/rpcsvc-proto
	virtual/yacc
	test? (
		acct-group/mysql acct-user/mysql
		dev-perl/JSON
	)
"
RDEPEND="${COMMON_DEPEND}
	!dev-db/mariadb !dev-db/mariadb-galera !dev-db/percona-server !dev-db/mysql-cluster
	selinux? ( sec-policy/selinux-mysql )
	!prefix? (
		acct-group/mysql acct-user/mysql
		dev-db/mysql-init-scripts
	)
"
# For other stuff to bring us in
# dev-perl/DBD-mysql is needed by some scripts installed by MySQL
PDEPEND="perl? ( >=dev-perl/DBD-mysql-2.9004 )"

CHECKREQS_DISK_BUILD="8G"

mysql_init_vars() {
	: ${MY_SHAREDSTATEDIR="${EPREFIX}/usr/share/mysql"}
	: ${MY_SYSCONFDIR="${EPREFIX}/etc/mysql"}
	: ${MY_LOCALSTATEDIR="${EPREFIX}/var/lib/mysql"}
	: ${MY_LOGDIR="${EPREFIX}/var/log/mysql"}
	MY_DATADIR="${MY_LOCALSTATEDIR}"

	export MY_SHAREDSTATEDIR MY_SYSCONFDIR
	export MY_LOCALSTATEDIR MY_LOGDIR
	export MY_DATADIR
}

pkg_pretend() {
	[[ ${MERGE_TYPE} == binary ]] && return
	use server && check-reqs_pkg_pretend
}

pkg_setup() {
	[[ ${MERGE_TYPE} == binary ]] && return

	if has test ${FEATURES} ; then
		# Bug #213475 - MySQL _will_ object strenuously if your machine is named
		# localhost. Also causes weird failures.
		[[ "${HOSTNAME}" == "localhost" ]] && die "Your machine must NOT be named localhost"

		if ! has userpriv ${FEATURES} ; then
			die "Testing with FEATURES=-userpriv is no longer supported by upstream. Tests MUST be run as non-root."
		fi

		local aio_max_nr=$(sysctl -n fs.aio-max-nr 2>/dev/null)
		[[ -z "${aio_max_nr}" || ${aio_max_nr} -lt 250000 ]] \
			&& die "FEATURES=test will require fs.aio-max-nr=250000 at minimum!"

		if use latin1 ; then
			# Upstream only supports tests with default charset
			die "Testing with USE=latin1 is not supported."
		fi
	fi

	if use kernel_linux ; then
		if use numa ; then
			linux-info_get_any_version

			local CONFIG_CHECK="~NUMA"

			local WARNING_NUMA="This package expects NUMA support in kernel which this system does not have at the moment;"
			WARNING_NUMA+=" Either expect runtime errors, enable NUMA support in kernel or rebuild the package without NUMA support"

			check_extra_config
		fi
	fi

	use server && check-reqs_pkg_setup
}

src_unpack() {
	unpack ${A}

	# Grab the patches
	[[ "${MY_EXTRAS_VER}" == "live" ]] && S="${WORKDIR}/mysql-extras" git-r3_src_unpack

	mv -f "${WORKDIR}/${MY_P}" "${S}" || die
}

src_prepare() {
	# Avoid rpm call which would trigger sandbox, #692368
	sed -i \
		-e 's/MY_RPM rpm/MY_RPM rpmNOTEXISTENT/' \
		CMakeLists.txt || die

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

	# Remove man pages for client-lib tools we don't install
	rm \
		man/my_print_defaults.1 \
		man/perror.1 \
		man/zlib_decompress.1 \
		|| die

	cmake-utils_src_prepare
}

src_configure(){
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
		-DINSTALL_MYSQLDATADIR="${EPREFIX}/var/lib/mysql"
		-DINSTALL_SBINDIR=sbin
		-DINSTALL_SUPPORTFILESDIR="${EPREFIX}/usr/share/mysql"
		-DCOMPILATION_COMMENT="Gentoo Linux ${PF}"
		-DWITH_UNIT_TESTS=$(usex test ON OFF)
		-DWITH_EDITLINE=system
		-DWITH_ZLIB=system
		-DWITH_SSL=system
		-DWITH_LIBWRAP=0
		-DENABLED_LOCAL_INFILE=1
		-DMYSQL_UNIX_ADDR="${EPREFIX}/var/run/mysqld/mysqld.sock"
		-DWITH_DEFAULT_COMPILER_OPTIONS=0
		-DWITH_DEFAULT_FEATURE_SET=0
		# The build forces this to be defined when cross-compiling. We pass it
		# all the time for simplicity and to make sure it is actually correct.
		-DSTACK_DIRECTION=$(tc-stack-grows-down && echo -1 || echo 1)
		-DCMAKE_POSITION_INDEPENDENT_CODE=ON
		-DWITH_CURL=system
		-DWITH_BOOST="${S}/boost"
		-DWITH_ROUTER=$(usex router ON OFF)
	)
	if use test ; then
		mycmakeargs+=( -DINSTALL_MYSQLTESTDIR=share/mysql/mysql-test )
	else
		mycmakeargs+=( -DINSTALL_MYSQLTESTDIR='' )
	fi

	mycmakeargs+=( -DWITHOUT_CLIENTLIBS=YES )

	# client/mysql.cc:1131:16: error: redefinition of ‘struct _hist_entry’
	mycmakeargs+=(
		-DUSE_LIBEDIT_INTERFACE=0
		-DUSE_NEW_EDITLINE_INTERFACE=1
		-DHAVE_HIST_ENTRY=1
	)

	mycmakeargs+=(
		-DWITH_ICU=system
		-DWITH_LIBEVENT=system
		-DWITH_LZ4=system
		-DWITH_PROTOBUF=system
		-DWITH_MECAB=$(usex cjk system OFF)
		-DWITH_NUMA=$(usex numa ON OFF)
		# Our dev-libs/rapidjson doesn't carry necessary fixes for std::regex
		-DWITH_RAPIDJSON=bundled
	)

	if [[ -n "${MYSQL_DEFAULT_CHARSET}" && -n "${MYSQL_DEFAULT_COLLATION}" ]] ; then
		ewarn "You are using a custom charset of ${MYSQL_DEFAULT_CHARSET}"
		ewarn "and a collation of ${MYSQL_DEFAULT_COLLATION}."
		ewarn "You MUST file bugs without these variables set."
		ewarn "Tests will probably fail!"

		mycmakeargs+=(
			-DDEFAULT_CHARSET=${MYSQL_DEFAULT_CHARSET}
			-DDEFAULT_COLLATION=${MYSQL_DEFAULT_COLLATION}
		)
	elif use latin1 ; then
		mycmakeargs+=(
			-DDEFAULT_CHARSET=latin1
			-DDEFAULT_COLLATION=latin1_swedish_ci
		)
	else
		mycmakeargs+=(
			-DDEFAULT_CHARSET=utf8mb4
			-DDEFAULT_COLLATION=utf8mb4_0900_ai_ci
		)
	fi

	if use server ; then
		mycmakeargs+=(
			-DWITH_EXTRA_CHARSETS=all
			-DWITH_DEBUG=$(usex debug)
		)

		if use profiling ; then
			# Setting to OFF doesn't work: Once set, profiling options will be added
			# to `mysqld --help` output via sql/sys_vars.cc causing
			# "main.mysqld--help-notwin" test to fail
			mycmakeargs+=( -DENABLED_PROFILING=ON )
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
		)
	else
		mycmakeargs+=(
			-DWITHOUT_SERVER=1
			-DWITH_SYSTEMD=no
		)
	fi

	cmake-utils_src_configure
}

# Official test instructions:
# ulimit -n 16500 && \
# USE='perl server' \
# FEATURES='test userpriv' \
# ebuild mysql-X.X.XX.ebuild \
# digest clean package
src_test() {
	_disable_test() {
		local rawtestname bug reason
		rawtestname="${1}" ; shift
		bug="${1}" ; shift
		reason="${@}"
		ewarn "test '${rawtestname}' disabled: '${reason}' (BUG#${bug})"
		echo ${rawtestname} : BUG#${bug} ${reason} >> "${T}/disabled.def"
	}

	local TESTDIR="${BUILD_DIR}/mysql-test"
	local retstatus_unit
	local retstatus_tests

	# Run CTest (test-units)
	cmake-utils_src_test
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

	# create directories because mysqladmin might run out of order
	mkdir -p "${T}"/var-tests{,/log} || die

	# Run mysql tests
	pushd "${TESTDIR}" &>/dev/null || die

	touch "${T}/disabled.def"

	local -a disabled_tests
	disabled_tests+=( "auth_sec.keyring_file_data_qa;0;Won't work with user privileges")
	disabled_tests+=( "gis.spatial_analysis_functions_buffer;5452;Known rounding error with latest AMD processors (PS)")
	disabled_tests+=( "gis.gis_bugs_crashes;5452;Known rounding error with latest AMD processors (PS)")
	disabled_tests+=( "gis.geometry_class_attri_prop;5452;Known rounding error with latest AMD processors (PS)")
	disabled_tests+=( "gis.spatial_utility_function_distance_sphere;5452;Known rounding error with latest AMD processors (PS)")
	disabled_tests+=( "gis.geometry_property_function_issimple;5452;Known rounding error with latest AMD processors (PS)")
	disabled_tests+=( "gis.spatial_analysis_functions_centroid;5452;Known rounding error with latest AMD processors (PS)")
	disabled_tests+=( "gis.spatial_operators_intersection;5452;Known rounding error with latest AMD processors (PS)")
	disabled_tests+=( "gis.spatial_utility_function_simplify;5452;Known rounding error with latest AMD processors (PS)")
	disabled_tests+=( "gis.spatial_op_testingfunc_mix;5452;Known rounding error with latest AMD processors (PS)")
	disabled_tests+=( "gis.spatial_analysis_functions_distance;5452;Known rounding error with latest AMD processors (PS)")
	disabled_tests+=( "main.window_std_var;0;Known rounding error with latest AMD processors -- no upstream bug yet")
	disabled_tests+=( "main.window_std_var_optimized;0;Known rounding error with latest AMD processors -- no upstream bug yet")
	disabled_tests+=( "rpl_gtid.rpl_gtid_stm_drop_table;90612;Known test failure" )
	disabled_tests+=( "rpl_gtid.rpl_multi_source_mtr_includes;0;Known failure - no upstream bug yet" )
	disabled_tests+=( "sys_vars.myisam_data_pointer_size_func;87935;Test will fail on slow hardware")
	disabled_tests+=( "x.connection;0;Known failure - no upstream bug yet" )
	disabled_tests+=( "main.mysqlpump_basic_lz4;0;Extra tool output causes false positive" )

	local test_ds
	for test_infos_str in "${disabled_tests[@]}" ; do
		IFS=';' read -r -a test_infos_arr <<< "${test_infos_str}"

		if [[ ${#test_infos_arr[@]} != 3 ]] ; then
			die "Invalid test data set, not matching format: ${test_infos_str}"
		fi

		_disable_test "${test_infos_arr[0]}" "${test_infos_arr[1]}" "${test_infos_arr[2]}"
	done
	unset test_ds test_infos_str test_infos_arr

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
	cmake-utils_src_install

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
		rm -rf "${ED}/${MY_SHAREDSTATEDIR#${EPREFIX}}/mysql-test"
	fi

	# Configuration stuff
	einfo "Building default configuration ..."
	insinto "${MY_SYSCONFDIR#${EPREFIX}}"
	[[ -f "${S}/scripts/mysqlaccess.conf" ]] && doins "${S}"/scripts/mysqlaccess.conf
	cp "${FILESDIR}/my.cnf-5.7" "${TMPDIR}/my.cnf" || die
	eprefixify "${TMPDIR}/my.cnf"
	doins "${TMPDIR}/my.cnf"
	insinto "${MY_SYSCONFDIR#${EPREFIX}}/mysql.d"
	cp "${FILESDIR}/my.cnf-8.0.distro-client" "${TMPDIR}/50-distro-client.cnf" || die
	eprefixify "${TMPDIR}/50-distro-client.cnf"
	doins "${TMPDIR}/50-distro-client.cnf"

	mycnf_src="my.cnf-8.0.distro-server"
	sed -e "s!@DATADIR@!${MY_DATADIR}!g" \
		"${FILESDIR}/${mycnf_src}" \
		> "${TMPDIR}/my.cnf.ok" || die

	if use prefix ; then
		sed -i -r -e '/^user[[:space:]]*=[[:space:]]*mysql$/d' \
			"${TMPDIR}/my.cnf.ok" || die
	fi

	if use latin1 ; then
		sed -i \
			-e "/character-set/s|utf8mb4|latin1|g" \
			"${TMPDIR}/my.cnf.ok" || die
	fi

	eprefixify "${TMPDIR}/my.cnf.ok"

	newins "${TMPDIR}/my.cnf.ok" 50-distro-server.cnf

	#Remove mytop if perl is not selected
	[[ -e "${ED}/usr/bin/mytop" ]] && ! use perl && rm -f "${ED}/usr/bin/mytop"

	if use router ; then
		rm -rf \
			"${ED}/usr/LICENSE.router" \
			"${ED}/usr/README.router" \
			"${ED}/usr/run" \
			"${ED}/usr/var" \
			|| die
	fi

	# Kill old libmysqclient_r symlinks if they exist. Time to fix what depends on them.
	find "${D}" -name 'libmysqlclient_r.*' -type l -delete || die
}

pkg_postinst() {
	# Make sure the vars are correctly initialized
	mysql_init_vars

	# Create log directory securely if it does not exist
	# NOTE: $MY_LOGDIR contains $EPREFIX by default
	[[ -d "${MY_LOGDIR}" ]] || install -d -m0750 -o mysql -g mysql "${MY_LOGDIR}"

	# Note about configuration change
	einfo
	elog "This version of ${PN} reorganizes the configuration from a single my.cnf"
	elog "to several files in /etc/mysql/mysql.d."
	elog "Please backup any changes you made to /etc/mysql/my.cnf"
	elog "and add them as a new file under /etc/mysql/mysql.d with a .cnf extension."
	elog "You may have as many files as needed and they are read alphabetically."
	elog "Be sure the options have the appropriate section headers, i.e. [mysqld]."
	einfo

	if [[ -z "${REPLACING_VERSIONS}" ]] ; then
		einfo
		elog "You might want to run:"
		elog "  \"emerge --config =${CATEGORY}/${PF}\""
		elog "if this is a new install."
		einfo
	else
		einfo
		elog "Upgrade process for ${PN}-8.x has changed. Please read"
		elog "https://dev.mysql.com/doc/refman/8.0/en/upgrade-binary-package.html"
		einfo
	fi
}

pkg_config() {
	local mysqld_binary="${EROOT}/usr/sbin/mysqld"
	if [[ ! -x "${mysqld_binary}" ]] ; then
		die "'${mysqld_binary}' not found! Please re-install ${CATEGORY}/${PN}!"
	fi

	local mysql_binary="${EROOT}/usr/bin/mysql"
	if [[ ! -x "${mysql_binary}" ]] ; then
		die "'${mysql_binary}' not found! Please re-install ${CATEGORY}/${PN}!"
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

	einfo "Will use username '${MYSQL_USER}' and group '${MYSQL_GROUP}' ..."

	_getoptval() {
		local section="$1"
		local flag="--${2}="
		local extra_options="${3}"
		local cmd=(
			"${my_print_defaults_binary}"
			"${extra_options}"
			"${section}"
		)
		local results=( $(eval "${cmd[@]}" 2>/dev/null | sed -n "/^${flag}/s,${flag},,gp") )

		if [[ ${#results[@]} -gt 0 ]] ; then
			# When option is set multiple times only return last value
			echo "${results[-1]}"
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
	else
		einfo "${PN} data directory detected as '${MY_DATADIR}' ..."
	fi

	MYSQL_TMPDIR="$(_getoptval mysqld tmpdir "--defaults-file='${MY_SYSCONFDIR}/my.cnf'")"
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

	if [[ $? -ne 0 ]]; then
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

	if [[ -n "${MYSQL_TMPDIR}" ]] ; then
		local _my_tmpdir_testfile="$(_mktemp_dry "${MYSQL_TMPDIR}/.pkg_config-access-test.XXXXXXXXX")"
		[[ -z "${_my_tmpdir_testfile}" ]] \
			&& die "_mktemp_dry() for '${MYSQL_TMPDIR}/.pkg_config-access-test.XXXXXXXXX' failed!"

		if use prefix ; then
			touch "${_my_tmpdir_testfile}" &>/dev/null
		else
			su -s /bin/sh -c "touch ${_my_tmpdir_testfile}" ${MYSQL_USER} &>/dev/null
		fi

		if [[ $? -ne 0 ]]; then
			die "${MYSQL_USER} user cannot write into data directory '${MYSQL_TMPDIR}'!"
		else
			rm "${_my_tmpdir_testfile}" || die
			unset _my_tmpdir_testfile
		fi
	else
		# If no tmpdir is set, mysqld will use default system tmpdir.
		# However, we are using tmpdir from package manager at the
		# moment which maybe isn't writeable for $MYSQL_USER...
		MYSQL_TMPDIR="$(_mktemp_dry "${T}/mysqld-tmp.XXXXXXXXX")"
		[[ -z "${MYSQL_TMPDIR}" ]] \
			&& die "_mktemp_dry() for '${MYSQL_TMPDIR}' failed!"

		mkdir "${MYSQL_TMPDIR}" || die
		chown ${MYSQL_USER} "${MYSQL_TMPDIR}" || die
	fi

	if [[ -n "${MYSQL_LOG_BIN}" && ! -d "${MYSQL_LOG_BIN}" ]] ; then
		einfo "Creating ${PN} log-bin directory '${MYSQL_LOG_BIN}' ..."
		install -d -m 770 -o ${MYSQL_USER} -g ${MYSQL_GROUP} "${MYSQL_LOG_BIN}" \
			|| die "Failed to create ${PN} log-bin directory '${MYSQL_LOG_BIN}'"
	fi

	if [[ -n "${MYSQL_LOG_BIN}" ]] ; then
		local _my_logbin_testfile="$(_mktemp_dry "${MYSQL_LOG_BIN}/.pkg_config-access-test.XXXXXXXXX")"
		[[ -z "${_my_logbin_testfile}" ]] \
			&& die "_mktemp_dry() for '${MYSQL_LOG_BIN}/.pkg_config-access-test.XXXXXXXXX' failed!"

		if use prefix ; then
			touch "${_my_logbin_testfile}" &>/dev/null
		else
			su -s /bin/sh -c "touch ${_my_logbin_testfile}" ${MYSQL_USER} &>/dev/null
		fi

		if [[ $? -ne 0 ]]; then
			die "${MYSQL_USER} user cannot write into log-bin directory '${MYSQL_LOG_BIN}'!"
		else
			rm "${_my_logbin_testfile}" || die
			unset _my_logbin_testfile
		fi
	fi

	if [[ -n "${MYSQL_RELAY_LOG}" && ! -d "${MYSQL_RELAY_LOG}" ]] ; then
		einfo "Creating ${PN} relay-log directory '${MYSQL_RELAY_LOG}' ..."
		install -d -m 770 -o ${MYSQL_USER} -g ${MYSQL_GROUP} "${MYSQL_RELAY_LOG}" \
			|| die "Failed to create ${PN} relay-log directory '${MYSQL_RELAY_LOG}'!"
	fi

	if [[ -n "${MYSQL_RELAY_LOG}" ]] ; then
		local _my_relaylog_testfile="$(_mktemp_dry "${MYSQL_RELAY_LOG}/.pkg_config-access-test.XXXXXXXXX")"
		[[ -z "${_my_relaylog_testfile}" ]] \
			&& die "_mktemp_dry() for '${MYSQL_RELAY_LOG}/.pkg_config-access-test.XXXXXXXXX' failed!"

		if use prefix ; then
			touch "${_my_relaylog_testfile}" &>/dev/null
		else
			su -s /bin/sh -c "touch ${_my_relaylog_testfile}" ${MYSQL_USER} &>/dev/null
		fi

		if [[ $? -ne 0 ]]; then
			die "${MYSQL_USER} user cannot write into relay-log directory '${MYSQL_RELAY_LOG}'!"
		else
			rm "${_my_relaylog_testfile}" || die
			unset _my_relaylog_testfile
		fi
	fi

	local -a config_files

	local config_file="${EROOT}/etc/mysql/mysql.d/50-distro-client.cnf"
	if [[ -f "${config_file}" ]] ; then
		config_files+=( "${config_file}" )
	else
		ewarn "Client configuration '${config_file}' not found; Skipping configuration of default authentication plugin for client ..."
	fi

	config_file="${EROOT}/etc/mysql/mysql.d/50-distro-server.cnf"
	if [[ -f "${config_file}" ]] ; then
		config_files+=( "${config_file}" )
	else
		ewarn "Server configuration '${config_file}' not found; Skipping configuration of default authentication plugin for mysqld ..."
	fi

	if [[ ${#config_files[@]} -gt 0 ]] ; then
		if [[ -z "${MYSQL_DEFAULT_AUTHENTICATION_PLUGIN}" ]] ; then
			local user_answer

			echo
			einfo "Please select default authentication plugin (enter number or plugin name):"
			einfo "1) caching_sha2_password [MySQL 8.0 default]"
			einfo "2) mysql_native_password [MySQL 5.7 default]"
			einfo
			einfo "For details see:"
			einfo "https://dev.mysql.com/doc/refman/8.0/en/upgrading-from-previous-series.html#upgrade-caching-sha2-password"
			read -p "    >" user_answer
			echo

			case "${user_answer}" in
				1|caching_sha2_password)
					MYSQL_DEFAULT_AUTHENTICATION_PLUGIN=caching_sha2_password
					;;
				2|mysql_native_password)
					MYSQL_DEFAULT_AUTHENTICATION_PLUGIN=mysql_native_password
					;;
				'')
					die "No authentication plugin selected!"
					;;
				*)
					die "Authentication plugin '${user_answer}' is unknown/unsupported!"
					;;
			esac

			unset user_answer
		fi

		local cfg_option cfg_option_tabs cfg_section
		for config_file in "${config_files[@]}" ; do
			cfg_option="default-authentication-plugin"
			cfg_section="mysqld"
			cfg_option_tabs="\t\t"
			if [[ "${config_file}" == *client.cnf ]] ; then
				cfg_option="default-auth"
				cfg_section="client"
				cfg_option_tabs="\t\t\t\t"
			fi

			if grep -qE "^(loose-)?${cfg_option}\b.*=" "${config_file}" 2>/dev/null ; then
				einfo "Ensuring that ${cfg_option} is set to '${MYSQL_DEFAULT_AUTHENTICATION_PLUGIN}' in '${config_file}' ..."
				sed -i \
					-e "s/^\(loose-\)\?${cfg_option}\b.*=.*/loose-${cfg_option}${cfg_option_tabs}= ${MYSQL_DEFAULT_AUTHENTICATION_PLUGIN}/" \
					"${config_file}" || die "Failed to change ${cfg_option} in '${config_file}'!"
			else
				einfo "Setting ${cfg_option} to '${MYSQL_DEFAULT_AUTHENTICATION_PLUGIN}' in '${config_file}' ..."
				sed -i \
					-e "/^\[${cfg_section}\]$/a loose-${cfg_option}${cfg_option_tabs}= ${MYSQL_DEFAULT_AUTHENTICATION_PLUGIN}" \
					"${config_file}" || die "Failed to add ${cfg_option} to '${config_file}'!"
			fi
		done
		unset cfg_option cfg_option_tabs cfg_section
	fi
	unset config_files config_file

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

		if [[ "x$pwd1" != "x$pwd2" ]] ; then
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
		egrep -sq -- "${optexp}" "${helpfile}" && mysqld_options+=( "${optfull}" )
	done

	# Prepare timezones, see
	# https://dev.mysql.com/doc/mysql/en/time-zone-support.html
	local tz_sql="${TMPDIR}/tz.sql"
	echo "USE mysql;" >"${tz_sql}"
	"${EROOT}/usr/bin/mysql_tzinfo_to_sql" "${EROOT}/usr/share/zoneinfo" >> "${tz_sql}" 2>/dev/null
	if [[ $? -ne 0 ]] ; then
		die "mysql_tzinfo_to_sql failed!"
	fi

	chown ${MYSQL_USER} "${tz_sql}" || die

	local mysql_install_log="${TMPDIR}/mysql_install_db.log"
	touch "${mysql_install_log}" || die
	chown ${MYSQL_USER} "${mysql_install_log}" || die

	# --initialize-insecure will not set root password
	# --initialize would set a random one in the log which we don't need as we set it ourselves
	local cmd=(
		"${mysqld_binary}"
		"${mysqld_options[@]}"
		"--initialize-insecure"
		"--init-file='${tz_sql}'"
		"--basedir='${EROOT}/usr'"
		"--datadir='${MY_DATADIR}'"
		"--tmpdir='${MYSQL_TMPDIR}'"
		"--log-error='${mysql_install_log}'"
		"--user=${MYSQL_USER}"
	)

	einfo "Initializing ${PN} data directory: ${cmd[@]}"
	eval "${cmd[@]}" >>"${mysql_install_log}" 2>&1

	if [[ $? -ne 0 || ! -f "${MY_DATADIR}/mysql.ibd" ]] ; then
		grep -B5 -A999 -iE "(Aborting|ERROR|errno)" "${mysql_install_log}" 1>&2
		die "Failed to initialize ${PN} data directory. Please review '${mysql_install_log}'!"
	fi

	local x=${RANDOM}
	local socket="${EROOT}/run/mysqld/mysqld${x}.sock"
	local pidfile="${EROOT}/run/mysqld/mysqld${x}.pid"
	unset x

	local mysqld_logfile="${TMPDIR}/mysqld.log"
	touch "${mysqld_logfile}" || die
	chown ${MYSQL_USER} "${mysqld_logfile}" || die

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

	local mysql_logfile="${TMPDIR}/set_root_pw.log"
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

	einfo "${PN} data directory at '${MY_DATADIR}' successfully initialized!"
}
