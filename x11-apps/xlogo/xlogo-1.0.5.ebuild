# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xorg-3

DESCRIPTION="X Window System logo"

KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 ~sh sparc x86"
IUSE=""

RDEPEND="x11-libs/libXrender
	x11-libs/libXext
	x11-libs/libXt
	x11-libs/libXft
	x11-libs/libXaw
	x11-libs/libSM
	x11-libs/libXmu
	x11-libs/libX11"
DEPEND="${RDEPEND}"

XORG_CONFIGURE_OPTIONS="--with-render"
