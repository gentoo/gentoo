# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: depend.apache.eclass
# @MAINTAINER:
# apache-bugs@gentoo.org
# @SUPPORTED_EAPIS: 0 2 3 4 5 6 7
# @BLURB: Functions to allow ebuilds to depend on apache
# @DESCRIPTION:
# This eclass handles depending on apache in a sane way and provides information
# about where certain binaries and configuration files are located.
#
# To make use of this eclass simply call one of the need/want_apache functions
# described below. Make sure you use the need/want_apache call after you have
# defined DEPEND and RDEPEND. Also note that you can not rely on the automatic
# RDEPEND=DEPEND that portage does if you use this eclass.
#
# See Bug 107127 for more information.
#
# @EXAMPLE:
#
# Here is an example of an ebuild depending on apache:
#
# @CODE
# DEPEND="virtual/Perl-CGI"
# RDEPEND="${DEPEND}"
# need_apache2
# @CODE
#
# Another example which demonstrates non-standard IUSE options for optional
# apache support:
#
# @CODE
# DEPEND="server? ( virtual/Perl-CGI )"
# RDEPEND="${DEPEND}"
# want_apache2 server
#
# pkg_setup() {
# 	depend.apache_pkg_setup server
# }
# @CODE

case ${EAPI:-0} in
	0|2|3|4|5)
		inherit multilib
		;;
	6|7)
		;;
	*)
		die "EAPI=${EAPI} is not supported by depend.apache.eclass"
		;;
esac

# ==============================================================================
# INTERNAL VARIABLES
# ==============================================================================

# @ECLASS_VARIABLE: APACHE_VERSION
# @DESCRIPTION:
# Stores the version of apache we are going to be ebuilding.
# This variable is set by the want/need_apache functions.

# @ECLASS_VARIABLE: APXS
# @DESCRIPTION:
# Path to the apxs tool.
# This variable is set by the want/need_apache functions.

# @ECLASS_VARIABLE: APACHE_BIN
# @DESCRIPTION:
# Path to the apache binary.
# This variable is set by the want/need_apache functions.

# @ECLASS_VARIABLE: APACHE_CTL
# @DESCRIPTION:
# Path to the apachectl tool.
# This variable is set by the want/need_apache functions.

# @ECLASS_VARIABLE: APACHE_BASEDIR
# @DESCRIPTION:
# Path to the server root directory.
# This variable is set by the want/need_apache functions (EAPI=0 through 5)
# or depend.apache_pkg_setup (EAPI=6 and later).

# @ECLASS_VARIABLE: APACHE_CONFDIR
# @DESCRIPTION:
# Path to the configuration file directory.
# This variable is set by the want/need_apache functions.

# @ECLASS_VARIABLE: APACHE_MODULES_CONFDIR
# @DESCRIPTION:
# Path where module configuration files are kept.
# This variable is set by the want/need_apache functions.

# @ECLASS_VARIABLE: APACHE_VHOSTS_CONFDIR
# @DESCRIPTION:
# Path where virtual host configuration files are kept.
# This variable is set by the want/need_apache functions.

# @ECLASS_VARIABLE: APACHE_MODULESDIR
# @DESCRIPTION:
# Path where we install modules.
# This variable is set by the want/need_apache functions (EAPI=0 through 5)
# or depend.apache_pkg_setup (EAPI=6 and later).

# @ECLASS_VARIABLE: APACHE_DEPEND
# @DESCRIPTION:
# Dependencies for Apache
APACHE_DEPEND="www-servers/apache"

# @ECLASS_VARIABLE: APACHE2_DEPEND
# @DESCRIPTION:
# Dependencies for Apache 2.x
APACHE2_DEPEND="=www-servers/apache-2*"

# @ECLASS_VARIABLE: APACHE2_2_DEPEND
# @DESCRIPTION:
# Dependencies for Apache 2.2.x
APACHE2_2_DEPEND="=www-servers/apache-2.2*"

# @ECLASS_VARIABLE: APACHE2_4_DEPEND
# @DESCRIPTION:
# Dependencies for Apache 2.4.x
APACHE2_4_DEPEND="=www-servers/apache-2.4*"


# ==============================================================================
# INTERNAL FUNCTIONS
# ==============================================================================

