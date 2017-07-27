# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
MY_EXTRAS_VER="20170727-0052Z"
# The wsrep API version must match between upstream WSREP and sys-cluster/galera major number
WSREP_REVISION="25"
SUBSLOT="18"
MYSQL_PV_MAJOR="5.6"

JAVA_PKG_OPT_USE="jdbc"

inherit toolchain-funcs java-pkg-opt-2 prefix toolchain-funcs \
	multilib-minimal mysql-multilib-r1

HOMEPAGE="http://mariadb.org/"
DESCRIPTION="An enhanced, drop-in replacement for MySQL"
LICENSE="GPL-2 LGPL-2.1+"

IUSE="+backup bindist cracklib galera kerberos innodb-lz4 innodb-lzo innodb-snappy jdbc mroonga odbc oqgraph pam rocksdb sphinx sst-rsync sst-xtrabackup tokudb systemd xml"
RESTRICT="!bindist? ( bindist )"

REQUIRED_USE="jdbc? ( extraengine server !static ) server? ( tokudb? ( jemalloc !tcmalloc ) ) static? ( !pam )"

# REMEMBER: also update eclass/mysql*.eclass before committing!
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~sparc-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"

if [[ "${MY_EXTRAS_VER}" == "live" ]] ; then
	MY_PATCH_DIR="${WORKDIR}/mysql-extras"
else
	MY_PATCH_DIR="${WORKDIR}/mysql-extras-${MY_EXTRAS_VER}"
fi

PATCHES=(
	"${MY_PATCH_DIR}"/20015_all_mariadb-pkgconfig-location.patch
	"${MY_PATCH_DIR}"/20018_all_mariadb-10.2.7-without-clientlibs-tools.patch
	"${MY_PATCH_DIR}"/20024_all_mariadb-10.2.6-mysql_st-regression.patch
	"${MY_PATCH_DIR}"/20025_all_mariadb-10.2.6-gssapi-detect.patch
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
		)
		innodb-lz4? ( app-arch/lz4 )
		innodb-lzo? ( dev-libs/lzo )
		innodb-snappy? ( app-arch/snappy )
		oqgraph? ( >=dev-libs/boost-1.40.0:0= dev-libs/judy:0= )
		pam? ( virtual/pam:0= )
		systemd? ( sys-apps/systemd:= )
		tokudb? ( app-arch/snappy )
	)
	>=dev-libs/libpcre-8.35:3=
	sys-libs/zlib[${MULTILIB_USEDEP}]
"
DEPEND="|| ( >=sys-devel/gcc-3.4.6 >=sys-devel/gcc-apple-4.0 )
	server? ( extraengine? ( jdbc? ( >=virtual/jdk-1.6 ) ) )
	${COMMON_DEPEND}"
RDEPEND="${RDEPEND} ${COMMON_DEPEND}
	server? ( galera? (
		sys-apps/iproute2
		=sys-cluster/galera-${WSREP_REVISION}*
		sst-rsync? ( sys-process/lsof )
		sst-xtrabackup? ( net-misc/socat[ssl] )
	) )
	perl? ( !dev-db/mytop
		virtual/perl-Getopt-Long
		dev-perl/TermReadKey
		virtual/perl-Term-ANSIColor
		virtual/perl-Time-HiRes )
	server? ( extraengine? ( jdbc? ( >=virtual/jre-1.6 ) ) )
"
# xtrabackup-bin causes a circular dependency if DBD-mysql is not already installed
PDEPEND="server? ( galera? ( sst-xtrabackup? ( || ( >=dev-db/xtrabackup-bin-2.2.4 dev-db/percona-xtrabackup ) ) ) )"

MULTILIB_WRAPPED_HEADERS+=( /usr/include/mysql/mysql_version.h
	/usr/include/mariadb/mariadb_version.h
	/usr/include/mysql/private/probes_mysql_nodtrace.h
	/usr/include/mysql/private/probes_mysql_dtrace.h )

pkg_setup() {
	java-pkg-opt-2_pkg_setup
	mysql-multilib-r1_pkg_setup
}

