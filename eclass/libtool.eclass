# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: libtool.eclass
# @MAINTAINER:
# base-system@gentoo.org
# @SUPPORTED_EAPIS: 5 6 7 8
# @BLURB: quickly update bundled libtool code
# @DESCRIPTION:
# This eclass patches ltmain.sh distributed with libtoolized packages with the
# relink and portage patch among others
#
# Note, this eclass does not require libtool as it only applies patches to
# generated libtool files.  We do not run the libtoolize program because that
# requires a regeneration of the main autotool files in order to work properly.

if [[ -z ${_LIBTOOL_ECLASS} ]]; then
_LIBTOOL_ECLASS=1

case ${EAPI} in
	6) DEPEND=">=app-portage/elt-patches-20170815" ;;
	7|8) BDEPEND=">=app-portage/elt-patches-20170815" ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

inherit toolchain-funcs

# @ECLASS_VARIABLE: LIBTOOL
# @DEFAULT_UNSET
# @DESCRIPTION:
# The default libtool implementation. If unset GNU libtool will be used in most
# cases.

# @FUNCTION: eslibtool
# @USAGE: [flag]
# @DESCRIPTION:
# If the LIBTOOL variable in the user's environment is set and contains one of
# the slibtool symlinks it will be modified as required by the ebuild.
#
# If the MAKE or MAKEFLAGS environment variables are set they will also be
# modified accordingly.
#
# The flag should '-shared', '-static' or unset to use the equivalent slibtool
# symlink. With no arguments both shared and static libraries will be enabled.
eslibtool() {
	[[ -n "${LIBTOOL}" ]] || return

	local d new_libtool
	local shared="${1:-}"

	case "${shared}" in
		-shared|-static|'') : ;;
		*) die "Unknown argument '${shared}' for eslibtool()" ;;
	esac

	[[ "${LIBTOOL}" == ${LIBTOOL%/*} ]] || d="${LIBTOOL%/*}/"

	case "${LIBTOOL##*/}" in
		rlibtool|slibtool*) new_libtool="${d}slibtool${shared}" ;;
		rdlibtool|dlibtool*) new_libtool="${d}dlibtool${shared}" ;;
		rclibtool|rdclibtool|clibtool*) new_libtool="${d}clibtool${shared}" ;;
	esac

	[[ -n "${new_libtool}" ]] || return

	LIBTOOL="${new_libtool}"

	local slibtool=(
		{s,c,d}libtool{,-shared,-static}
		r{,c,d,dc}libtool
	)

	type -p "${LIBTOOL}" &>/dev/null ||
		die "${LIBTOOL} not found; is sys-devel/slibtool installed?"

	local i

	if [[ -n "${MAKE}" ]]; then
		for i in ${slibtool[@]}; do
			export MAKE="$(echo ${MAKE} | sed -e "s|LIBTOOL=${i}[^ ]*|LIBTOOL=${LIBTOOL}|g")"
		done
	fi

	if [[ -n "${MAKEFLAGS}" ]]; then
		for i in ${slibtool[@]}; do
			export MAKEFLAGS="$(echo ${MAKEFLAGS} | sed -e "s|LIBTOOL=${i}[^ ]*|LIBTOOL=${LIBTOOL}|g")"
		done
	fi
}

# @FUNCTION: elibtoolize
# @USAGE: [dirs] [--portage] [--reverse-deps] [--patch-only] [--remove-internal-dep=xxx] [--shallow] [--no-uclibc]
# @DESCRIPTION:
# Apply a smorgasbord of patches to bundled libtool files.  This function
# should always be safe to run.  If no directories are specified, then
# ${S} will be searched for appropriate files.
#
# If the --shallow option is used, then only ${S}/ltmain.sh will be patched.
#
# The other options should be avoided in general unless you know what's going on.
elibtoolize() {
	type -P eltpatch &>/dev/null || die "eltpatch not found; is app-portage/elt-patches installed?"

	ELT_LOGDIR=${T} \
	LD=$(tc-getLD) \
	eltpatch "${@}" || die "eltpatch failed"
}

fi
