# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit xorg-2

DESCRIPTION="dump an image of an X window"

KEYWORDS="~alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 ~s390 sparc x86"
IUSE=""

# libXt dependency is not in configure.ac, bug #408629, upstream #47462."
RDEPEND="x11-libs/libX11"
DEPEND="${RDEPEND}
	x11-base/xorg-proto
	x11-libs/libXt
	x11-libs/libxkbfile"