pkg_preinst() {
	java-pkg-opt-2_pkg_preinst

	# Here we need to see if the implementation switched client libraries
	# We check if this is a new instance of the package and a client library already exists
	local SHOW_ABI_MESSAGE libpath
	if [[ -z ${REPLACING_VERSIONS} && -e "${EROOT}usr/$(get_libdir)/libmysqlclient.so" ]] ; then
		libpath=$(readlink "${EROOT}usr/$(get_libdir)/libmysqlclient.so")
		elog "Due to ABI changes when switching between different client libraries,"
		elog "revdep-rebuild must find and rebuild all packages linking to libmysqlclient."
		elog "Please run: revdep-rebuild --library ${libpath}"
		ewarn "Failure to run revdep-rebuild may cause issues with other programs or libraries"
	fi
}

pkg_postinst() {
	mysql-multilib-r1_pkg_postinst

	# Note about configuration change
	einfo
	elog "This version of mariadb reorganizes the configuration from a single my.cnf"
	elog "to several files in /etc/mysql/${PN}.d."
	elog "Please backup any changes you made to /etc/mysql/my.cnf"
	elog "and add them as a new file under /etc/mysql/${PN}.d with a .cnf extension."
	elog "You may have as many files as needed and they are read alphabetically."
	elog "Be sure the options have the appropitate section headers, i.e. [mysqld]."
	einfo
}

src_prepare() {
	java-pkg-opt-2_src_prepare
	if use tcmalloc; then
		echo "TARGET_LINK_LIBRARIES(mysqld tcmalloc)" >> "${S}/sql/CMakeLists.txt"
	fi

	# Don't build bundled xz-utils for tokudb
	echo > "${S}/storage/tokudb/PerconaFT/cmake_modules/TokuThirdParty.cmake" || die
	sed -i -e 's/ build_lzma//' -e 's/ build_snappy//' "${S}/storage/tokudb/PerconaFT/ft/CMakeLists.txt" || die
	sed -i -e 's/add_dependencies\(tokuportability_static_conv build_jemalloc\)//' "${S}/storage/tokudb/PerconaFT/portability/CMakeLists.txt" || die

	# Remove the bundled groonga
	# There is no CMake flag, it simply checks for existance
	rm -r "${S}"/storage/mroonga/vendor/groonga || die "could not remove packaged groonga"

	eapply "${PATCHES[@]}"
	eapply_user
}

src_configure(){
	# bug 508724 mariadb cannot use ld.gold
	tc-ld-disable-gold

	local MYSQL_CMAKE_NATIVE_DEFINES=(
			-DWITH_JEMALLOC=$(usex jemalloc system)
			-DWITH_PCRE=system
	)
	local MYSQL_CMAKE_EXTRA_DEFINES=(
			-DPLUGIN_AUTH_GSSAPI=$(usex kerberos DYNAMIC NO)
			-DAUTH_GSSAPI_PLUGIN_TYPE="$(usex kerberos DYNAMIC OFF)"
			-DCONC_WITH_EXTERNAL_ZLIB=YES
			-DWITH_EXTERNAL_ZLIB=YES
			-DSUFFIX_INSTALL_DIR=""
			-DINSTALL_INCLUDEDIR=include/mysql
			-DINSTALL_INFODIR=share/info
			-DINSTALL_LIBDIR=$(get_libdir)
			-DINSTALL_ELIBDIR=$(get_libdir)/mariadb
			-DINSTALL_MANDIR=share/man
			-DINSTALL_MYSQLSHAREDIR=share/mariadb
			-DINSTALL_PLUGINDIR=$(get_libdir)/mariadb/plugin
			-DINSTALL_SCRIPTDIR=share/mariadb/scripts
			-DINSTALL_SUPPORTFILESDIR="${EPREFIX}/usr/share/mariadb"
			-DWITH_UNITTEST=OFF
	)

	if use test ; then
		MYSQL_CMAKE_EXTRA_DEFINES+=( -DINSTALL_MYSQLTESTDIR=share/mariadb/mysql-test )
	fi

	if use server ; then
		# Federated{,X} must be treated special otherwise they will not be built as plugins
		if ! use extraengine ; then
			MYSQL_CMAKE_NATIVE_DEFINES+=(
				-DPLUGIN_FEDERATED=NO
				-DPLUGIN_FEDERATEDX=NO )
		fi

		MYSQL_CMAKE_NATIVE_DEFINES+=(
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
			-DWITH_WSREP=$(usex galera)
			-DWITH_INNODB_LZ4=$(usex innodb-lz4 ON OFF)
			-DWITH_INNODB_LZO=$(usex innodb-lzo ON OFF)
			-DWITH_INNODB_SNAPPY=$(usex innodb-snappy ON OFF)
			-DPLUGIN_MROONGA=$(usex mroonga DYNAMIC NO)
			-DPLUGIN_AUTH_GSSAPI=$(usex kerberos DYNAMIC NO)
			-DWITH_MARIABACKUP=$(usex backup ON OFF)
			-DWITH_LIBARCHIVE=$(usex backup ON OFF)
			-DINSTALL_SQLBENCHDIR=share/mariadb
			-DPLUGIN_ROCKSDB=$(usex rocksdb DYNAMIC NO)
		)
		if use test ; then
			# This is needed for the new client lib which tests a real, open server
			MYSQL_CMAKE_NATIVE_DEFINES+=( -DSKIP_TESTS=ON )
		fi
	fi
	mysql-multilib-r1_src_configure
}