_init_apache2() {
	debug-print-function $FUNCNAME $*

	# WARNING: Do not use these variables with anything that is put
	# into the dependency cache (DEPEND/RDEPEND/etc)
	APACHE_VERSION="2"
	APXS="/usr/bin/apxs"
	APACHE_BIN="/usr/sbin/apache2"
	APACHE_CTL="/usr/sbin/apache2ctl"
	APACHE_INCLUDEDIR="/usr/include/apache2"
	APACHE_CONFDIR="/etc/apache2"
	APACHE_MODULES_CONFDIR="${APACHE_CONFDIR}/modules.d"
	APACHE_VHOSTS_CONFDIR="${APACHE_CONFDIR}/vhosts.d"

	case ${EAPI:-0} in
		0|2|3|4|5)
			_init_apache2_late
			;;
	esac
}

_init_apache2_late() {
	APACHE_BASEDIR="/usr/$(get_libdir)/apache2"
	APACHE_MODULESDIR="${APACHE_BASEDIR}/modules"
}

_init_no_apache() {
	debug-print-function $FUNCNAME $*
	APACHE_VERSION="0"
}

# ==============================================================================
# PUBLIC FUNCTIONS
# ==============================================================================

# @FUNCTION: depend.apache_pkg_setup
# @USAGE: [myiuse]
# @DESCRIPTION:
# An ebuild calls this in pkg_setup() to initialize variables for optional
# apache-2.x support. If the myiuse parameter is not given it defaults to
# apache2.
depend.apache_pkg_setup() {
	debug-print-function $FUNCNAME $*

	if [[ "${EBUILD_PHASE}" != "setup" ]]; then
		die "$FUNCNAME() should be called in pkg_setup()"
	fi

	local myiuse=${1:-apache2}

	case ${EAPI:-0} in
		0|2|3|4|5)
			if has ${myiuse} ${IUSE}; then
				if use ${myiuse}; then
					_init_apache2
				else
					_init_no_apache
				fi
			fi
			;;
		*)
			if in_iuse ${myiuse}; then
				if use ${myiuse}; then
					_init_apache2
					_init_apache2_late
				else
					_init_no_apache
				fi
			fi
			;;
	esac
}

# @FUNCTION: want_apache
# @USAGE: [myiuse]
# @DESCRIPTION:
# An ebuild calls this to get the dependency information for optional apache
# support. If the myiuse parameter is not given it defaults to apache2.
# An ebuild should additionally call depend.apache_pkg_setup() in pkg_setup()
# with the same myiuse parameter.
want_apache() {
	debug-print-function $FUNCNAME $*
	want_apache2 "$@"
}

# @FUNCTION: want_apache2
# @USAGE: [myiuse]
# @DESCRIPTION:
# An ebuild calls this to get the dependency information for optional apache-2.x
# support. If the myiuse parameter is not given it defaults to apache2.
# An ebuild should additionally call depend.apache_pkg_setup() in pkg_setup()
# with the same myiuse parameter.
want_apache2() {
	debug-print-function $FUNCNAME $*

	local myiuse=${1:-apache2}
	IUSE="${IUSE} ${myiuse}"
	DEPEND="${DEPEND} ${myiuse}? ( ${APACHE2_DEPEND} )"
	RDEPEND="${RDEPEND} ${myiuse}? ( ${APACHE2_DEPEND} )"
}

# @FUNCTION: want_apache2_2
# @USAGE: [myiuse]
# @DESCRIPTION:
# An ebuild calls this to get the dependency information for optional
# apache-2.2.x support. If the myiuse parameter is not given it defaults to
# apache2.
# An ebuild should additionally call depend.apache_pkg_setup() in pkg_setup()
# with the same myiuse parameter.
want_apache2_2() {
	debug-print-function $FUNCNAME $*

	local myiuse=${1:-apache2}
	IUSE="${IUSE} ${myiuse}"
	DEPEND="${DEPEND} ${myiuse}? ( ${APACHE2_2_DEPEND} )"
	RDEPEND="${RDEPEND} ${myiuse}? ( ${APACHE2_2_DEPEND} )"
}

