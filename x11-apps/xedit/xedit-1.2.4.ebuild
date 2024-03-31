# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

XORG_TARBALL_SUFFIX="xz"
inherit xorg-3

DESCRIPTION="simple text editor for X"

KEYWORDS="~amd64 ~arm64 ~hppa ~mips ~ppc ~ppc64 ~sparc ~x86"

RDEPEND="
	x11-libs/libXaw
	x11-libs/libXt
	x11-libs/libXmu
	x11-libs/libX11"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
