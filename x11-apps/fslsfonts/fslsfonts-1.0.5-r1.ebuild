# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit xorg-2

DESCRIPTION="list fonts served by X font server"
KEYWORDS="amd64 arm ~mips ppc ppc64 ~s390 ~sh sparc x86"
IUSE=""

RDEPEND="x11-libs/libFS"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