# @FUNCTION: want_apache2_4
# @USAGE: [myiuse]
# @DESCRIPTION:
# An ebuild calls this to get the dependency information for optional
# apache-2.4.x support. If the myiuse parameter is not given it defaults to
# apache2.
# An ebuild should additionally call depend.apache_pkg_setup() in pkg_setup()
# with the same myiuse parameter.
want_apache2_4() {
	debug-print-function $FUNCNAME $*

	local myiuse=${1:-apache2}
	IUSE="${IUSE} ${myiuse}"
	DEPEND="${DEPEND} ${myiuse}? ( ${APACHE2_4_DEPEND} )"
	RDEPEND="${RDEPEND} ${myiuse}? ( ${APACHE2_4_DEPEND} )"
}

# @FUNCTION: need_apache
# @DESCRIPTION:
# An ebuild calls this to get the dependency information for apache.
need_apache() {
	debug-print-function $FUNCNAME $*
	need_apache2
}

# @FUNCTION: need_apache2
# @DESCRIPTION:
# An ebuild calls this to get the dependency information for apache-2.x.
need_apache2() {
	debug-print-function $FUNCNAME $*

	DEPEND="${DEPEND} ${APACHE2_DEPEND}"
	RDEPEND="${RDEPEND} ${APACHE2_DEPEND}"
	_init_apache2
}

# @FUNCTION: need_apache2_2
# @DESCRIPTION:
# An ebuild calls this to get the dependency information for apache-2.2.x.
need_apache2_2() {
	debug-print-function $FUNCNAME $*

	DEPEND="${DEPEND} ${APACHE2_2_DEPEND}"
	RDEPEND="${RDEPEND} ${APACHE2_2_DEPEND}"
	_init_apache2
}

# @FUNCTION: need_apache2_4
# @DESCRIPTION:
# An ebuild calls this to get the dependency information for apache-2.4.x.
need_apache2_4() {
        debug-print-function $FUNCNAME $*

        DEPEND="${DEPEND} ${APACHE2_4_DEPEND}"
        RDEPEND="${RDEPEND} ${APACHE2_4_DEPEND}"
        _init_apache2
}

# @FUNCTION: has_apache
# @DESCRIPTION:
# An ebuild calls this to get runtime variables for an indirect apache
# dependency without USE-flag, in which case want_apache does not work.
# DO NOT call this function in global scope.
has_apache() {
	debug-print-function $FUNCNAME $*

	if has_version '>=www-servers/apache-2'; then
		_init_apache2
	else
		_init_no_apache
	fi
}

# @FUNCTION: has_apache_threads
# @USAGE: [myflag]
# @DESCRIPTION:
# An ebuild calls this to make sure thread-safety is enabled if apache has been
# built with a threaded MPM. If the myflag parameter is not given it defaults to
# threads.
has_apache_threads() {
	debug-print-function $FUNCNAME $*

	case ${EAPI:-0} in
		0|1)
			die "depend.apache.eclass: has_apache_threads is not supported for EAPI=${EAPI:-0}"
			;;
	esac

	if ! has_version 'www-servers/apache[threads]'; then
		return
	fi

	local myflag="${1:-threads}"

	if ! use ${myflag}; then
		echo
		eerror "You need to enable USE flag '${myflag}' to build a thread-safe version"
		eerror "of ${CATEGORY}/${PN} for use with www-servers/apache"
		die "Need missing USE flag '${myflag}'"
	fi
}

# @FUNCTION: has_apache_threads_in
# @USAGE: <myforeign> [myflag]
# @DESCRIPTION:
# An ebuild calls this to make sure thread-safety is enabled in a foreign
# package if apache has been built with a threaded MPM. If the myflag parameter
# is not given it defaults to threads.
has_apache_threads_in() {
	debug-print-function $FUNCNAME $*

	case ${EAPI:-0} in
		0|1)
			die "depend.apache.eclass: has_apache_threads_in is not supported for EAPI=${EAPI:-0}"
			;;
	esac

	if ! has_version 'www-servers/apache[threads]'; then
		return
	fi

	local myforeign="$1"
	local myflag="${2:-threads}"

	if ! has_version "${myforeign}[${myflag}]"; then
		echo
		eerror "You need to enable USE flag '${myflag}' in ${myforeign} to"
		eerror "build a thread-safe version of ${CATEGORY}/${PN} for use"
		eerror "with www-servers/apache"
		die "Need missing USE flag '${myflag}' in ${myforeign}"
	fi
}

EXPORT_FUNCTIONS pkg_setup
