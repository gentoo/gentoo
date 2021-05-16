# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: apache-module.eclass
# @MAINTAINER:
# apache-bugs@gentoo.org
# @BLURB: Provides a common set of functions for apache modules
# @DESCRIPTION:
# This eclass handles apache modules in a sane way.
#
# To make use of this eclass simply call one of the need/want_apache functions
# described in depend.apache.eclass. Make sure you use the need/want_apache call
# after you have defined DEPEND and RDEPEND. Also note that you can not rely on
# the automatic RDEPEND=DEPEND that portage does if you use this eclass.
#
# See Bug 107127 for more information.
#
# @EXAMPLE:
#
# Here is a simple example of an ebuild for mod_foo:
#
# @CODE
# APACHE2_MOD_CONF="42_mod_foo"
# APACHE2_MOD_DEFINE="FOO"
# need_apache2
# @CODE
#
# A more complicated example for a module with non-standard locations:
#
# @CODE
# APXS2_S="${S}/apache22/src"
# APACHE2_MOD_FILE="${APXS2_S}/${PN}.so"
# APACHE2_MOD_CONF="42_${PN}"
# APACHE2_MOD_DEFINE="FOO"
# DOCFILES="docs/*.html"
# need_apache2_2
# @CODE
#
# A basic module configuration which just loads the module into apache:
#
# @CODE
# <IfDefine FOO>
# LoadModule foo_module modules/mod_foo.so
# </IfDefine>
# @CODE

inherit depend.apache

# ==============================================================================
# PUBLIC VARIABLES
# ==============================================================================

# @VARIABLE: APXS2_S
# @DESCRIPTION:
# Path to temporary build directory. (Defaults to `${S}/src' if it exists,
# `${S}' otherwise)

# @VARIABLE: APXS2_ARGS
# @DESCRIPTION:
# Arguments to pass to the apxs tool. (Defaults to `-c ${PN}.c')

# @VARIABLE: APACHE2_EXECFILES
# @DESCRIPTION:
# List of files that will be installed into ${APACHE_MODULE_DIR} beside
# ${APACHE2_MOD_FILE}. In addition, this function also sets the executable
# permission on those files.

# @VARIABLE: APACHE2_MOD_CONF
# @DESCRIPTION:
# Module configuration file installed by src_install (minus the .conf suffix and
# relative to ${FILESDIR}).

# @VARIABLE: APACHE2_MOD_DEFINE
# @DESCRIPTION:
# Name of define (e.g. FOO) to use in conditional loading of the installed
# module/its config file, multiple defines should be space separated.

# @VARIABLE: APACHE2_MOD_FILE
# @DESCRIPTION:
# Name of the module that src_install installs minus the .so suffix. (Defaults
# to `${APXS2_S}/.libs/${PN}.so')

# @VARIABLE: APACHE2_VHOST_CONF
# @DESCRIPTION:
# Virtual host configuration file installed by src_install (minus the .conf
# suffix and relative to ${FILESDIR}).

# @VARIABLE: DOCFILES
# @DESCRIPTION:
# If the exported src_install() is being used, and ${DOCFILES} is non-zero, some
# sed-fu is applied to split out html documentation (if any) from normal
# documentation, and dodoc'd or dohtml'd.

# ==============================================================================
# INTERNAL FUNCTIONS
# ==============================================================================

# Internal function to construct the default ${APXS2_S} path if required.
apache_cd_dir() {
	debug-print-function $FUNCNAME $*

	local CD_DIR="${APXS2_S}"

	if [[ -z "${CD_DIR}" ]] ; then
		if [[ -d "${S}/src" ]] ; then
			CD_DIR="${S}/src"
		else
			CD_DIR="${S}"
		fi
	fi

	debug-print $FUNCNAME "CD_DIR=${CD_DIR}"
	echo "${CD_DIR}"
}

# Internal function to construct the default ${APACHE2_MOD_FILE} if required.
apache_mod_file() {
	debug-print-function $FUNCNAME $*

	local MOD_FILE="${APACHE2_MOD_FILE:-$(apache_cd_dir)/.libs/${PN}.so}"

	debug-print $FUNCNAME "MOD_FILE=${MOD_FILE}"
	echo "${MOD_FILE}"
}

