# Copyright 1999-2024 Gentoo Authors
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
	6) DEPEND=">=app-portage/elt-patches-20240116" ;;
	7|8) BDEPEND=">=app-portage/elt-patches-20240116" ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

inherit toolchain-funcs

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
