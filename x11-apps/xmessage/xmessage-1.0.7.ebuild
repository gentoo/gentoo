# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xorg-3

DESCRIPTION="display a message or query in a window (X-based /bin/echo)"

KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

RDEPEND="
	x11-libs/libXaw
	x11-libs/libXt"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
