# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/mysql-v2.eclass,v 1.39 2015/05/24 04:35:49 vapier Exp $

# @ECLASS: mysql-v2.eclass
# @MAINTAINER:
# Maintainers:
#	- MySQL Team <mysql-bugs@gentoo.org>
#	- Robin H. Johnson <robbat2@gentoo.org>
#	- Jorge Manuel B. S. Vicetto <jmbsvicetto@gentoo.org>
#	- Brian Evans <grknight@gentoo.org>
# @BLURB: This eclass provides most of the functions for mysql ebuilds
# @DESCRIPTION:
# The mysql-v2.eclass is the base eclass to build the mysql and
# alternative projects (mariadb and percona) ebuilds.
# This eclass uses the mysql-autotools and mysql-cmake eclasses for the
# specific bits related to the build system.
# It provides the src_unpack, src_prepare, src_configure, src_compile,
# src_install, pkg_preinst, pkg_postinst, pkg_config and pkg_postrm
# phase hooks.

# @ECLASS-VARIABLE: BUILD
# @DESCRIPTION:
# Build type of the mysql version
: ${BUILD:=autotools}

case ${BUILD} in
	"cmake")
		BUILD_INHERIT="mysql-cmake"
		;;
	"autotools")
		BUILD_INHERIT="mysql-autotools"

		WANT_AUTOCONF="latest"
		WANT_AUTOMAKE="latest"
		;;
	*)
		die "${BUILD} is not a valid build system for mysql"
		;;
esac

MYSQL_EXTRAS=""

# @ECLASS-VARIABLE: MYSQL_EXTRAS_VER
# @DESCRIPTION:
# The version of the MYSQL_EXTRAS repo to use to build mysql
# Use "none" to disable it's use
[[ ${MY_EXTRAS_VER} == "live" ]] && MYSQL_EXTRAS="git-r3"

inherit eutils flag-o-matic gnuconfig ${MYSQL_EXTRAS} ${BUILD_INHERIT} mysql_fx versionator toolchain-funcs user

#
# Supported EAPI versions and export functions
#

case "${EAPI:-0}" in
	4|5) ;;
	*) die "Unsupported EAPI: ${EAPI}" ;;
esac

EXPORT_FUNCTIONS pkg_setup src_unpack src_prepare src_configure src_compile src_install pkg_preinst pkg_postinst pkg_config pkg_postrm

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
MYSQL_PV_MAJOR="$(get_version_component_range 1-2 ${PV})"

# Cluster is a special case...
if [[ ${PN} == "mysql-cluster" ]]; then
	case ${PV} in
		6.1*|7.0*|7.1*) MYSQL_PV_MAJOR=5.1 ;;
		7.2*) MYSQL_PV_MAJOR=5.5 ;;
		7.3*) MYSQL_PV_MAJOR=5.6 ;;
	esac
fi

# MariaDB has left the numbering schema but keeping compatibility
if [[ ${PN} == "mariadb" || ${PN} == "mariadb-galera" ]]; then
	case ${PV} in
		10.0*|10.1*) MYSQL_PV_MAJOR="5.6" ;;
	esac
fi

# @ECLASS-VARIABLE: MYSQL_VERSION_ID
# @DESCRIPTION:
# MYSQL_VERSION_ID will be:
# major * 10e6 + minor * 10e4 + micro * 10e2 + gentoo revision number, all [0..99]
# This is an important part, because many of the choices the MySQL ebuild will do
# depend on this variable.
# In particular, the code below transforms a $PVR like "5.0.18-r3" in "5001803"
# We also strip off upstream's trailing letter that they use to respin tarballs
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

# This eclass should only be used with at least mysql-5.1.50
mysql_version_is_at_least "5.1.50" || die "This eclass should only be used with >=mysql-5.1.50"

# @ECLASS-VARIABLE: XTRADB_VER
# @DEFAULT_UNSET
# @DESCRIPTION:
# Version of the XTRADB storage engine

# @ECLASS-VARIABLE: PERCONA_VER
# @DEFAULT_UNSET
# @DESCRIPTION:
# Designation by PERCONA for a MySQL version to apply an XTRADB release

