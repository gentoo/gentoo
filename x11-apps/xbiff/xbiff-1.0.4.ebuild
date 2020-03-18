# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xorg-3

DESCRIPTION="mailbox flag for X"

KEYWORDS="amd64 arm hppa ~mips ppc ppc64 s390 ~sh sparc x86"
IUSE=""

RDEPEND="x11-libs/libXaw
	x11-libs/libXmu
	x11-libs/libX11
	x11-misc/xbitmaps
	x11-libs/libXext"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
