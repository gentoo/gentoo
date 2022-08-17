# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: wxwidgets.eclass
# @MAINTAINER:
# wxwidgets@gentoo.org
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Manages build configuration for wxGTK-using packages.
# @DESCRIPTION:
# This eclass sets up the proper environment for ebuilds using the wxGTK
# libraries.  Ebuilds using wxPython do not need to inherit this eclass.
#
# More specifically, this eclass controls the configuration chosen by the
# ${ESYSROOT}/usr/bin/wx-config wrapper.
#
# Using the eclass is simple:
#
#   - set WX_GTK_VER equal to a SLOT of wxGTK
#   - call setup-wxwidgets()
#
# The configuration chosen is based on the version required and the flags
# wxGTK was built with.

case ${EAPI} in
	7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_WXWIDGETS_ECLASS} ]]; then
_WXWIDGETS_ECLASS=1

# @ECLASS_VARIABLE: WX_GTK_VER
# @PRE_INHERIT
# @REQUIRED
# @DESCRIPTION:
# The SLOT of the x11-libs/wxGTK you're targeting.  Needs to be defined before
# inheriting the eclass.  Can be either "3.0" or "3.0-gtk3".
case ${WX_GTK_VER} in
	3.0-gtk3) ;;
	3.0)
		if [[ ${EAPI} != 7 ]]; then
			die "${ECLASS}: GTK 2 no longer supported in EAPI ${EAPI}"
		fi
		;;
	"") die "WX_GTK_VER not declared" ;;
	*)  die "Invalid WX_GTK_VER: must be set to a valid wxGTK SLOT ('3.0' or '3.0-gtk3')" ;;
esac
readonly WX_GTK_VER

inherit flag-o-matic

# @FUNCTION: setup-wxwidgets
# @DESCRIPTION:
# Call this in your ebuild to set up the environment for wxGTK in src_configure.
# Besides controlling the wx-config wrapper, this exports WX_CONFIG containing
# the path to the config in case it needs to be passed to the build system.
#
# This function also controls the level of debugging output from the libraries.
# Debugging features are enabled by default and need to be disabled at the
# package level.  Because this causes many warning dialogs to pop up during
# runtime, we add -DNDEBUG to CPPFLAGS to disable debugging features (unless
# your ebuild has a debug USE flag and it's enabled).  If you don't like this
# behavior, you can set WX_DISABLE_NDEBUG to override it.
#
# See: https://docs.wxwidgets.org/trunk/overview_debugging.html
setup-wxwidgets() {
	local w wxtoolkit wxconf

	case ${WX_GTK_VER} in
		3.0-gtk3) wxtoolkit=gtk3 ;;
		3.0)      wxtoolkit=gtk2
		          eqawarn "This package relies on the deprecated GTK 2 slot, which will go away soon (https://bugs.gentoo.org/618642)"
		          ;;
	esac

	if [[ -z ${WX_DISABLE_NDEBUG} ]]; then
		{ in_iuse debug && use debug; } || append-cppflags -DNDEBUG
	fi

	# toolkit overrides
	if has_version -d "x11-libs/wxGTK:${WX_GTK_VER}[aqua]"; then
		wxtoolkit="mac"
	elif ! has_version -d "x11-libs/wxGTK:${WX_GTK_VER}[X]"; then
		wxtoolkit="base"
	fi

	wxconf="${wxtoolkit}-unicode-${WX_GTK_VER}"
	for w in "${CHOST:-${CBUILD}}-${wxconf}" "${wxconf}"; do
		[[ -f ${ESYSROOT}/usr/$(get_libdir)/wx/config/${w} ]] && wxconf=${w} && break
	done || die "Failed to find configuration ${wxconf}"

	export WX_CONFIG="${ESYSROOT}/usr/$(get_libdir)/wx/config/${wxconf}"
	export WX_ECLASS_CONFIG="${WX_CONFIG}"

	einfo
	einfo "Requested wxWidgets:        ${WX_GTK_VER}"
	einfo "Using wxWidgets:            ${wxconf}"
	einfo
}

fi