# Work out the default SERVER_URI correctly
if [[ -z ${SERVER_URI} ]]; then
	[[ -z ${MY_PV} ]] && MY_PV="${PV//_/-}"
	if [[ ${PN} == "mariadb" || ${PN} == "mariadb-galera" ]]; then
		# Beginning with 5.5, MariaDB stopped putting beta, alpha or rc on their tarball names
		mysql_version_is_at_least "5.5" && MARIA_FULL_PV=$(get_version_component_range 1-3) || \
			MARIA_FULL_PV=$(replace_version_separator 3 '-' ${MY_PV})
		MARIA_FULL_P="${PN}-${MARIA_FULL_PV}"
		SERVER_URI="
		http://ftp.osuosl.org/pub/mariadb/${MARIA_FULL_P}/kvm-tarbake-jaunty-x86/${MARIA_FULL_P}.tar.gz
		http://ftp.osuosl.org/pub/mariadb/${MARIA_FULL_P}/source/${MARIA_FULL_P}.tar.gz
		http://mirror.jmu.edu/pub/mariadb/${MARIA_FULL_P}/kvm-tarbake-jaunty-x86/${MARIA_FULL_P}.tar.gz
		http://mirrors.coreix.net/mariadb/${MARIA_FULL_P}/kvm-tarbake-jaunty-x86/${MARIA_FULL_P}.tar.gz
		http://mirrors.syringanetworks.net/mariadb/${MARIA_FULL_P}/kvm-tarbake-jaunty-x86/${MARIA_FULL_P}.tar.gz
		http://mirrors.fe.up.pt/pub/mariadb/${MARIA_FULL_P}/kvm-tarbake-jaunty-x86/${MARIA_FULL_P}.tar.gz
		http://mirror2.hs-esslingen.de/mariadb/${MARIA_FULL_P}/kvm-tarbake-jaunty-x86/${MARIA_FULL_P}.tar.gz
		"
		if [[ ${PN} == "mariadb-galera" ]]; then
			MY_SOURCEDIR="${PN%%-galera}-${MARIA_FULL_PV}"
		fi
	elif [[ ${PN} == "percona-server" ]]; then
		PERCONA_PN="Percona-Server"
		MIRROR_PV=$(get_version_component_range 1-2 ${PV})
		MY_PV=$(get_version_component_range 1-3 ${PV})
		PERCONA_RELEASE=$(get_version_component_range 4-5 ${PV})
		PERCONA_RC=$(get_version_component_range 6 ${PV})
		SERVER_URI="http://www.percona.com/redir/downloads/${PERCONA_PN}-${MIRROR_PV}/${PERCONA_PN}-${MY_PV}-${PERCONA_RC}${PERCONA_RELEASE}/source/tarball/${PN}-${MY_PV}-${PERCONA_RC}${PERCONA_RELEASE}.tar.gz"
#		http://www.percona.com/redir/downloads/Percona-Server-5.5/LATEST/source/tarball/Percona-Server-5.5.30-30.2.tar.gz
#		http://www.percona.com/redir/downloads/Percona-Server-5.6/Percona-Server-5.6.13-rc60.5/source/tarball/Percona-Server-5.6.13-rc60.5.tar.gz
	else
		if [[ "${PN}" == "mysql-cluster" ]] ; then
			URI_DIR="MySQL-Cluster"
			URI_FILE="mysql-cluster-gpl"
		else
			URI_DIR="MySQL"
			URI_FILE="mysql"
		fi
		URI_A="${URI_FILE}-${MY_PV}.tar.gz"
		MIRROR_PV=$(get_version_component_range 1-2 ${PV})
		# Recently upstream switched to an archive site, and not on mirrors
		SERVER_URI="http://downloads.mysql.com/archives/${URI_FILE}-${MIRROR_PV}/${URI_A}
					https://downloads.skysql.com/files/${URI_FILE}-${MIRROR_PV}/${URI_A}
					mirror://mysql/Downloads/${URI_DIR}-${PV%.*}/${URI_A}"
	fi
fi

# Define correct SRC_URIs
SRC_URI="${SERVER_URI}"

# Gentoo patches to MySQL
if [[ ${MY_EXTRAS_VER} != "live" && ${MY_EXTRAS_VER} != "none" ]]; then
	SRC_URI="${SRC_URI}
		mirror://gentoo/mysql-extras-${MY_EXTRAS_VER}.tar.bz2
		http://g3nt8.org/patches/mysql-extras-${MY_EXTRAS_VER}.tar.bz2
		http://dev.gentoo.org/~robbat2/distfiles/mysql-extras-${MY_EXTRAS_VER}.tar.bz2
		http://dev.gentoo.org/~jmbsvicetto/distfiles/mysql-extras-${MY_EXTRAS_VER}.tar.bz2
		http://dev.gentoo.org/~grknight/distfiles/mysql-extras-${MY_EXTRAS_VER}.tar.bz2"
