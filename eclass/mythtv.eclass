# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: mythtv.eclass
# @MAINTAINER:
# Doug Goldstein <cardoe@gentoo.org>
# @AUTHOR:
# Doug Goldstein <cardoe@gentoo.org>
# @BLURB: Downloads the MythTV source packages and any patches from the fixes branch

inherit versionator

# temporary until all the packagers are fixed for bug #283798
DEPEND="app-arch/unzip"

# Release version
MY_PV="${PV%_*}"

# what product do we want
case "${PN}" in
	       mythtv) MY_PN="mythtv";;
	mythtv-themes) MY_PN="myththemes";;
	mythtv-themes-extra) MY_PN="themes";;
	            *) MY_PN="mythplugins";;
esac

# _pre is from SVN trunk while _p and _beta are from SVN ${MY_PV}-fixes
# TODO: probably ought to do something smart if the regex doesn't match anything
[[ "${PV}" =~ (_alpha|_beta|_pre|_rc|_p)([0-9]+) ]] || {
	eerror "Invalid version requested (_alpha|_beta|_pre|_rc|_p) only"
	exit 1
}

REV_PREFIX="${BASH_REMATCH[1]}" # _alpha, _beta, _pre, _rc, or _p
MYTHTV_REV="${BASH_REMATCH[2]}" # revision number

case $REV_PREFIX in
	_pre|_alpha) MYTHTV_REPO="trunk";;
	_p|_beta|_rc) VER_COMP=( $(get_version_components ${MY_PV}) )
	          FIXES_VER="${VER_COMP[0]}-${VER_COMP[1]}"
	          MYTHTV_REPO="branches/release-${FIXES_VER}-fixes";;
esac

HOMEPAGE="http://www.mythtv.org"
LICENSE="GPL-2"
SRC_URI="http://svn.mythtv.org/trac/changeset/${MYTHTV_REV}/${MYTHTV_REPO}/${MY_PN}?old_path=%2F&format=zip -> ${MY_PN}-${PV}.zip"
S="${WORKDIR}/${MYTHTV_REPO}/${MY_PN}"
