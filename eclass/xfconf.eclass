# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# @DEAD
# Removal on 2019-06-02.

# @ECLASS: xfconf.eclass
# @MAINTAINER:
# XFCE maintainers <xfce@gentoo.org>
# @SUPPORTED_EAPIS: 5
# @BLURB: Default XFCE ebuild layout
# @DESCRIPTION:
# Default XFCE ebuild layout

# @ECLASS-VARIABLE: EAUTORECONF
# @DESCRIPTION:
# Run eautoreconf instead of elibtoolize if the variable is set

if [[ -n ${EAUTORECONF} ]] ; then
	AUTOTOOLS_AUTO_DEPEND=yes
else
	: ${AUTOTOOLS_AUTO_DEPEND:=no}
fi

# @ECLASS-VARIABLE: XFCONF
# @DESCRIPTION:
# This should be an array defining arguments for econf

unset _xfconf_live
[[ $PV == *9999* ]] && _xfconf_live=git-2

inherit ${_xfconf_live} autotools eutils gnome2-utils libtool xdg-utils

EGIT_BOOTSTRAP=autogen.sh
EGIT_REPO_URI="git://git.xfce.org/xfce/${MY_PN:-${PN}}"

_xfconf_deps=""
_xfconf_m4=">=dev-util/xfce4-dev-tools-4.10"

[[ -n $_xfconf_live ]] && _xfconf_deps+=" dev-util/gtk-doc ${_xfconf_m4}"
[[ -n $EAUTORECONF ]] && _xfconf_deps+=" ${_xfconf_m4}"

RDEPEND=""
DEPEND="${_xfconf_deps}"

unset _xfconf_deps
unset _xfconf_m4

case ${EAPI:-0} in
	5) ;;
	*) die "Unknown EAPI." ;;
esac

[[ -n $_xfconf_live ]] && _xfconf_live=src_unpack

EXPORT_FUNCTIONS ${_xfconf_live} src_prepare src_configure src_install pkg_preinst pkg_postinst pkg_postrm

# @FUNCTION: xfconf_use_debug
# @DESCRIPTION:
# If IUSE has debug, return --enable-debug=minimum.
# If USE debug is enabled, return --enable-debug which is the same as --enable-debug=yes.
# If USE debug is enabled and the XFCONF_FULL_DEBUG variable is set, return --enable-debug=full.
xfconf_use_debug() {
	if has debug ${IUSE}; then
		if use debug; then
			if [[ -n $XFCONF_FULL_DEBUG ]]; then
				echo "--enable-debug=full"
			else
				echo "--enable-debug"
			fi
		else
			echo "--enable-debug=minimum"
		fi
	else
		ewarn "${FUNCNAME} called without debug in IUSE"
	fi
}

# @FUNCTION: xfconf_src_unpack
# @DESCRIPTION:
# Run git-2_src_unpack if required
xfconf_src_unpack() {
	NOCONFIGURE=1 git-2_src_unpack
}

# @FUNCTION: xfconf_src_prepare
# @DESCRIPTION:
# Process PATCHES with epatch and run epatch_user followed by run of
# elibtoolize, or eautoreconf if EAUTORECONF is set.
xfconf_src_prepare() {
	debug-print-function ${FUNCNAME} "$@"

	[[ ${PATCHES[@]} ]] && epatch "${PATCHES[@]}"
	epatch_user

	if [[ -n $EAUTORECONF ]]; then
		AT_M4DIR=${EPREFIX}/usr/share/xfce4/dev-tools/m4macros eautoreconf
	else
		elibtoolize
	fi
}

# @FUNCTION: xfconf_src_configure
# @DESCRIPTION:
# Run econf with opts from the XFCONF array
xfconf_src_configure() {
	debug-print-function ${FUNCNAME} "$@"
	[[ -n $_xfconf_live ]] && XFCONF+=( --enable-maintainer-mode )
	econf "${XFCONF[@]}"
}

# @FUNCTION: xfconf_src_install
# @DESCRIPTION:
# Run emake install to DESTDIR, einstalldocs to process DOCS and
# prune_libtool_files --all to always remove libtool files (.la)
xfconf_src_install() {
	debug-print-function ${FUNCNAME} "$@"

	# FIXME
	if [[ -n $_xfconf_live ]] && ! [[ -e ChangeLog ]]; then
		touch ChangeLog
	fi

	emake DESTDIR="${D}" "$@" install

	einstalldocs

	prune_libtool_files --all
}

# @FUNCTION: xfconf_pkg_preinst
# @DESCRIPTION:
# Run gnome2_icon_savelist
xfconf_pkg_preinst() {
	debug-print-function ${FUNCNAME} "$@"
	gnome2_icon_savelist
}

# @FUNCTION: xfconf_pkg_postinst
# @DESCRIPTION:
# Run xdg_{desktop,mimeinfo}_database_update and gnome2_icon_cache_update
xfconf_pkg_postinst() {
	debug-print-function ${FUNCNAME} "$@"
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	if [[ -n ${GNOME2_ECLASS_ICONS} ]]; then
		gnome2_icon_cache_update
	fi
}

# @FUNCTION: xfconf_pkg_postrm
# @DESCRIPTION:
# Run xdg_{desktop,mimeinfo}_database_update and gnome2_icon_cache_update
xfconf_pkg_postrm() {
	debug-print-function ${FUNCNAME} "$@"
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	if [[ -n ${GNOME2_ECLASS_ICONS} ]]; then
		gnome2_icon_cache_update
	fi
}