fi

DESCRIPTION="A fast, multi-threaded, multi-user SQL database server"
HOMEPAGE="http://www.mysql.com/"
if [[ ${PN} == "mariadb" ]]; then
	HOMEPAGE="http://mariadb.org/"
	DESCRIPTION="An enhanced, drop-in replacement for MySQL"
fi
if [[ ${PN} == "mariadb-galera" ]]; then
	HOMEPAGE="http://mariadb.org/"
	DESCRIPTION="An enhanced, drop-in replacement for MySQL with Galera Replication"
fi
if [[ ${PN} == "percona-server" ]]; then
	HOMEPAGE="http://www.percona.com/software/percona-server"
	DESCRIPTION="An enhanced, drop-in replacement for MySQL from the Percona team"
fi
LICENSE="GPL-2"
SLOT="0"

case "${BUILD}" in
	"autotools")
		IUSE="big-tables debug embedded minimal +perl selinux ssl static test"
		;;
	"cmake")
		IUSE="debug embedded minimal +perl selinux ssl static static-libs test"
		;;
esac

# Common IUSE
IUSE="${IUSE} latin1 extraengine cluster max-idx-128 +community profiling"

# This probably could be simplified, but the syntax would have to be just right
if [[ ${PN} == "mariadb" || ${PN} == "mariadb-galera" ]] && \
	mysql_version_is_at_least "5.5" ; then
	IUSE="bindist ${IUSE}"
	RESTRICT="${RESTRICT} !bindist? ( bindist )"
elif [[ ${PN} == "mysql" || ${PN} == "percona-server" ]] && \
	mysql_check_version_range "5.5.37 to 5.6.11.99" ; then
	IUSE="bindist ${IUSE}"
	RESTRICT="${RESTRICT} !bindist? ( bindist )"
elif [[ ${PN} == "mysql-cluster" ]] && \
	mysql_check_version_range "7.2 to 7.2.99.99"  ; then
	IUSE="bindist ${IUSE}"
	RESTRICT="${RESTRICT} !bindist? ( bindist )"
fi

if [[ ${PN} == "mariadb" || ${PN} == "mariadb-galera" ]]; then
	mysql_check_version_range "5.1.38 to 5.3.99" && IUSE="${IUSE} libevent"
	mysql_version_is_at_least "5.2" && IUSE="${IUSE} oqgraph" && \
		REQUIRED_USE="${REQUIRED_USE} minimal? ( !oqgraph )"
	mysql_version_is_at_least "5.2.5" && IUSE="${IUSE} sphinx" && \
		REQUIRED_USE="${REQUIRED_USE} minimal? ( !sphinx )"
	mysql_version_is_at_least "5.2.10" && IUSE="${IUSE} pam"
	# 5.5.33 and 10.0.5 add TokuDB. Authors strongly recommend jemalloc or perfomance suffers
	mysql_version_is_at_least "10.0.5" && IUSE="${IUSE} tokudb odbc xml" && \
		REQUIRED_USE="${REQUIRED_USE} odbc? ( extraengine ) xml? ( extraengine ) tokudb? ( jemalloc )"
	mysql_check_version_range "5.5.33 to 5.5.99" && IUSE="${IUSE} tokudb" && \
		REQUIRED_USE="${REQUIRED_USE} tokudb? ( jemalloc )"
fi

if mysql_version_is_at_least "5.5"; then
	REQUIRED_USE="${REQUIRED_USE} tcmalloc? ( !jemalloc ) jemalloc? ( !tcmalloc )"
	IUSE="${IUSE} jemalloc tcmalloc"
fi

if mysql_version_is_at_least "5.5.7"; then
	IUSE="${IUSE} systemtap"
fi

if [[ ${PN} == "percona-server" ]]; then
	mysql_version_is_at_least "5.5.10" && IUSE="${IUSE} pam"
fi

REQUIRED_USE="${REQUIRED_USE} minimal? ( !cluster !extraengine !embedded ) static? ( !ssl )"

#
# DEPENDENCIES:
#

# Be warned, *DEPEND are version-dependant
# These are used for both runtime and compiletime
DEPEND="
	ssl? ( >=dev-libs/openssl-0.9.6d:0 )
	kernel_linux? ( sys-process/procps )
	>=sys-apps/sed-4
	>=sys-apps/texinfo-4.7-r1
	>=sys-libs/zlib-1.2.3
