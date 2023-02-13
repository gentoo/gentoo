# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

XORG_TARBALL_SUFFIX="xz"
inherit xorg-3

DESCRIPTION="X standard colormap utility"
KEYWORDS="amd64 arm ~arm64 ~hppa ~mips ppc ppc64 ~s390 ~sparc x86"

RDEPEND="x11-libs/libXmu
	x11-libs/libX11"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
