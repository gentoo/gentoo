# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xorg-3

DESCRIPTION="Utility to set XInput device parameters"

KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 ~sh sparc x86"
IUSE=""

RDEPEND=">=x11-libs/libX11-1.3
	x11-libs/libXext
	>=x11-libs/libXi-1.5.99.1
	x11-libs/libXinerama
	x11-libs/libXrandr"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