"
# TODO: add this as a dep if it is moved from the overlay
#	!dev-db/mariadb-native-client[mysqlcompat]

# dev-db/mysql-5.6.12+ only works with dev-libs/libedit
# This probably could be simplified
if [[ ${PN} == "mysql" || ${PN} == "percona-server" ]] && \
	mysql_version_is_at_least "5.6.12" ; then
	DEPEND="${DEPEND} dev-libs/libedit"
elif [[ ${PN} == "mysql-cluster" ]] && mysql_version_is_at_least "7.3"; then
	DEPEND="${DEPEND} dev-libs/libedit"
else
	if mysql_version_is_at_least "5.5" ; then
		DEPEND="${DEPEND} !bindist? ( >=sys-libs/readline-4.1:0 )"
	else
		DEPEND="${DEPEND} >=sys-libs/readline-4.1:0"
	fi
fi

if [[ ${PN} == "mariadb" || ${PN} == "mariadb-galera" ]] ; then
	mysql_check_version_range "5.1.38 to 5.3.99" && DEPEND="${DEPEND} libevent? ( >=dev-libs/libevent-1.4 )"
	mysql_version_is_at_least "5.2" && DEPEND="${DEPEND} oqgraph? ( >=dev-libs/boost-1.40.0 )"
	mysql_version_is_at_least "5.2.10" && DEPEND="${DEPEND} !minimal? ( pam? ( virtual/pam ) )"
	# Bug 441700 MariaDB >=5.3 include custom mytop
	mysql_version_is_at_least "5.3" && DEPEND="${DEPEND} perl? ( !dev-db/mytop )"
	if mysql_version_is_at_least "10.0.5" ; then
		DEPEND="${DEPEND}
			odbc? ( dev-db/unixODBC )
			xml? ( dev-libs/libxml2 )
			"
	fi
	mysql_version_is_at_least "10.0.7" && DEPEND="${DEPEND} oqgraph? ( dev-libs/judy )"
	if mysql_version_is_at_least "10.0.9" ; then
		DEPEND="${DEPEND} >=dev-libs/libpcre-8.35"
	fi
fi

# Having different flavours at the same time is not a good idea
for i in "mysql" "mariadb" "mariadb-galera" "percona-server" "mysql-cluster" ; do
	[[ ${i} == ${PN} ]] ||
	DEPEND="${DEPEND} !dev-db/${i}"
done

if mysql_version_is_at_least "5.5.7" ; then
	DEPEND="${DEPEND}
		jemalloc? ( dev-libs/jemalloc[static-libs?] )
		tcmalloc? ( dev-util/google-perftools )
		>=sys-libs/zlib-1.2.3[static-libs?]
		ssl? ( >=dev-libs/openssl-0.9.6d[static-libs?] )
		systemtap? ( >=dev-util/systemtap-1.3 )
		kernel_linux? ( dev-libs/libaio )
	"
fi

if [[ ${PN} == "mysql-cluster" ]] ; then
	# TODO: This really should include net-misc/memcached
	# but the package does not install the files it seeks.
	mysql_version_is_at_least "7.2.3" && \
		DEPEND="${DEPEND} dev-libs/libevent"
fi

# prefix: first need to implement something for #196294
RDEPEND="${DEPEND}
	!minimal? ( !prefix? ( dev-db/mysql-init-scripts ) )
	selinux? ( sec-policy/selinux-mysql )
"

if [[ ${PN} == "mariadb" || ${PN} == "mariadb-galera" ]] ; then
	# Bug 455016 Add dependencies of mytop
	if mysql_version_is_at_least "5.3" ; then
		RDEPEND="${RDEPEND}
			perl? (
				virtual/perl-Getopt-Long
				dev-perl/TermReadKey
				virtual/perl-Term-ANSIColor
				virtual/perl-Time-HiRes
			)
		"
	fi
fi

if [[ ${PN} == "mariadb-galera" ]] ; then
	# The wsrep API version must match between the ebuild and sys-cluster/galera.
	# This will be indicated by WSREP_REVISION in the ebuild and the first number
	# in the version of sys-cluster/galera
	RDEPEND="${RDEPEND}
		=sys-cluster/galera-${WSREP_REVISION}*
	"
fi

if [[ ${PN} == "mysql-cluster" ]] ; then
	mysql_version_is_at_least "7.2.9" && RDEPEND="${RDEPEND} java? ( >=virtual/jre-1.6 )" && \
		DEPEND="${DEPEND} java? ( >=virtual/jdk-1.6 )"