src_install() {
	# wrap the config scripts
	local MULTILIB_CHOST_TOOLS=( /usr/bin/mariadb_config /usr/bin/mysql_config )
	multilib-minimal_src_install
}

# Intentionally override eclass function
multilib_src_install() {
	cmake-utils_src_install

	# Make sure the vars are correctly initialized
	mysql_init_vars

	# Remove an unnecessary, private config header which will never match between ABIs and is not meant to be used
	if [[ -f "${D}${MY_INCLUDEDIR}/private/config.h" ]] ; then
		rm "${D}${MY_INCLUDEDIR}/private/config.h" || die
	fi

	if ! multilib_is_native_abi && use server ; then
		insinto /usr/include/mysql/private
		doins "${S}"/sql/*.h
	fi

	# Install compatible symlinks to libmysqlclient
	use static-libs && dosym libmariadbclient.a "${EPREFIX}/usr/$(get_libdir)/libmysqlclient.a"
	dosym libmariadb.so.3 "${EPREFIX}/usr/$(get_libdir)/libmysqlclient.so"
	dosym libmariadb.so.3 "${EPREFIX}/usr/$(get_libdir)/libmysqlclient.so.${SUBSLOT}"

	# Kill old libmysqclient_r symlinks if they exist.  Time to fix what depends on them.
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
	[[ -f "${S}/scripts/mysqlaccess.conf" ]] && doins "${S}"/scripts/mysqlaccess.conf
	insinto "${MY_SYSCONFDIR#${EPREFIX}}"
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
		einfo "Creating initial directories"
		# Empty directories ...
		diropts "-m0750"
		if [[ "${PREVIOUS_DATADIR}" != "yes" ]] ; then
			dodir "${MY_DATADIR#${EPREFIX}}"
			keepdir "${MY_DATADIR#${EPREFIX}}"
			chown -R mysql:mysql "${D}/${MY_DATADIR}"
		fi

		diropts "-m0755"
		local folder
		for folder in "${MY_LOGDIR#${EPREFIX}}" ; do
			dodir "${folder}"
			keepdir "${folder}"
			chown -R mysql:mysql "${ED}/${folder}"
		done

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

	# These are failing in MariaDB 10.0 for now and are believed to be
	# false positives:
	#
	# main.mysql_client_test, main.mysql_client_test_nonblock
	# main.mysql_client_test_comp:
	# segfaults at random under Portage only, suspect resource limits.

	local t
	for t in plugins.cracklib_password_check plugins.two_password_validations ; do
		mysql-multilib-r1_disable_test  "$t" "False positive due to varying policies"
	done

	for t in main.mysql_client_test main.mysql_client_test_nonblock \
		main.mysql_client_test_comp ; do
			mysql-multilib-r1_disable_test  "$t" "False positives in Gentoo"
	done

	# run mysql-test tests
	perl mysql-test-run.pl --force --vardir="${T}/var-tests" --reorder
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
