# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xorg-3

DESCRIPTION="analog / digital clock for X"

KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"

RDEPEND="x11-libs/libX11
	x11-libs/libXmu
	x11-libs/libXrender
	x11-libs/libXft
	x11-libs/libxkbfile
	x11-libs/libXaw"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
