# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xorg-3

DESCRIPTION="Controls the keyboard layout of a running X server"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"

COMMON_DEPEND="
	x11-libs/libxkbfile
	x11-libs/libX11
	x11-libs/libXrandr"
DEPEND="${COMMON_DEPEND}
	x11-base/xorg-proto"
RDEPEND="${COMMON_DEPEND}
	x11-misc/xkeyboard-config"