fi

DEPEND="${DEPEND}
	virtual/yacc
"

DEPEND="${DEPEND} static? ( sys-libs/ncurses[static-libs] )"

# compile-time-only
DEPEND="${DEPEND} >=dev-util/cmake-2.4.3"

# compile-time-only
if mysql_version_is_at_least "5.5.8" ; then
	DEPEND="${DEPEND} >=dev-util/cmake-2.6.3"
fi

# dev-perl/DBD-mysql is needed by some scripts installed by MySQL
PDEPEND="perl? ( >=dev-perl/DBD-mysql-2.9004 )"

# For other stuff to bring us in
PDEPEND="${PDEPEND} ~virtual/mysql-${MYSQL_PV_MAJOR}"

#
# External patches
#

# MariaDB has integrated PBXT until it was dropped in version 5.5.33
# PBXT_VERSION means that we have a PBXT patch for this PV
# PBXT was only introduced after 5.1.12
pbxt_patch_available() {
	[[ ${PN} != "mariadb" && ${PN} != "mariadb-galera" && ( -n "${PBXT_VERSION}" ) ]]
	return $?
}

pbxt_available() {
	pbxt_patch_available || [[ ${PN} == "mariadb" || ${PN} == "mariadb-galera" ]] && mysql_check_version_range "5.1 to 5.5.32"
	return $?
}

# Get the percona tarball if XTRADB_VER and PERCONA_VER are both set
# MariaDB has integrated XtraDB
# XTRADB_VERS means that we have a XTRADB patch for this PV
# XTRADB was only introduced after 5.1.26
xtradb_patch_available() {
	[[ ${PN} != "mariadb" && ${PN} != "mariadb-galera"
		&& ( -n "${XTRADB_VER}" ) && ( -n "${PERCONA_VER}" ) ]]
	return $?
}

if pbxt_patch_available; then

	PBXT_P="pbxt-${PBXT_VERSION}"
	PBXT_SRC_URI="http://www.primebase.org/download/${PBXT_P}.tar.gz mirror://sourceforge/pbxt/${PBXT_P}.tar.gz"
	SRC_URI="${SRC_URI} pbxt? ( ${PBXT_SRC_URI} )"
fi

# PBXT_NEWSTYLE means pbxt is in storage/ and gets enabled as other plugins
# vs. built outside the dir
if pbxt_available; then

	IUSE="${IUSE} pbxt"
	PBXT_NEWSTYLE=1
	REQUIRED_USE="${REQUIRED_USE} pbxt? ( !embedded ) "
fi

if xtradb_patch_available; then
	XTRADB_P="percona-xtradb-${XTRADB_VER}"
	XTRADB_SRC_URI_COMMON="${PERCONA_VER}/source/${XTRADB_P}.tar.gz"
	XTRADB_SRC_B1="http://www.percona.com/"
	XTRADB_SRC_B2="${XTRADB_SRC_B1}/percona-builds/"
	XTRADB_SRC_URI1="${XTRADB_SRC_B2}/Percona-Server/Percona-Server-${XTRADB_SRC_URI_COMMON}"
	XTRADB_SRC_URI2="${XTRADB_SRC_B2}/xtradb/${XTRADB_SRC_URI_COMMON}"
	XTRADB_SRC_URI3="${XTRADB_SRC_B1}/${PN}/xtradb/${XTRADB_SRC_URI_COMMON}"
	SRC_URI="${SRC_URI} xtradb? ( ${XTRADB_SRC_URI1} ${XTRADB_SRC_URI2} ${XTRADB_SRC_URI3} )"
	IUSE="${IUSE} xtradb"
	REQUIRED_USE="${REQUIRED_USE} xtradb? ( !embedded ) "
fi

#
# HELPER FUNCTIONS:
#

# @FUNCTION: mysql-v2_disable_test
# @DESCRIPTION:
# Helper function to disable specific tests.
mysql-v2_disable_test() {
	${BUILD_INHERIT}_disable_test "$@"
}

# @FUNCTION: mysql-v2_configure_minimal
# @DESCRIPTION:
# Helper function to configure minimal build
configure_minimal() {
	${BUILD_INHERIT}_configure_minimal "$@"
}

# @FUNCTION: mysql-v2_configure_common
# @DESCRIPTION:
# Helper function to configure common builds
configure_common() {
	${BUILD_INHERIT}_configure_common "$@"
}

#
# EBUILD FUNCTIONS
#

