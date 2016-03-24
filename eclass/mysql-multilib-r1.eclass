# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: mysql-multilib.eclass
# @MAINTAINER:
# Maintainers:
#	- MySQL Team <mysql-bugs@gentoo.org>
#	- Robin H. Johnson <robbat2@gentoo.org>
#	- Jorge Manuel B. S. Vicetto <jmbsvicetto@gentoo.org>
#	- Brian Evans <grknight@gentoo.org>
# @BLURB: This eclass provides common functions for mysql ebuilds
# @DESCRIPTION:
# The mysql-multilib-r1.eclass is the base eclass to build the mysql and
# alternative projects (mariadb and percona) ebuilds.
# Provider and version specific settings will be included in each ebuild.
# It provides the src_unpack, src_prepare, src_configure, src_compile,
# src_install, pkg_preinst, pkg_postinst, pkg_config and pkg_postrm
# phase hooks.

MYSQL_EXTRAS=""

# @ECLASS-VARIABLE: MYSQL_EXTRAS_VER
# @DESCRIPTION:
# The version of the MYSQL_EXTRAS repo to use to build mysql
# Use "none" to disable it's use
[[ ${MY_EXTRAS_VER} == "live" ]] && MYSQL_EXTRAS="git-r3"

# @ECLASS-VARIABLE: MYSQL_CMAKE_NATIVE_DEFINES
# @DESCRIPTION:
# An array of extra CMake arguments for native multilib builds

# @ECLASS-VARIABLE: MYSQL_CMAKE_NONNATIVE_DEFINES
# @DESCRIPTION:
# An array of extra CMake arguments for non-native multilib builds

# @ECLASS-VARIABLE: MYSQL_CMAKE_EXTRA_DEFINES
# @DESCRIPTION:
# An array of CMake arguments added to native and non-native

# Keeping eutils in EAPI=6 for emktemp in pkg_config

inherit eutils systemd flag-o-matic ${MYSQL_EXTRAS} versionator \
	prefix toolchain-funcs user cmake-utils multilib-minimal

if [[ "${EAPI}x" == "5x" ]]; then
	inherit multilib mysql_fx
fi

#
# Supported EAPI versions and export functions
#

case "${EAPI:-0}" in
	5|6) ;;
	*) die "Unsupported EAPI: ${EAPI}" ;;
esac

EXPORT_FUNCTIONS pkg_pretend pkg_setup src_unpack src_prepare src_configure src_compile src_install pkg_preinst pkg_postinst pkg_config

#
# VARIABLES:
#

# Shorten the path because the socket path length must be shorter than 107 chars
# and we will run a mysql server during test phase
S="${WORKDIR}/mysql"

[[ ${MY_EXTRAS_VER} == "latest" ]] && MY_EXTRAS_VER="20090228-0714Z"
if [[ ${MY_EXTRAS_VER} == "live" ]]; then
	EGIT_REPO_URI="git://anongit.gentoo.org/proj/mysql-extras.git"
	EGIT_CHECKOUT_DIR=${WORKDIR}/mysql-extras
	EGIT_CLONE_TYPE=shallow
fi

# @ECLASS-VARIABLE: MYSQL_PV_MAJOR
# @DESCRIPTION:
# Upstream MySQL considers the first two parts of the version number to be the
# major version. Upgrades that change major version should always run
# mysql_upgrade.
if [[ -z ${MYSQL_PV_MAJOR} ]] ; then MYSQL_PV_MAJOR="$(get_version_component_range 1-2 ${PV})" ; fi

