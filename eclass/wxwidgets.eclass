# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: wxwidgets.eclass
# @MAINTAINER:
# wxwidgets@gentoo.org
# @BLURB: Manages build configuration for wxGTK-using packages.
# @DESCRIPTION:
#  This eclass gives ebuilds the ability to build against a specific wxGTK
#  SLOT and profile without interfering with the system configuration.  Any
#  ebuild with a x11-libs/wxGTK dependency must use this eclass.
#
#  There are two ways to do it:
#
#    - set WX_GTK_VER before inheriting the eclass
#    - set WX_GTK_VER and call need-wxwidgets from a phase function
#
#  (where WX_GTK_VER is the SLOT you want)
#
#  If your package has optional support for wxGTK (ie. by a USE flag) then
#  you should use need-wxwidgets.  This is important because some packages
#  will force-enable wxGTK if they find WX_CONFIG set in the environment.
#
# @CODE
#      inherit wxwidgets
#
#      IUSE="X wxwidgets"
#      DEPEND="wxwidgets? ( x11-libs/wxGTK:2.8[X?] )"
#
#      src_configure() {
#          if use wxwidgets; then 
#              WX_GTK_VER="2.8"
#              if use X; then
#                  need-wxwidgets unicode
#              else
#                  need-wxwidgets base-unicode
#              fi
#          fi
#          econf --with-wx-config="${WX_CONFIG}"
#      }
# @CODE
#
# That's about as complicated as it gets.  99% of ebuilds can get away with:
#
# @CODE
#      inherit wxwidgets
#      DEPEND="wxwidgets? ( x11-libs/wxGTK:2.8[X] )
#      ...
#      WX_GTK_VER=2.8 need-wxwidgets unicode
# @CODE
#
# Note: unless you know your package works with wxbase (which is very
# doubtful), always depend on wxGTK[X].

inherit eutils multilib

# We do this in global scope so ebuilds can get sane defaults just by
# inheriting.
if [[ -z ${WX_CONFIG} ]]; then
	if [[ -n ${WX_GTK_VER} ]]; then
		for wxtoolkit in mac gtk2 base; do
			# newer versions don't have a seperate debug profile
			for wxdebug in xxx release- debug-; do
				wxconf="${wxtoolkit}-unicode-${wxdebug/xxx/}${WX_GTK_VER}"

				[[ -f ${EPREFIX}/usr/$(get_libdir)/wx/config/${wxconf} ]] || continue

				WX_CONFIG="${EPREFIX}/usr/$(get_libdir)/wx/config/${wxconf}"
				WX_ECLASS_CONFIG="${WX_CONFIG}"
				break
			done
			[[ -n ${WX_CONFIG} ]] && break
		done
		[[ -n ${WX_CONFIG} ]] && export WX_CONFIG WX_ECLASS_CONFIG
	fi
fi

# @FUNCTION:    need-wxwidgets
# @USAGE:       <profile>
# @DESCRIPTION:
#
#  Available configurations are:
#
#    unicode       (USE="X")
#    base-unicode  (USE="-X")

need-wxwidgets() {
	local wxtoolkit wxdebug wxconf

	if [[ -z ${WX_GTK_VER} ]]; then
		eerror "WX_GTK_VER must be set before calling $FUNCNAME."
		echo
		die
	fi
	
	if [[ ${WX_GTK_VER} != 2.8 && ${WX_GTK_VER} != 2.9 && ${WX_GTK_VER} != 3.0 ]]; then
		eerror "Invalid WX_GTK_VER: ${WX_GTK_VER} - must be set to a valid wxGTK SLOT."
		echo
		die
	fi

	case $1 in
		unicode|base-unicode) ;;
		*)	eerror "Invalid $FUNCNAME profile: $1"
			echo
			die
			;;
	esac

	# wxbase is provided by both gtk2 and base installations
	if has_version "x11-libs/wxGTK:${WX_GTK_VER}[aqua]"; then
		wxtoolkit="mac"
	elif has_version "x11-libs/wxGTK:${WX_GTK_VER}[X]"; then
		wxtoolkit="gtk2"
	else
		wxtoolkit="base"
	fi

	# 2.8 has a separate debug element
	if [[ ${WX_GTK_VER} == 2.8 ]]; then
		if has_version "x11-libs/wxGTK:${WX_GTK_VER}[debug]"; then
			wxdebug="debug-"
		else
			wxdebug="release-"
		fi
	fi

	wxconf="${wxtoolkit}-unicode-${wxdebug}${WX_GTK_VER}"

	if [[ ! -f ${EPREFIX}/usr/$(get_libdir)/wx/config/${wxconf} ]]; then
		echo
		eerror "Failed to find configuration ${wxconf}"
		echo
		die
	fi

	export WX_CONFIG="${EPREFIX}/usr/$(get_libdir)/wx/config/${wxconf}"
	export WX_ECLASS_CONFIG="${WX_CONFIG}"

	echo
	einfo "Requested wxWidgets:        ${1} ${WX_GTK_VER}"
	einfo "Using wxWidgets:            ${wxconf}"
	echo
}