# @FUNCTION: mysql-v2_pkg_setup
# @DESCRIPTION:
# Perform some basic tests and tasks during pkg_setup phase:
#	die if FEATURES="test", USE="-minimal" and not using FEATURES="userpriv"
#	check for conflicting use flags
#	create new user and group for mysql
#	warn about deprecated features
mysql-v2_pkg_setup() {

	if has test ${FEATURES} ; then
		if ! use minimal ; then
			if ! has userpriv ${FEATURES} ; then
				eerror "Testing with FEATURES=-userpriv is no longer supported by upstream. Tests MUST be run as non-root."
			fi
		fi
	fi

	# Check for USE flag problems in pkg_setup
	if ! mysql_version_is_at_least "5.2" && use debug ; then
		# Also in package.use.mask
		die "Bug #344885: Upstream has broken USE=debug for 5.1 series >=5.1.51"
	fi

	# This should come after all of the die statements
	enewgroup mysql 60 || die "problem adding 'mysql' group"
	enewuser mysql 60 -1 /dev/null mysql || die "problem adding 'mysql' user"

	if use cluster && [[ "${PN}" != "mysql-cluster" ]]; then
		ewarn "Upstream has noted that the NDB cluster support in the 5.0 and"
		ewarn "5.1 series should NOT be put into production. In the near"
		ewarn "future, it will be disabled from building."
	fi

	if [[ ${PN} == "mysql-cluster" ]] ; then
		mysql_version_is_at_least "7.2.9" && java-pkg-opt-2_pkg_setup
	fi

	if use_if_iuse tokudb && [[ $(gcc-major-version) -lt 4 || $(gcc-major-version) -eq 4 && $(gcc-minor-version) -lt 7 ]] ; then
		eerror "${PN} with tokudb needs to be built with gcc-4.7 or later."
		eerror "Please use gcc-config to switch to gcc-4.7 or later version."
		die
	fi

}

# @FUNCTION: mysql-v2_src_unpack
# @DESCRIPTION:
# Unpack the source code
mysql-v2_src_unpack() {

	# Initialize the proper variables first
	mysql_init_vars

	unpack ${A}
	# Grab the patches
	[[ "${MY_EXTRAS_VER}" == "live" ]] && S="${WORKDIR}/mysql-extras" git-r3_src_unpack

	mv -f "${WORKDIR}/${MY_SOURCEDIR}" "${S}"
}

# @FUNCTION: mysql-v2_src_prepare
# @DESCRIPTION:
# Apply patches to the source code and remove unneeded bundled libs.
mysql-v2_src_prepare() {
	${BUILD_INHERIT}_src_prepare "$@"
	if [[ ${PN} == "mysql-cluster" ]] ; then
		mysql_version_is_at_least "7.2.9" && java-pkg-opt-2_src_prepare
	fi
}

# @FUNCTION: mysql-v2_src_configure
# @DESCRIPTION:
# Configure mysql to build the code for Gentoo respecting the use flags.
mysql-v2_src_configure() {
	${BUILD_INHERIT}_src_configure "$@"
}

# @FUNCTION: mysql-v2_src_compile
# @DESCRIPTION:
# Compile the mysql code.
mysql-v2_src_compile() {
	${BUILD_INHERIT}_src_compile "$@"
}

# @FUNCTION: mysql-v2_src_install
# @DESCRIPTION:
# Install mysql.
mysql-v2_src_install() {
	${BUILD_INHERIT}_src_install "$@"
}

# @FUNCTION: mysql-v2_pkg_preinst
# @DESCRIPTION:
# Create the user and groups for mysql - die if that fails.
mysql-v2_pkg_preinst() {
	if [[ ${PN} == "mysql-cluster" ]] ; then
		mysql_version_is_at_least "7.2.9" && java-pkg-opt-2_pkg_preinst
	fi
	enewgroup mysql 60 || die "problem adding 'mysql' group"
	enewuser mysql 60 -1 /dev/null mysql || die "problem adding 'mysql' user"
}

