# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: wxwidgets.eclass
# @MAINTAINER:
# wxwidgets@gentoo.org
# @SUPPORTED_EAPIS: 0 1 2 3 4 5 6
# @BLURB: Manages build configuration for wxGTK-using packages.
# @DESCRIPTION:
#  This eclass sets up the proper environment for ebuilds using the wxGTK
#  libraries.  Ebuilds using wxPython do not need to inherit this eclass.
#
#  More specifically, this eclass controls the configuration chosen by the
#  /usr/bin/wx-config wrapper.
#
#  Using the eclass is simple:
#
#    - set WX_GTK_VER equal to a SLOT of wxGTK
#    - call setup-wxwidgets()
#
#  The configuration chosen is based on the version required and the flags
#  wxGTK was built with.

if [[ -z ${_WXWIDGETS_ECLASS} ]]; then

case ${EAPI} in
	0|1|2|3|4|5)
		inherit eutils flag-o-matic multilib

		# This was used to set up a sane default for ebuilds so they could
		# avoid calling need-wxwidgets if they didn't need a particular build.
		# This was a bad idea for a couple different reasons, and because
		# get_libdir() is now illegal in global scope in EAPI 6 we can't do it
		# anymore.  All ebuilds must now use setup-wxwidgets and this code is
		# only here for backwards compatability.
		if [[ -z ${WX_CONFIG} ]]; then
			if [[ -n ${WX_GTK_VER} ]]; then
				for _wxtoolkit in mac gtk2 base; do
					# newer versions don't have a seperate debug config
					for _wxdebug in xxx release- debug-; do
						_wxconf="${_wxtoolkit}-unicode-${_wxdebug/xxx/}${WX_GTK_VER}"

						[[ -f ${EPREFIX}/usr/$(get_libdir)/wx/config/${_wxconf} ]] \
							|| continue

						WX_CONFIG="${EPREFIX}/usr/$(get_libdir)/wx/config/${_wxconf}"
						WX_ECLASS_CONFIG="${WX_CONFIG}"
						break
					done
					[[ -n ${WX_CONFIG} ]] && break
				done
				[[ -n ${WX_CONFIG} ]] && export WX_CONFIG WX_ECLASS_CONFIG
			fi
		fi
		unset _wxtoolkit
		unset _wxdebug
		unset _wxconf
		;;
	6)
		inherit flag-o-matic multilib
		;;
	*)
		die "EAPI=${EAPI:-0} is not supported"
		;;
esac

# @FUNCTION:    setup-wxwidgets
# @DESCRIPTION:
#
#  Call this in your ebuild to set up the environment for wxGTK.  Besides
#  controlling the wx-config wrapper this exports WX_CONFIG containing
#  the path to the config in case it needs to be passed to a build system.
#
#  In wxGTK-2.9 and later it also controls the level of debugging output
#  from the libraries.  In these versions debugging features are enabled
#  by default and need to be disabled at the package level.  Because this
#  causes many warning dialogs to pop up during runtime we add -DNDEBUG to
#  CPPFLAGS to disable debugging features (unless your ebuild has a debug
#  USE flag and it's enabled).  If you don't like this behavior you can set
#  WX_DISABLE_NDEBUG to override it.
#
#  See: http://docs.wxwidgets.org/trunk/overview_debugging.html

setup-wxwidgets() {
	local wxtoolkit wxdebug wxconf

	[[ -z ${WX_GTK_VER} ]] \
		&& die "WX_GTK_VER must be set before calling $FUNCNAME."

	case "${WX_GTK_VER}" in
		3.0-gtk3|3.1-gtk3)
			wxtoolkit=gtk3
			if [[ -z ${WX_DISABLE_NDEBUG} ]]; then
				( in_iuse debug && use debug ) || append-cppflags -DNDEBUG
			fi
			;;
		2.9|3.0)
			wxtoolkit=gtk2
			if [[ -z ${WX_DISABLE_NDEBUG} ]]; then
				( in_iuse debug && use debug ) || append-cppflags -DNDEBUG
			fi
			;;
		2.8)
			wxtoolkit=gtk2
			wxdebug="release-"
			has_version x11-libs/wxGTK:${WX_GTK_VER}[debug] && wxdebug="debug-"
			;;
		*)
			die "Invalid WX_GTK_VER: must be set to a valid wxGTK SLOT"
			;;
	esac

	# toolkit overrides
	if has_version "x11-libs/wxGTK:${WX_GTK_VER}[aqua]"; then
		wxtoolkit="mac"
	elif ! has_version "x11-libs/wxGTK:${WX_GTK_VER}[X]"; then
		wxtoolkit="base"
	fi

	wxconf="${wxtoolkit}-unicode-${wxdebug}${WX_GTK_VER}"

	[[ ! -f ${EPREFIX}/usr/$(get_libdir)/wx/config/${wxconf} ]] \
		&& die "Failed to find configuration ${wxconf}"

	export WX_CONFIG="${EPREFIX}/usr/$(get_libdir)/wx/config/${wxconf}"
	export WX_ECLASS_CONFIG="${WX_CONFIG}"

	echo
	einfo "Requested wxWidgets:        ${WX_GTK_VER}"
	einfo "Using wxWidgets:            ${wxconf}"
	echo
}

# deprecated
need-wxwidgets() {
	setup-wxwidgets
}

_WXWIDGETS_ECLASS=1
fi
