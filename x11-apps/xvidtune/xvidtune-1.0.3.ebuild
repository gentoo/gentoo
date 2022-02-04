# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xorg-3

DESCRIPTION="video mode tuner for Xorg"

KEYWORDS="~alpha amd64 arm ~hppa ~mips ppc ppc64 ~s390 sparc x86"

RDEPEND="
	x11-libs/libXaw
	x11-libs/libXmu
	x11-libs/libX11
	x11-libs/libXt
	x11-libs/libXxf86vm"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto"