# @FUNCTION: mysql-v2_pkg_postinst
# @DESCRIPTION:
# Run post-installation tasks:
#	create the dir for logfiles if non-existant
#	touch the logfiles and secure them
#	install scripts
#	issue required steps for optional features
#	issue deprecation warnings
mysql-v2_pkg_postinst() {

	# Make sure the vars are correctly initialized
	mysql_init_vars

	# Check FEATURES="collision-protect" before removing this
	[[ -d "${ROOT}${MY_LOGDIR}" ]] || install -d -m0750 -o mysql -g mysql "${ROOT}${MY_LOGDIR}"

	# Secure the logfiles
	touch "${ROOT}${MY_LOGDIR}"/mysql.{log,err}
	chown mysql:mysql "${ROOT}${MY_LOGDIR}"/mysql*
	chmod 0660 "${ROOT}${MY_LOGDIR}"/mysql*

	# Minimal builds don't have the MySQL server
	if ! use minimal ; then
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

		if [[ ${PN} == "mariadb" || ${PN} == "mariadb-galera" ]] ; then
			if use_if_iuse pam ; then
				einfo
				elog "This install includes the PAM authentication plugin."
				elog "To activate and configure the PAM plugin, please read:"
				elog "https://kb.askmonty.org/en/pam-authentication-plugin/"
				einfo
			fi
		fi

		einfo
		elog "You might want to run:"
		elog "\"emerge --config =${CATEGORY}/${PF}\""
		elog "if this is a new install."
		einfo

		einfo
		elog "If you are upgrading major versions, you should run the"
		elog "mysql_upgrade tool."
		einfo

		if [[ ${PN} == "mariadb-galera" ]] ; then
			einfo
			elog "Be sure to edit the my.cnf file to activate your cluster settings."
			elog "This should be done after running \"emerge --config =${CATEGORY}/${PF}\""
			elog "The first time the cluster is activated, you should add"
			elog "--wsrep-new-cluster to the options in /etc/conf.d/mysql for one node."
			elog "This option should then be removed for subsequent starts."
			einfo
		fi
	fi

	if use_if_iuse pbxt ; then
		elog "Note: PBXT is now statically built when enabled."
		elog ""
		elog "If, you previously installed as a plugin and "
		elog "you cannot start the MySQL server,"
		elog "remove the ${MY_DATADIR}/mysql/plugin.* files, then"
		elog "use the MySQL upgrade script to restore the table"
		elog "or execute the following SQL command:"
		elog "	CREATE TABLE IF NOT EXISTS plugin ("
		elog "		name char(64) binary DEFAULT '' NOT NULL,"
		elog "		dl char(128) DEFAULT '' NOT NULL,"
		elog "		PRIMARY KEY (name)"
		elog "	) CHARACTER SET utf8 COLLATE utf8_bin;"
	fi
}

# @FUNCTION: mysql-v2_getopt
# @DESCRIPTION:
# Use my_print_defaults to extract specific config options
mysql-v2_getopt() {
	local mypd="${EROOT}"/usr/bin/my_print_defaults
	section="$1"
	flag="--${2}="
	"${mypd}" $section | sed -n "/^${flag}/p"
}

# @FUNCTION: mysql-v2_getoptval
# @DESCRIPTION:
# Use my_print_defaults to extract specific config options
mysql-v2_getoptval() {
	local mypd="${EROOT}"/usr/bin/my_print_defaults
	section="$1"
	flag="--${2}="
	"${mypd}" $section | sed -n "/^${flag}/s,${flag},,gp"
}

