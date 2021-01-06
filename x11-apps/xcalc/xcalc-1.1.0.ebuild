# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xorg-3

DESCRIPTION="scientific calculator for X"

KEYWORDS="amd64 arm ~arm64 ~hppa ~mips ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux ~sparc-solaris ~x86-solaris"
IUSE=""

RDEPEND="x11-libs/libXaw
	x11-libs/libXt
	x11-libs/libX11"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
