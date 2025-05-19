# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xorg-meson

DESCRIPTION="font dumper for X font server"

KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"

RDEPEND="x11-libs/libFS"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