# @FUNCTION: mysql-v2_pkg_config
# @DESCRIPTION:
# Configure mysql environment.
mysql-v2_pkg_config() {

	local old_MY_DATADIR="${MY_DATADIR}"
	local old_HOME="${HOME}"
	# my_print_defaults needs to read stuff in $HOME/.my.cnf
	export HOME=${EPREFIX}/root

	# Make sure the vars are correctly initialized
	mysql_init_vars

	[[ -z "${MY_DATADIR}" ]] && die "Sorry, unable to find MY_DATADIR"

	if built_with_use ${CATEGORY}/${PN} minimal ; then
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
		MYSQL_ROOT_PASSWORD="$(mysql-v2_getoptval 'client mysql' password)"
	fi
	MYSQL_TMPDIR="$(mysql-v2_getoptval mysqld tmpdir)"
	# These are dir+prefix
	MYSQL_RELAY_LOG="$(mysql-v2_getoptval mysqld relay-log)"
	MYSQL_RELAY_LOG=${MYSQL_RELAY_LOG%/*}
	MYSQL_LOG_BIN="$(mysql-v2_getoptval mysqld log-bin)"
	MYSQL_LOG_BIN=${MYSQL_LOG_BIN%/*}

	if [[ ! -d "${ROOT}"/$MYSQL_TMPDIR ]]; then
		einfo "Creating MySQL tmpdir $MYSQL_TMPDIR"
		install -d -m 770 -o mysql -g mysql "${ROOT}"/$MYSQL_TMPDIR
	fi
	if [[ ! -d "${ROOT}"/$MYSQL_LOG_BIN ]]; then
		einfo "Creating MySQL log-bin directory $MYSQL_LOG_BIN"
		install -d -m 770 -o mysql -g mysql "${ROOT}"/$MYSQL_LOG_BIN
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

		einfo "Please provide a password for the mysql 'root' user now, in the"
		einfo "MYSQL_ROOT_PASSWORD env var or through the ${HOME}/.my.cnf file."
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
	use prefix && options="${options} --defaults-file=${MY_SYSCONFDIR}/my.cnf"

	local help_tables="${ROOT}${MY_SHAREDSTATEDIR}/fill_help_tables.sql"
	[[ -r "${help_tables}" ]] \
	&& cp "${help_tables}" "${TMPDIR}/fill_help_tables.sql" \
	|| touch "${TMPDIR}/fill_help_tables.sql"
	help_tables="${TMPDIR}/fill_help_tables.sql"

	# Figure out which options we need to disable to do the setup
	helpfile="${TMPDIR}/mysqld-help"
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

	# MySQL 5.6+ needs InnoDB
	if [[ ${PN} == "mysql" || ${PN} == "percona-server" ]] ; then
		mysql_version_is_at_least "5.6" || options="${options} --loose-skip-innodb"
	fi

	einfo "Creating the mysql database and setting proper permissions on it ..."

	# Now that /var/run is a tmpfs mount point, we need to ensure it exists before using it
	PID_DIR="${EROOT}/var/run/mysqld"
	if [[ ! -d "${PID_DIR}" ]]; then
		mkdir -p "${PID_DIR}" || die "Could not create pid directory"
		chown mysql:mysql "${PID_DIR}" || die "Could not set ownership on pid directory"
		chmod 755 "${PID_DIR}" || die "Could not set permissions on pid directory"
	fi

	pushd "${TMPDIR}" &>/dev/null
	#cmd="'${EROOT}/usr/share/mysql/scripts/mysql_install_db' '--basedir=${EPREFIX}/usr' ${options}"
	cmd=${EROOT}usr/share/mysql/scripts/mysql_install_db
	[[ -f ${cmd} ]] || cmd=${EROOT}usr/bin/mysql_install_db
	cmd="'$cmd' '--basedir=${EPREFIX}/usr' ${options} '--datadir=${ROOT}/${MY_DATADIR}' '--tmpdir=${ROOT}/${MYSQL_TMPDIR}'"
	einfo "Command: $cmd"
	eval $cmd \
		>"${TMPDIR}"/mysql_install_db.log 2>&1
	if [ $? -ne 0 ]; then
		grep -B5 -A999 -i "ERROR" "${TMPDIR}"/mysql_install_db.log 1>&2
		die "Failed to run mysql_install_db. Please review ${EPREFIX}/var/log/mysql/mysqld.err AND ${TMPDIR}/mysql_install_db.log"
	fi
	popd &>/dev/null
	[[ -f "${ROOT}/${MY_DATADIR}/mysql/user.frm" ]] \
	|| die "MySQL databases not installed"
	chown -R mysql:mysql "${ROOT}/${MY_DATADIR}" 2>/dev/null
	chmod 0750 "${ROOT}/${MY_DATADIR}" 2>/dev/null

	# Filling timezones, see
	# http://dev.mysql.com/doc/mysql/en/time-zone-support.html
	"${EROOT}/usr/bin/mysql_tzinfo_to_sql" "${EROOT}/usr/share/zoneinfo" > "${sqltmp}" 2>/dev/null

	if [[ -r "${help_tables}" ]] ; then
		cat "${help_tables}" >> "${sqltmp}"
	fi

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
	local sql="UPDATE mysql.user SET Password = PASSWORD('${MYSQL_ROOT_PASSWORD}') WHERE USER='root'"
	"${EROOT}/usr/bin/mysql" \
		--socket=${socket} \
		-hlocalhost \
		-e "${sql}"
	eend $?

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

	# Stop the server and cleanup
	einfo "Stopping the server ..."
	kill $(< "${pidfile}" )
	rm -f "${sqltmp}"
	wait %1
	einfo "Done"
}

# @FUNCTION: mysql-v2_pkg_postrm
# @DESCRIPTION:
# Remove mysql symlinks.
mysql-v2_pkg_postrm() {

	: # mysql_lib_symlinks "${ED}"
}