# Internal function for picking out html files from ${DOCFILES}. It takes an
# optional first argument `html'; if the first argument is equals `html', only
# html files are returned, otherwise normal (non-html) docs are returned.
apache_doc_magic() {
	debug-print-function $FUNCNAME $*

	local DOCS=

	if [[ -n "${DOCFILES}" ]] ; then
		if [[ "x$1" == "xhtml" ]] ; then
			DOCS="`echo ${DOCFILES} | sed -e 's/ /\n/g' | sed -e '/^[^ ]*.html$/ !d'`"
		else
			DOCS="`echo ${DOCFILES} | sed 's, *[^ ]*\+.html, ,g'`"
		fi
	fi

	debug-print $FUNCNAME "DOCS=${DOCS}"
	echo "${DOCS}"
}

# ==============================================================================
# EXPORTED FUNCTIONS
# ==============================================================================

# @FUNCTION: apache-module_src_compile
# @DESCRIPTION:
# The default action is to call ${APXS} with the value of ${APXS2_ARGS}. If a
# module requires a different build setup than this, use ${APXS} in your own
# src_compile routine.
apache-module_src_compile() {
	debug-print-function $FUNCNAME $*

	local CD_DIR=$(apache_cd_dir)
	cd "${CD_DIR}" || die "cd ${CD_DIR} failed"

	APXS2_ARGS="${APXS2_ARGS:--c ${PN}.c}"
	${APXS} ${APXS2_ARGS} || die "${APXS} ${APXS2_ARGS} failed"
}

# @FUNCTION: apache-module_src_install
# @DESCRIPTION:
# This installs the files into apache's directories. The module is installed
# from a directory chosen as above (apache_cd_dir). In addition, this function
# can also set the executable permission on files listed in
# ${APACHE2_EXECFILES}.  The configuration file name is listed in
# ${APACHE2_MOD_CONF} without the .conf extensions, so if you configuration is
# 55_mod_foo.conf, APACHE2_MOD_CONF would be 55_mod_foo. ${DOCFILES} contains
# the list of files you want filed as documentation.
apache-module_src_install() {
	debug-print-function $FUNCNAME $*

	local CD_DIR=$(apache_cd_dir)
	pushd "${CD_DIR}" >/dev/null || die "cd ${CD_DIR} failed"

	local MOD_FILE=$(apache_mod_file)

	exeinto "${APACHE_MODULESDIR}"
	doexe ${MOD_FILE} || die "internal ebuild error: '${MOD_FILE}' not found"
	[[ -n "${APACHE2_EXECFILES}" ]] && doexe ${APACHE2_EXECFILES}

	if [[ -n "${APACHE2_MOD_CONF}" ]] ; then
		insinto "${APACHE_MODULES_CONFDIR}"
		set -- ${APACHE2_MOD_CONF}
		newins "${FILESDIR}/${1}.conf" "$(basename ${2:-$1}).conf" \
			|| die "internal ebuild error: '${FILESDIR}/${1}.conf' not found"
	fi

	if [[ -n "${APACHE2_VHOST_CONF}" ]] ; then
		insinto "${APACHE_VHOSTS_CONFDIR}"
		set -- ${APACHE2_VHOST_CONF}
		newins "${FILESDIR}/${1}.conf" "$(basename ${2:-$1}).conf " \
			|| die "internal ebuild error: '${FILESDIR}/${1}.conf' not found"
	fi

	cd "${S}"

	if [[ -n "${DOCFILES}" ]] ; then
		local OTHER_DOCS=$(apache_doc_magic)
		local HTML_DOCS=$(apache_doc_magic html)

		[[ -n "${OTHER_DOCS}" ]] && dodoc ${OTHER_DOCS}
		[[ -n "${HTML_DOCS}" ]] && dohtml ${HTML_DOCS}
	fi

	popd >/dev/null
}

# @FUNCTION: apache-module_pkg_postinst
# @DESCRIPTION:
# This prints out information about the installed module and how to enable it.
apache-module_pkg_postinst() {
	debug-print-function $FUNCNAME $*

	if [[ -n "${APACHE2_MOD_DEFINE}" ]] ; then
		local my_opts="-D ${APACHE2_MOD_DEFINE// / -D }"

		einfo
		einfo "To enable ${PN}, you need to edit your /etc/conf.d/apache2 file and"
		einfo "add '${my_opts}' to APACHE2_OPTS."
		einfo
	fi

	if [[ -n "${APACHE2_MOD_CONF}" ]] ; then
		set -- ${APACHE2_MOD_CONF}
		einfo
		einfo "Configuration file installed as"
		einfo "    ${APACHE_MODULES_CONFDIR}/$(basename ${2:-$1}).conf"
		einfo "You may want to edit it before turning the module on in /etc/conf.d/apache2"
		einfo
	fi
}

EXPORT_FUNCTIONS src_compile src_install pkg_postinst
