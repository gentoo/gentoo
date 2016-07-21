# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit eutils

DESCRIPTION="Free implementation of Impulse Tracker, a tool used to create high quality music"
HOMEPAGE="http://eval.sovietrussia.org//wiki/Schism_Tracker"
SRC_URI="http://${PN}.org/dl/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2 public-domain"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="media-libs/alsa-lib
	>=media-libs/libsdl-1.2[X]
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXv
	x11-libs/libXxf86misc"
DEPEND="${RDEPEND}
	virtual/os-headers
	x11-proto/kbproto
	x11-proto/xf86miscproto
	x11-proto/xproto"

DOCS="AUTHORS NEWS README TODO"

src_prepare() {
	default

	# workaround for temporary files (missing directory). Fixes:
	# sh ./scripts/build-font.sh . font/default-lower.fnt font/default-upper-alt.fnt font/default-upper-itf.fnt font/half-width.fnt >auto/default-font.c
	# /bin/sh: auto/default-font.c: No such file or directory
	mkdir auto

	#   sys-devel/binutils[multitarget] provides ${CHOST}-windres
	#   wine provides /usr/bin/windres
	# and schismtracker fails to use it properly:
	# sys/win32/schismres.rc:2:20: fatal error: winver.h: No such file or directory
	[[ ${CHOST} = *mingw32* ]] || export WINDRES= ac_cv_prog_WINDRES= ac_cv_prog_ac_ct_WINDRES=
}

src_install() {
	default

	domenu sys/fd.org/*.desktop
	doicon icons/schism{,-itf}-icon-128.png
}
