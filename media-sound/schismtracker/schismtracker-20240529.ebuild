# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop xdg

DESCRIPTION="Free implementation of Impulse Tracker, a tool used to create high quality music"
HOMEPAGE="http://schismtracker.org/"
SRC_URI="https://github.com/schismtracker/schismtracker/releases/download/${PV}/${P}.source.tar.gz"

LICENSE="GPL-2 LGPL-2 public-domain"
SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="
	>=media-libs/libsdl2-2.0.5[X]
	x11-libs/libX11
	x11-libs/libXv
"
DEPEND="${RDEPEND}
	virtual/os-headers
	x11-base/xorg-proto
"

src_prepare() {
	default

	# workaround for temporary files (missing directory). Fixes:
	# sh ./scripts/build-font.sh . font/default-lower.fnt font/default-upper-alt.fnt \
	#	font/default-upper-itf.fnt font/half-width.fnt >auto/default-font.c
	# /bin/sh: auto/default-font.c: No such file or directory
	mkdir auto || die

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
