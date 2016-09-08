# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit vdr-plugin-2

MY_P=${PN}-cvs-${PV#*_pre}
S=${WORKDIR}/${MY_P#vdr-}

DESCRIPTION="VDR Plugin: DVD-Player"
HOMEPAGE="https://sourceforge.net/projects/dvdplugin"
SRC_URI="mirror://gentoo/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=media-video/vdr-1.6.0
	>=media-libs/libdvdnav-4.2.0
	>=media-libs/a52dec-0.7.4"
DEPEND="${RDEPEND}"

# vdr-plugin-2.eclass fix
KEEP_I18NOBJECT="yes"

PATCHES=(
	"${FILESDIR}"/${P}-compile_warnings.diff
	"${FILESDIR}"/${P}-fix-dvdnav-using-c++-keywords.patch
	)

src_prepare() {
	vdr-plugin-2_src_prepare

	if has_version ">=media-video/vdr-2.1.3"; then
		sed -i player-dvd.c -e "s:DeviceTrickSpeed(sp):DeviceTrickSpeed(sp,true):"
	fi
}
