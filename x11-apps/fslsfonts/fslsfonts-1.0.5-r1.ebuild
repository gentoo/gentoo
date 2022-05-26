# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xorg-3

DESCRIPTION="list fonts served by X font server"

KEYWORDS="amd64 arm ~mips ppc ppc64 ~s390 sparc x86"

RDEPEND="x11-libs/libFS"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto"
