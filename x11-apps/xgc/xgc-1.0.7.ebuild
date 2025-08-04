# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xorg-3

DESCRIPTION="X graphics demo"

KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"

RDEPEND="
	x11-libs/libXaw
	x11-libs/libXt"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
