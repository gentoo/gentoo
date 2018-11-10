# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# DEPRECATED
# This eclass has been deprecated and must not be used by any new
# ebuilds or eclasses. Replacements for particular phase functions
# in EAPI 2+:
#
# base_src_unpack() - default (or unpacker_src_unpack if unpacker.eclass
#     was inherited)
# base_src_prepare() - inherit eutils, inline:
#     epatch "${PATCHES[@]}" # if PATCHES defined as array
#     epatch ${PATCHES} # if PATCHES defined as string
#     epatch_user
# base_src_configure() - default
# base_src_compile() - default
# base_src_install() - default
# base_src_install_docs() - einstalldocs from eutils.eclass

# @ECLASS: base.eclass
# @MAINTAINER:
# QA Team <qa@gentoo.org>
# @AUTHOR:
# Original author: Dan Armak <danarmak@gentoo.org>
# @SUPPORTED_EAPIS: 0 1 2 3 4 5
# @BLURB: The base eclass defines some default functions and variables.
# @DESCRIPTION:
# The base eclass defines some default functions and variables.

if [[ -z ${_BASE_ECLASS} ]]; then
_BASE_ECLASS=1

inherit eutils

BASE_EXPF="src_unpack src_compile src_install"
case "${EAPI:-0}" in
	0|1) ;;
	2|3|4|5) BASE_EXPF+=" src_prepare src_configure" ;;
	*) die "${ECLASS}.eclass is banned in EAPI ${EAPI}";;
esac

EXPORT_FUNCTIONS ${BASE_EXPF}

# @ECLASS-VARIABLE: DOCS
# @DEFAULT_UNSET
# @DESCRIPTION:
# Array containing documents passed to dodoc command.
#
# DOCS=( "${S}/doc/document.txt" "${S}/doc/doc_folder/" )

# @ECLASS-VARIABLE: HTML_DOCS
# @DEFAULT_UNSET
# @DESCRIPTION:
# Array containing documents passed to dohtml command.
#
# HTML_DOCS=( "${S}/doc/document.html" "${S}/doc/html_folder/" )

# @ECLASS-VARIABLE: PATCHES
# @DEFAULT_UNSET
# @DESCRIPTION:
# PATCHES array variable containing all various patches to be applied.
# This variable is expected to be defined in global scope of ebuild.
# Make sure to specify the full path. This variable is utilised in
# src_unpack/src_prepare phase based on EAPI.
#
# NOTE: if using patches folders with special file suffixes you have to
# define one additional variable EPATCH_SUFFIX="something"
#
# PATCHES=( "${FILESDIR}/mypatch.patch" "${FILESDIR}/patches_folder/" )


# @FUNCTION: base_src_unpack
# @DESCRIPTION:
# The base src_unpack function, which is exported.
# Calls also src_prepare with eapi older than 2.
base_src_unpack() {
	debug-print-function $FUNCNAME "$@"

	pushd "${WORKDIR}" > /dev/null

	if [[ $(type -t unpacker_src_unpack) == "function" ]] ; then
		unpacker_src_unpack
	elif [[ -n ${A} ]] ; then
		unpack ${A}
	fi
	has src_prepare ${BASE_EXPF} || base_src_prepare

	popd > /dev/null
}

# @FUNCTION: base_src_prepare
# @DESCRIPTION:
# The base src_prepare function, which is exported
# EAPI is greater or equal to 2. Here the PATCHES array is evaluated.
base_src_prepare() {
	debug-print-function $FUNCNAME "$@"
	debug-print "$FUNCNAME: PATCHES=$PATCHES"

	local patches_failed=0

	pushd "${S}" > /dev/null
	if [[ "$(declare -p PATCHES 2>/dev/null 2>&1)" == "declare -a"* ]]; then
		for x in "${PATCHES[@]}"; do
			debug-print "$FUNCNAME: applying patch from ${x}"
			if [[ -d "${x}" ]]; then
				# Use standardized names and locations with bulk patching
				# Patch directory is ${WORKDIR}/patch
				# See epatch() in eutils.eclass for more documentation
				EPATCH_SUFFIX=${EPATCH_SUFFIX:=patch}

				# in order to preserve normal EPATCH_SOURCE value that can
				# be used other way than with base eclass store in local
				# variable and restore later
				oldval=${EPATCH_SOURCE}
				EPATCH_SOURCE=${x}
				EPATCH_FORCE=yes
				epatch
				EPATCH_SOURCE=${oldval}
			elif [[ -f "${x}" ]]; then
				epatch "${x}"
			else
				ewarn "QA: File or directory \"${x}\" does not exist."
				ewarn "QA: Check your PATCHES array or add missing file/directory."
				patches_failed=1
			fi
		done
		[[ ${patches_failed} -eq 1 ]] && die "Some patches failed. See above messages."
	else
		for x in ${PATCHES}; do
			debug-print "$FUNCNAME: patching from ${x}"
			epatch "${x}"
		done
	fi

	# Apply user patches
	debug-print "$FUNCNAME: applying user patches"
	epatch_user

	popd > /dev/null
}

# @FUNCTION: base_src_configure
# @DESCRIPTION:
# The base src_configure function, which is exported when
# EAPI is greater or equal to 2. Runs basic econf.
base_src_configure() {
	debug-print-function $FUNCNAME "$@"

	# there is no pushd ${S} so we can override its place where to run
	[[ -x ${ECONF_SOURCE:-.}/configure ]] && econf "$@"
}

# @FUNCTION: base_src_compile
# @DESCRIPTION:
# The base src_compile function, calls src_configure with
# EAPI older than 2.
base_src_compile() {
	debug-print-function $FUNCNAME "$@"

	has src_configure ${BASE_EXPF} || base_src_configure
	base_src_make "$@"
}

# @FUNCTION: base_src_make
# @DESCRIPTION:
# Actual function that runs emake command.
base_src_make() {
	debug-print-function $FUNCNAME "$@"

	if [[ -f Makefile || -f GNUmakefile || -f makefile ]]; then
		emake "$@" || die "died running emake, $FUNCNAME"
	fi
}

# @FUNCTION: base_src_install
# @DESCRIPTION:
# The base src_install function. Runs make install and
# installs documents and html documents from DOCS and HTML_DOCS
# arrays.
base_src_install() {
	debug-print-function $FUNCNAME "$@"

	emake DESTDIR="${D}" "$@" install || die "died running make install, $FUNCNAME"
	base_src_install_docs
}

# @FUNCTION: base_src_install_docs
# @DESCRIPTION:
# Actual function that install documentation from
# DOCS and HTML_DOCS arrays.
base_src_install_docs() {
	debug-print-function $FUNCNAME "$@"

	local x

	pushd "${S}" > /dev/null

	if [[ "$(declare -p DOCS 2>/dev/null 2>&1)" == "declare -a"* ]]; then
		for x in "${DOCS[@]}"; do
			debug-print "$FUNCNAME: docs: creating document from ${x}"
			dodoc "${x}" || die "dodoc failed"
		done
	fi
	if [[ "$(declare -p HTML_DOCS 2>/dev/null 2>&1)" == "declare -a"* ]]; then
		for x in "${HTML_DOCS[@]}"; do
			debug-print "$FUNCNAME: docs: creating html document from ${x}"
			dohtml -r "${x}" || die "dohtml failed"
		done
	fi

	popd > /dev/null
}

fi
