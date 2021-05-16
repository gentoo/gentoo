# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xorg-3

DESCRIPTION="X.Org dmx library"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	x11-base/xorg-proto
	x11-libs/libX11
	x11-libs/libXext"
DEPEND="${RDEPEND}"