# @ECLASS-VARIABLE: MYSQL_VERSION_ID
# @DESCRIPTION:
# MYSQL_VERSION_ID will be:
# major * 10e6 + minor * 10e4 + micro * 10e2 + gentoo revision number, all [0..99]
# This is an important part, because many of the choices the MySQL ebuild will do
# depend on this variable.
# In particular, the code below transforms a $PVR like "5.0.18-r3" in "5001803"
# We also strip off upstream's trailing letter that they use to respin tarballs
if [[ "${EAPI}x" == "5x" ]]; then
	MYSQL_VERSION_ID=""
	tpv="${PV%[a-z]}"
	tpv=( ${tpv//[-._]/ } ) ; tpv[3]="${PVR:${#PV}}" ; tpv[3]="${tpv[3]##*-r}"
	for vatom in 0 1 2 3 ; do
		# pad to length 2
		tpv[${vatom}]="00${tpv[${vatom}]}"
		MYSQL_VERSION_ID="${MYSQL_VERSION_ID}${tpv[${vatom}]:0-2}"
	done
	# strip leading "0" (otherwise it's considered an octal number by BASH)
	MYSQL_VERSION_ID=${MYSQL_VERSION_ID##"0"}
fi

# Work out the default SERVER_URI correctly
if [[ -z ${SERVER_URI} ]]; then
	if [[ ${PN} == "mariadb" ]]; then
		# Beginning with 5.5, MariaDB stopped putting beta, alpha or rc on their tarball names
		MARIA_FULL_PV=$(get_version_component_range 1-3)
		MARIA_FULL_P="${PN}-${MARIA_FULL_PV}"
		SERVER_URI="https://downloads.mariadb.org/interstitial/${MARIA_FULL_P}/source/${MARIA_FULL_P}.tar.gz"
	elif [[ ${PN} == "percona-server" ]]; then
		PERCONA_PN="Percona-Server"
		MIRROR_PV=$(get_version_component_range 1-2 ${PV})
		MY_PV=$(get_version_component_range 1-3 ${PV})
		PERCONA_RELEASE=$(get_version_component_range 4-5 ${PV})
		PERCONA_RC=$(get_version_component_range 6 ${PV})
		SERVER_URI="http://www.percona.com/redir/downloads/${PERCONA_PN}-${MIRROR_PV}/${PERCONA_PN}-${MY_PV}-${PERCONA_RC}${PERCONA_RELEASE}/source/tarball/${PN}-${MY_PV}-${PERCONA_RC}${PERCONA_RELEASE}.tar.gz"
	else
		if [[ "${PN}" == "mysql-cluster" ]] ; then
			URI_DIR="MySQL-Cluster"
			URI_FILE="mysql-cluster-gpl"
		else
			URI_DIR="MySQL"
			URI_FILE="mysql"
		fi
		[[ -z ${MY_PV} ]] && MY_PV="${PV//_/-}"
		URI_A="${URI_FILE}-${MY_PV}.tar.gz"
		MIRROR_PV=$(get_version_component_range 1-2 ${PV})
		# Recently upstream switched to an archive site, and not on mirrors
		SERVER_URI="http://cdn.mysql.com/Downloads/${URI_DIR}-${MIRROR_PV}/${URI_A}
			http://downloads.mysql.com/archives/${URI_DIR}-${MIRROR_PV}/${URI_A}"
	fi
fi

# Define correct SRC_URIs
SRC_URI="${SERVER_URI}"

# Gentoo patches to MySQL
if [[ ${MY_EXTRAS_VER} != "live" && ${MY_EXTRAS_VER} != "none" ]]; then
	SRC_URI="${SRC_URI}
		mirror://gentoo/mysql-extras-${MY_EXTRAS_VER}.tar.bz2
		https://gitweb.gentoo.org/proj/mysql-extras.git/snapshot/mysql-extras-${MY_EXTRAS_VER}.tar.bz2
		https://dev.gentoo.org/~grknight/distfiles/mysql-extras-${MY_EXTRAS_VER}.tar.bz2
		https://dev.gentoo.org/~robbat2/distfiles/mysql-extras-${MY_EXTRAS_VER}.tar.bz2
		https://dev.gentoo.org/~jmbsvicetto/distfiles/mysql-extras-${MY_EXTRAS_VER}.tar.bz2"
fi

DESCRIPTION="A fast, multi-threaded, multi-user SQL database server"
HOMEPAGE="http://www.mysql.com/"
LICENSE="GPL-2"
SLOT="0/${SUBSLOT:-0}"

IUSE="debug embedded extraengine jemalloc latin1 libressl +openssl
	+perl profiling selinux +server systemtap static static-libs tcmalloc test yassl"

REQUIRED_USE="^^ ( yassl openssl libressl )"

# Tests always fail when libressl is enabled due to hard-coded ciphers in the tests
RESTRICT="libressl? ( test )"

REQUIRED_USE="${REQUIRED_USE} !server? ( !extraengine !embedded )
	 ?? ( tcmalloc jemalloc )
	 static? ( !libressl !openssl yassl )"

#
# DEPENDENCIES:
#

# Be warned, *DEPEND are version-dependant
# These are used for both runtime and compiletime
# MULTILIB_USEDEP only set for libraries used by the client library
DEPEND="
	kernel_linux? (
		sys-process/procps:0=
		dev-libs/libaio:0=
	)
	>=sys-apps/sed-4
	>=sys-apps/texinfo-4.7-r1
	!dev-db/mariadb-native-client[mysqlcompat]
	jemalloc? ( dev-libs/jemalloc:0= )
	tcmalloc? ( dev-util/google-perftools:0= )
	systemtap? ( >=dev-util/systemtap-1.3:0= )
	openssl? ( >=dev-libs/openssl-1.0.0:0=[${MULTILIB_USEDEP},static-libs?] )
	libressl? ( dev-libs/libressl:0=[${MULTILIB_USEDEP},static-libs?] )
	>=sys-libs/zlib-1.2.3:0=[${MULTILIB_USEDEP},static-libs?]
	sys-libs/ncurses:0=
"

# prefix: first need to implement something for #196294
RDEPEND="${DEPEND}
	selinux? ( sec-policy/selinux-mysql )
	abi_x86_32? ( !app-emulation/emul-linux-x86-db[-abi_x86_32(-)] )
"

# Having different flavours at the same time is not a good idea
for i in "mysql" "mariadb" "mariadb-galera" "percona-server" "mysql-cluster" ; do
	[[ ${i} == ${PN} ]] ||
	RDEPEND="${RDEPEND} !dev-db/${i}"
done

RDEPEND="${RDEPEND}
	server? ( !prefix? ( dev-db/mysql-init-scripts ) )
	!<virtual/mysql-5.6-r4"

# compile-time-only
# ncurses only needs multilib for compile time due to a binary that will be not installed
DEPEND="${DEPEND}
	virtual/yacc
	static? ( sys-libs/ncurses[static-libs] )
"

# For other stuff to bring us in
# dev-perl/DBD-mysql is needed by some scripts installed by MySQL
PDEPEND="${PDEPEND} perl? ( >=dev-perl/DBD-mysql-2.9004 )
	 ~virtual/mysql-${MYSQL_PV_MAJOR}[embedded=,static=]
	 virtual/libmysqlclient:${SLOT}[${MULTILIB_USEDEP},static-libs=]"

# my_config.h includes ABI specific data
MULTILIB_WRAPPED_HEADERS=( /usr/include/mysql/my_config.h /usr/include/mysql/private/embedded_priv.h )

#
# EBUILD FUNCTIONS
#

# @FUNCTION: mysql-multilib-r1_pkg_pretend
# @DESCRIPTION:
# Perform some basic tests and tasks during pkg_pretend phase:
mysql-multilib-r1_pkg_pretend() {
	if [[ ${MERGE_TYPE} != binary ]] ; then
		local GCC_MAJOR_SET=$(gcc-major-version)
		local GCC_MINOR_SET=$(gcc-minor-version)
		if in_iuse tokudb && use tokudb && [[ ${GCC_MAJOR_SET} -lt 4 || \
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
	fi
}

# @FUNCTION: mysql-multilib-r1_pkg_setup
# @DESCRIPTION:
# Perform some basic tests and tasks during pkg_setup phase:
#   die if FEATURES="test", USE="server" and not using FEATURES="userpriv"
#   create new user and group for mysql
#   warn about deprecated features
mysql-multilib-r1_pkg_setup() {

	if has test ${FEATURES} && \
		use server && ! has userpriv ${FEATURES} ; then
			eerror "Testing with FEATURES=-userpriv is no longer supported by upstream. Tests MUST be run as non-root."
	fi

	# This should come after all of the die statements
	enewgroup mysql 60 || die "problem adding 'mysql' group"
	enewuser mysql 60 -1 /dev/null mysql || die "problem adding 'mysql' user"
}

# @FUNCTION: mysql-multilib-r1_src_unpack
# @DESCRIPTION:
# Unpack the source code
mysql-multilib-r1_src_unpack() {

	# Initialize the proper variables first
	mysql_init_vars

	unpack ${A}
	# Grab the patches
	[[ "${MY_EXTRAS_VER}" == "live" ]] && S="${WORKDIR}/mysql-extras" git-r3_src_unpack

	mv -f "${WORKDIR}/${MY_SOURCEDIR}" "${S}"
}

# @FUNCTION: mysql-multilib-r1_src_prepare
# @DESCRIPTION:
# Apply patches to the source code and remove unneeded bundled libs.
mysql-multilib-r1_src_prepare() {

	debug-print-function ${FUNCNAME} "$@"

	cd "${S}"

	if [[ ${MY_EXTRAS_VER} != none ]]; then

		# Apply the patches for this MySQL version
		if [[ "${EAPI}x" == "5x" ]]; then
			EPATCH_SUFFIX="patch"
			mkdir -p "${EPATCH_SOURCE}" || die "Unable to create epatch directory"
			# Clean out old items
			rm -f "${EPATCH_SOURCE}"/*
			# Now link in right patches
			mysql_mv_patches
			# And apply
			epatch
		fi
	fi

	# last -fPIC fixup, per bug #305873
	i="${S}"/storage/innodb_plugin/plug.in
	if [[ -f ${i} ]] ; then sed -i -e '/CFLAGS/s,-prefer-non-pic,,g' "${i}" || die ; fi

	rm -f "scripts/mysqlbug"
	if use jemalloc && [[ ${PN} != "mariadb" ]] ; then
		echo "TARGET_LINK_LIBRARIES(mysqld jemalloc)" >> "${S}/sql/CMakeLists.txt" || die
	fi

	if use tcmalloc; then
		echo "TARGET_LINK_LIBRARIES(mysqld tcmalloc)" >> "${S}/sql/CMakeLists.txt"
	fi

	if in_iuse tokudb ; then
		# Don't build bundled xz-utils
		if [[ -d "${S}/storage/tokudb/ft-index" ]] ; then
			rm -f "${S}/storage/tokudb/ft-index/cmake_modules/TokuThirdParty.cmake" || die
			touch "${S}/storage/tokudb/ft-index/cmake_modules/TokuThirdParty.cmake" || die
			sed -i 's/ build_lzma//' "${S}/storage/tokudb/ft-index/ft/CMakeLists.txt" || die
		elif [[ -d "${S}/storage/tokudb/PerconaFT" ]] ; then
			rm "${S}/storage/tokudb/PerconaFT/cmake_modules/TokuThirdParty.cmake" || die
			touch "${S}/storage/tokudb/PerconaFT/cmake_modules/TokuThirdParty.cmake" || die
			sed -i -e 's/ build_lzma//' -e 's/ build_snappy//' "${S}/storage/tokudb/PerconaFT/ft/CMakeLists.txt" || die
			sed -i -e 's/add_dependencies\(tokuportability_static_conv build_jemalloc\)//' "${S}/storage/tokudb/PerconaFT/portability/CMakeLists.txt" || die
		fi

		if [[ -d "${S}/plugin/tokudb-backup-plugin" ]] && ! use tokudb-backup-plugin ; then
			 rm -r "${S}/plugin/tokudb-backup-plugin/Percona-TokuBackup" || die
		fi
	fi

	# Remove the bundled groonga if it exists
	# There is no CMake flag, it simply checks for existance
	if [[ -d "${S}"/storage/mroonga/vendor/groonga ]] ; then
		rm -r "${S}"/storage/mroonga/vendor/groonga || die "could not remove packaged groonga"
	fi

	if [[ "${EAPI}x" == "5x" ]] ; then
		epatch_user
	else
		default
	fi
}

# @FUNCTION: mysql-multilib-r1_src_configure
# @DESCRIPTION:
# Configure mysql to build the code for Gentoo respecting the use flags.
mysql-multilib-r1_src_configure() {
	# Bug #114895, bug #110149
	filter-flags "-O" "-O[01]"

	append-cxxflags -felide-constructors

	# bug #283926, with GCC4.4, this is required to get correct behavior.
	append-flags -fno-strict-aliasing

	multilib-minimal_src_configure
}

multilib_src_configure() {
	debug-print-function ${FUNCNAME} "$@"

	CMAKE_BUILD_TYPE="RelWithDebInfo"

	# debug hack wrt #497532
	mycmakeargs=(
		-DCMAKE_C_FLAGS_RELWITHDEBINFO="$(usex debug '' '-DNDEBUG')"
		-DCMAKE_CXX_FLAGS_RELWITHDEBINFO="$(usex debug '' '-DNDEBUG')"
		-DCMAKE_INSTALL_PREFIX=${EPREFIX}/usr
		-DMYSQL_DATADIR=${EPREFIX}/var/lib/mysql
		-DSYSCONFDIR=${EPREFIX}/etc/mysql
		-DINSTALL_BINDIR=bin
		-DINSTALL_DOCDIR=share/doc/${PF}
		-DINSTALL_DOCREADMEDIR=share/doc/${PF}
		-DINSTALL_INCLUDEDIR=include/mysql
		-DINSTALL_INFODIR=share/info
		-DINSTALL_LIBDIR=$(get_libdir)
		-DINSTALL_ELIBDIR=$(get_libdir)/mysql
		-DINSTALL_MANDIR=share/man
		-DINSTALL_MYSQLDATADIR=${EPREFIX}/var/lib/mysql
		-DINSTALL_MYSQLSHAREDIR=share/mysql
		-DINSTALL_MYSQLTESTDIR=share/mysql/mysql-test
		-DINSTALL_PLUGINDIR=$(get_libdir)/mysql/plugin
		-DINSTALL_SBINDIR=sbin
		-DINSTALL_SCRIPTDIR=share/mysql/scripts
		-DINSTALL_SQLBENCHDIR=share/mysql
		-DINSTALL_SUPPORTFILESDIR=${EPREFIX}/usr/share/mysql
		-DWITH_COMMENT="Gentoo Linux ${PF}"
		-DWITH_UNIT_TESTS=$(usex test)
		-DWITH_LIBEDIT=0
		-DWITH_ZLIB=system
		-DWITHOUT_LIBWRAP=1
		-DENABLED_LOCAL_INFILE=1
		-DMYSQL_UNIX_ADDR=${EPREFIX}/var/run/mysqld/mysqld.sock
		-DINSTALL_UNIX_ADDRDIR=${EPREFIX}/var/run/mysqld/mysqld.sock
		-DWITH_DEFAULT_COMPILER_OPTIONS=0
		-DWITH_DEFAULT_FEATURE_SET=0
		-DINSTALL_SYSTEMD_UNITDIR="$(systemd_get_systemunitdir)"
		-DENABLE_STATIC_LIBS=$(usex static-libs)
	)

	if in_iuse systemd ; then
		mycmakeargs+=( -DWITH_SYSTEMD=$(usex systemd) )
	fi

	if use openssl || use libressl ; then
		mycmakeargs+=( -DWITH_SSL=system )
	else
		mycmakeargs+=( -DWITH_SSL=bundled )
	fi

	if ! multilib_is_native_abi ; then
		mycmakeargs+=( -DWITHOUT_TOOLS=1 )
	fi

	if in_iuse bindist ; then
		# bfd.h is only used starting with 10.1 and can be controlled by NOT_FOR_DISTRIBUTION
		if multilib_is_native_abi; then
			mycmakeargs+=(
				-DWITH_READLINE=$(usex bindist 1 0)
				-DNOT_FOR_DISTRIBUTION=$(usex bindist 0 1)
			)
		else
			mycmakeargs+=(
				-DWITH_READLINE=1
				-DNOT_FOR_DISTRIBUTION=0
			)
		fi
	fi

	### TODO: make this system but issues with UTF-8 prevent it
	mycmakeargs+=( -DWITH_EDITLINE=bundled )

	if multilib_is_native_abi && use server ; then
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
			-DMYSQL_UNIX_ADDR=${EPREFIX}/var/run/mysqld/mysqld.sock
			-DDISABLE_SHARED=$(usex static YES NO)
			-DWITH_DEBUG=$(usex debug)
			-DWITH_EMBEDDED_SERVER=$(usex embedded)
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

		mycmakeargs+=( -DWITH_FEDERATED_STORAGE_ENGINE=$(usex extraengine) )
	else
		mycmakeargs+=(
			-DWITHOUT_SERVER=1
			-DWITHOUT_EMBEDDED_SERVER=1
			-DEXTRA_CHARSETS=none
			-DINSTALL_SQLBENCHDIR=
		)
	fi

	# systemtap only works on native ABI  bug 530132
	if multilib_is_native_abi; then
		mycmakeargs+=( -DENABLE_DTRACE=$(usex systemtap)
			"${MYSQL_CMAKE_NATIVE_DEFINES[@]}" )
	else
		mycmakeargs+=( -DENABLE_DTRACE=0
			"${MYSQL_CMAKE_NONNATIVE_DEFINES[@]}" )
	fi

	mycmakeargs+=( "${MYSQL_CMAKE_EXTRA_DEFINES[@]}" )

	cmake-utils_src_configure
}

mysql-multilib-r1_src_compile() {
	local _cmake_args=( "${@}" )

	multilib-minimal_src_compile
}

multilib_src_compile() {

	cmake-utils_src_compile "${_cmake_args[@]}"
}


# @FUNCTION: mysql-multilib-r1_src_install
# @DESCRIPTION:
# Install mysql.
mysql-multilib-r1_src_install() {
	# wrap the config script
	MULTILIB_CHOST_TOOLS=( /usr/bin/mysql_config )

	multilib-minimal_src_install
}

multilib_src_install() {
	debug-print-function ${FUNCNAME} "$@"

	if multilib_is_native_abi; then
		# Make sure the vars are correctly initialized
		mysql_init_vars

		cmake-utils_src_install

		# Convenience links
		einfo "Making Convenience links for mysqlcheck multi-call binary"
		dosym "/usr/bin/mysqlcheck" "/usr/bin/mysqlanalyze"
		dosym "/usr/bin/mysqlcheck" "/usr/bin/mysqlrepair"
		dosym "/usr/bin/mysqlcheck" "/usr/bin/mysqloptimize"

		# INSTALL_LAYOUT=STANDALONE causes cmake to create a /usr/data dir
		if [[ -d "${ED}/usr/data" ]] ; then
			rm -Rf "${ED}/usr/data" || die
		fi

		# Unless they explicitly specific USE=test, then do not install the
		# testsuite. It DOES have a use to be installed, esp. when you want to do a
		# validation of your database configuration after tuning it.
		if ! use test ; then
			rm -rf "${D}"/${MY_SHAREDSTATEDIR}/mysql-test
		fi

		# Configuration stuff
		case ${MYSQL_PV_MAJOR} in
			5.5) mysql_mycnf_version="5.5" ;;
			5.[6-9]|6*|7*|8*|9*|10*) mysql_mycnf_version="5.6" ;;
		esac
		einfo "Building default my.cnf (${mysql_mycnf_version})"
		insinto "${MY_SYSCONFDIR#${EPREFIX}}"
		[[ -f "${S}/scripts/mysqlaccess.conf" ]] && doins "${S}"/scripts/mysqlaccess.conf
		mycnf_src="my.cnf-${mysql_mycnf_version}"
		sed -e "s!@DATADIR@!${MY_DATADIR}!g" \
			"${FILESDIR}/${mycnf_src}" \
			> "${TMPDIR}/my.cnf.ok" || die
		use prefix && sed -i -r -e '/^user[[:space:]]*=[[:space:]]*mysql$/d' "${TMPDIR}/my.cnf.ok"
		if use latin1 ; then
			sed -i \
				-e "/character-set/s|utf8|latin1|g" \
				"${TMPDIR}/my.cnf.ok" || die
		fi
		eprefixify "${TMPDIR}/my.cnf.ok"
		newins "${TMPDIR}/my.cnf.ok" my.cnf

		if use server ; then
			einfo "Creating initial directories"
			# Empty directories ...
			diropts "-m0750"
			if [[ ${PREVIOUS_DATADIR} != "yes" ]] ; then
				dodir "${MY_DATADIR#${EPREFIX}}"
				keepdir "${MY_DATADIR#${EPREFIX}}"
				chown -R mysql:mysql "${D}/${MY_DATADIR}"
			fi

			diropts "-m0755"
			for folder in "${MY_LOGDIR#${EPREFIX}}" ; do
				dodir "${folder}"
				keepdir "${folder}"
				chown -R mysql:mysql "${ED}/${folder}"
			done

			einfo "Including support files and sample configurations"
			docinto "support-files"
			for script in \
				"${S}"/support-files/my-*.cnf.sh \
				"${S}"/support-files/magic \
				"${S}"/support-files/ndb-config-2-node.ini.sh
			do
				[[ -f $script ]] && dodoc "${script}"
			done

			docinto "scripts"
			for script in "${S}"/scripts/mysql* ; do
				[[ ( -f $script ) && ( ${script%.sh} == ${script} ) ]] && dodoc "${script}"
			done
		fi

		#Remove mytop if perl is not selected
		[[ -e "${ED}/usr/bin/mytop" ]] && ! use perl && rm -f "${ED}/usr/bin/mytop"

		# Percona has decided to rename libmysqlclient to libperconaserverclient
		# Use a symlink to preserve linkages for those who don't use mysql_config
		local suffix
		for suffix in ".so" "_r.so" ".a" "_r.a" ; do
			if [[ -e "${ED}/usr/$(get_libdir)/libperconaserverclient${suffix}" ]] ; then
				dosym libperconaserverclient${suffix} /usr/$(get_libdir)/libmysqlclient${suffix}
			fi
		done
	else
		cmake-utils_src_install
		if [[ "${PN}" == "mariadb" ]] && use server ; then
			insinto /usr/include/mysql/private
			doins "${S}"/sql/*.h
		fi
	fi
}

# @FUNCTION: mysql-multilib-r1_pkg_preinst
# @DESCRIPTION:
# Warn about ABI changes when switching providers
mysql-multilib-r1_pkg_preinst() {
	debug-print-function ${FUNCNAME} "$@"

	# Here we need to see if the implementation switched client libraries
	# We check if this is a new instance of the package and a client library already exists
	local SHOW_ABI_MESSAGE
        if [[ -z ${REPLACING_VERSIONS} && -e "${EROOT}usr/$(get_libdir)/libmysqlclient.so" ]] ; then
                elog "Due to ABI changes when switching between different client libraries,"
                elog "revdep-rebuild must find and rebuild all packages linking to libmysqlclient."
                elog "Please run: revdep-rebuild --library libmysqlclient.so.${SUBSLOT:-18}"
                ewarn "Failure to run revdep-rebuild may cause issues with other programs or libraries"
        fi
}

# @FUNCTION: mysql-multilib-r1_pkg_postinst
# @DESCRIPTION:
# Run post-installation tasks:
#   create the dir for logfiles if non-existant
#   touch the logfiles and secure them
#   install scripts
#   issue required steps for optional features
#   issue deprecation warnings
mysql-multilib-r1_pkg_postinst() {
	debug-print-function ${FUNCNAME} "$@"

	# Make sure the vars are correctly initialized
	mysql_init_vars

	# Check FEATURES="collision-protect" before removing this
	[[ -d "${ROOT}${MY_LOGDIR}" ]] || install -d -m0750 -o mysql -g mysql "${ROOT}${MY_LOGDIR}"

	# Secure the logfiles
	touch "${ROOT}${MY_LOGDIR}"/mysql.{log,err}
	chown mysql:mysql "${ROOT}${MY_LOGDIR}"/mysql*
	chmod 0660 "${ROOT}${MY_LOGDIR}"/mysql*

	# Minimal builds don't have the MySQL server
	if use server ; then
		docinto "support-files"
		for script in \
			support-files/my-*.cnf \
			support-files/magic \
			support-files/ndb-config-2-node.ini
		do
			[[ -f "${script}" ]] \
			&& dodoc "${script}"
		done

		docinto "scripts"
		for script in scripts/mysql* ; do
			if [[ -f "${script}" && "${script%.sh}" == "${script}" ]]; then
				dodoc "${script}"
			fi
		done

		if in_iuse pam && use pam; then
			einfo
			elog "This install includes the PAM authentication plugin."
			elog "To activate and configure the PAM plugin, please read:"
			if [[ ${PN} == "mariadb" ]] ; then
				elog "https://mariadb.com/kb/en/mariadb/pam-authentication-plugin/"
			elif [[ ${PN} == "percona-server" ]] ; then
				elog "https://www.percona.com/doc/percona-server/5.6/management/pam_plugin.html"
			fi
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

		if in_iuse galera && use galera ; then
			einfo
			elog "Be sure to edit the my.cnf file to activate your cluster settings."
			elog "This should be done after running \"emerge --config =${CATEGORY}/${PF}\""
			elog "The first time the cluster is activated, you should add"
			elog "--wsrep-new-cluster to the options in /etc/conf.d/mysql for one node."
			elog "This option should then be removed for subsequent starts."
			einfo
		fi
	fi
}

# @FUNCTION: mysql-multilib-r1_getopt
# @DESCRIPTION:
# Use my_print_defaults to extract specific config options
mysql-multilib-r1_getopt() {
	local mypd="${EROOT}"/usr/bin/my_print_defaults
	section="$1"
	flag="--${2}="
	"${mypd}" $section | sed -n "/^${flag}/p"
}

# @FUNCTION: mysql-multilib-r1_getoptval
# @DESCRIPTION:
# Use my_print_defaults to extract specific config options
mysql-multilib-r1_getoptval() {
	local mypd="${EROOT}"/usr/bin/my_print_defaults
	local section="$1"
	local flag="--${2}="
	local extra_options="${3}"
	"${mypd}" $extra_options $section | sed -n "/^${flag}/s,${flag},,gp"
}

# @FUNCTION: mysql-multilib-r1_pkg_config
# @DESCRIPTION:
# Configure mysql environment.
mysql-multilib-r1_pkg_config() {

	debug-print-function ${FUNCNAME} "$@"

	local old_MY_DATADIR="${MY_DATADIR}"
	local old_HOME="${HOME}"
	# my_print_defaults needs to read stuff in $HOME/.my.cnf
	export HOME=${EPREFIX}/root

	# Make sure the vars are correctly initialized
	mysql_init_vars

	[[ -z "${MY_DATADIR}" ]] && die "Sorry, unable to find MY_DATADIR"
	if ! built_with_use ${CATEGORY}/${PN} server ; then
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
		MYSQL_ROOT_PASSWORD="$(mysql-multilib-r1_getoptval 'client mysql' password)"
		# Sometimes --show is required to display passwords in some implementations of my_print_defaults
		if [[ "${MYSQL_ROOT_PASSWORD}" == '*****' ]]; then
			MYSQL_ROOT_PASSWORD="$(mysql-multilib-r1_getoptval 'client mysql' password --show)"
		fi
	fi
	MYSQL_TMPDIR="$(mysql-multilib-r1_getoptval mysqld tmpdir)"
	# These are dir+prefix
	MYSQL_RELAY_LOG="$(mysql-multilib-r1_getoptval mysqld relay-log)"
	MYSQL_RELAY_LOG=${MYSQL_RELAY_LOG%/*}
	MYSQL_LOG_BIN="$(mysql-multilib-r1_getoptval mysqld log-bin)"
	MYSQL_LOG_BIN=${MYSQL_LOG_BIN%/*}

	if [[ ! -d "${ROOT}"/$MYSQL_TMPDIR ]]; then
		einfo "Creating MySQL tmpdir $MYSQL_TMPDIR"
		install -d -m 770 -o mysql -g mysql "${EROOT}"/$MYSQL_TMPDIR
	fi
	if [[ ! -d "${ROOT}"/$MYSQL_LOG_BIN ]]; then
		einfo "Creating MySQL log-bin directory $MYSQL_LOG_BIN"
		install -d -m 770 -o mysql -g mysql "${EROOT}"/$MYSQL_LOG_BIN
	fi
	if [[ ! -d "${EROOT}"/$MYSQL_RELAY_LOG ]]; then
		einfo "Creating MySQL relay-log directory $MYSQL_RELAY_LOG"
		install -d -m 770 -o mysql -g mysql "${EROOT}"/$MYSQL_RELAY_LOG
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

	local help_tables="${ROOT}${MY_SHAREDSTATEDIR}/fill_help_tables.sql"
	[[ -r "${help_tables}" ]] \
	&& cp "${help_tables}" "${TMPDIR}/fill_help_tables.sql" \
	|| touch "${TMPDIR}/fill_help_tables.sql"
	help_tables="${TMPDIR}/fill_help_tables.sql"

	# Figure out which options we need to disable to do the setup
	local helpfile="${TMPDIR}/mysqld-help"
	${EROOT}/usr/sbin/mysqld --verbose --help >"${helpfile}" 2>/dev/null
	for opt in grant-tables host-cache name-resolve networking slave-start \
		federated ssl log-bin relay-log slow-query-log external-locking \
		ndbcluster log-slave-updates \
		; do
		optexp="--(skip-)?${opt}" optfull="--loose-skip-${opt}"
		egrep -sq -- "${optexp}" "${helpfile}" && options="${options} ${optfull}"
	done
	# But some options changed names
	egrep -sq external-locking "${helpfile}" && \
	options="${options/skip-locking/skip-external-locking}"

	use prefix || options="${options} --user=mysql"

	einfo "Creating the mysql database and setting proper permissions on it ..."

	# Now that /var/run is a tmpfs mount point, we need to ensure it exists before using it
	PID_DIR="${EROOT}/var/run/mysqld"
	if [[ ! -d "${PID_DIR}" ]]; then
		mkdir -p "${PID_DIR}" || die "Could not create pid directory"
		chown mysql:mysql "${PID_DIR}" || die "Could not set ownership on pid directory"
		chmod 755 "${PID_DIR}" || die "Could not set permissions on pid directory"
	fi

	pushd "${TMPDIR}" &>/dev/null

	# Filling timezones, see
	# http://dev.mysql.com/doc/mysql/en/time-zone-support.html
	"${EROOT}/usr/bin/mysql_tzinfo_to_sql" "${EROOT}/usr/share/zoneinfo" > "${sqltmp}" 2>/dev/null

	local cmd
	local initialize_options
        if [[ ${PN} == "mysql" || ${PN} == "percona-server" ]] && mysql_version_is_at_least "5.7.6" ; then
		# --initialize-insecure will not set root password
		# --initialize would set a random one in the log which we don't need as we set it ourselves
		cmd="${EROOT}usr/sbin/mysqld"
		initialize_options="--initialize-insecure  '--init-file=${sqltmp}'"
		sqltmp="" # the initialize will take care of it
	else
		cmd="${EROOT}usr/share/mysql/scripts/mysql_install_db"
		[[ -f "${cmd}" ]] || cmd="${EROOT}usr/bin/mysql_install_db"
		if [[ -r "${help_tables}" ]] ; then
			cat "${help_tables}" >> "${sqltmp}"
		fi
	fi
	cmd="'$cmd' '--basedir=${EPREFIX}/usr' ${options} '--datadir=${ROOT}/${MY_DATADIR}' '--tmpdir=${ROOT}/${MYSQL_TMPDIR}' ${initialize_options}"
	einfo "Command: $cmd"
	eval $cmd \
		>"${TMPDIR}"/mysql_install_db.log 2>&1
	if [ $? -ne 0 ]; then
		grep -B5 -A999 -i "ERROR" "${TMPDIR}"/mysql_install_db.log 1>&2
		die "Failed to initialize mysqld. Please review ${EPREFIX}/var/log/mysql/mysqld.err AND ${TMPDIR}/mysql_install_db.log"
	fi
	popd &>/dev/null
	[[ -f "${ROOT}/${MY_DATADIR}/mysql/user.frm" ]] \
	|| die "MySQL databases not installed"
	chown -R mysql:mysql "${ROOT}/${MY_DATADIR}" 2>/dev/null
	chmod 0750 "${ROOT}/${MY_DATADIR}" 2>/dev/null

	local socket="${EROOT}/var/run/mysqld/mysqld${RANDOM}.sock"
	local pidfile="${EROOT}/var/run/mysqld/mysqld${RANDOM}.pid"
	local mysqld="${EROOT}/usr/sbin/mysqld \
		${options} \
		$(use prefix || echo --user=mysql) \
		--log-warnings=0 \
		--basedir=${EROOT}/usr \
		--datadir=${ROOT}/${MY_DATADIR} \
		--max_allowed_packet=8M \
		--net_buffer_length=16K \
		--default-storage-engine=MyISAM \
		--socket=${socket} \
		--pid-file=${pidfile}
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
		--socket=${socket} \
		-hlocalhost \
		-e "${sql}"
	eend $?

	if [[ -n "${sqltmp}" ]] ; then
		ebegin "Loading \"zoneinfo\", this step may require a few seconds"
		"${EROOT}/usr/bin/mysql" \
			--socket=${socket} \
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


#
# HELPER FUNCTIONS:
#

# @FUNCTION: mysql-multilib-r1_disable_test
# @DESCRIPTION:
# Helper function to disable specific tests.
mysql-multilib-r1_disable_test() {

	local rawtestname testname testsuite reason mysql_disabled_file mysql_disabled_dir
	rawtestname="${1}" ; shift
	reason="${@}"
	ewarn "test '${rawtestname}' disabled: '${reason}'"

	testsuite="${rawtestname/.*}"
	testname="${rawtestname/*.}"
	for mysql_disabled_file in \
		${S}/mysql-test/disabled.def \
		${S}/mysql-test/t/disabled.def ; do
		[[ -f ${mysql_disabled_file} ]] && break
	done
	#mysql_disabled_file="${S}/mysql-test/t/disabled.def"
	#einfo "rawtestname=${rawtestname} testname=${testname} testsuite=${testsuite}"
	echo ${testname} : ${reason} >> "${mysql_disabled_file}"

	if [[ ( -n ${testsuite} ) && ( ${testsuite} != "main" ) ]]; then
		for mysql_disabled_file in \
			${S}/mysql-test/suite/${testsuite}/disabled.def \
			${S}/mysql-test/suite/${testsuite}/t/disabled.def \
			FAILED ; do
			[[ -f ${mysql_disabled_file} ]] && break
		done
		if [[ ${mysql_disabled_file} != "FAILED" ]]; then
			echo "${testname} : ${reason}" >> "${mysql_disabled_file}"
		else
			for mysql_disabled_dir in \
				${S}/mysql-test/suite/${testsuite} \
				${S}/mysql-test/suite/${testsuite}/t \
				FAILED ; do
				[[ -d ${mysql_disabled_dir} ]] && break
			done
			if [[ ${mysql_disabled_dir} != "FAILED" ]]; then
				echo "${testname} : ${reason}" >> "${mysql_disabled_dir}/disabled.def"
			else
				ewarn "Could not find testsuite disabled.def location for ${rawtestname}"
			fi
		fi
	fi
}

# @FUNCTION: mysql-cmake_use_plugin
# @DESCRIPTION:
# Helper function to enable/disable plugins by use flags
# cmake-utils_use_with is not enough as some references check WITH_ (0|1)
# and some check WITHOUT_. Also, this can easily extend to non-storage plugins.
mysql-cmake_use_plugin() {
	[[ -z $2 ]] && die "mysql-cmake_use_plugin <USE flag> <flag name>"
	if in_iuse $1 && use $1 ; then
		echo "-DWITH_$2=1 -DPLUGIN_$2=YES"
	else
		echo "-DWITHOUT_$2=1 -DWITH_$2=0 -DPLUGIN_$2=NO"
	fi
}

# @FUNCTION: mysql_init_vars
# @DESCRIPTION:
# void mysql_init_vars()
# Initialize global variables
# 2005-11-19 <vivo@gentoo.org>
if [[ "${EAPI}x" != "5x" ]]; then

mysql_init_vars() {
	MY_SHAREDSTATEDIR=${MY_SHAREDSTATEDIR="${EPREFIX}/usr/share/mysql"}
	MY_SYSCONFDIR=${MY_SYSCONFDIR="${EPREFIX}/etc/mysql"}
	MY_LOCALSTATEDIR=${MY_LOCALSTATEDIR="${EPREFIX}/var/lib/mysql"}
	MY_LOGDIR=${MY_LOGDIR="${EPREFIX}/var/log/mysql"}
	MY_INCLUDEDIR=${MY_INCLUDEDIR="${EPREFIX}/usr/include/mysql"}
	MY_LIBDIR=${MY_LIBDIR="${EPREFIX}/usr/$(get_libdir)/mysql"}

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

	if [ "${MY_SOURCEDIR:-unset}" == "unset" ]; then
		MY_SOURCEDIR=${SERVER_URI##*/}
		MY_SOURCEDIR=${MY_SOURCEDIR%.tar*}
	fi

	export MY_SHAREDSTATEDIR MY_SYSCONFDIR
	export MY_LIBDIR MY_LOCALSTATEDIR MY_LOGDIR
	export MY_INCLUDEDIR MY_DATADIR MY_SOURCEDIR
}
fi
