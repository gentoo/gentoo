# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit xorg-2

DESCRIPTION="Alter a monitor's gamma correction through the X server"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

RDEPEND="x11-libs/libXxf86vm
	x11-libs/libX11"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
