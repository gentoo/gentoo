# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A nice digital clock with 7 different styles either in LCD or LED style"
HOMEPAGE="https://www.dockapps.net/wmclockmon"
SRC_URI="https://www.dockapps.net/download/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 ~sparc x86"

RDEPEND="x11-libs/gtk+:3
	x11-libs/libXext
	x11-libs/libX11
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-base/xorg-proto
	x11-libs/libXt"
BDEPEND="virtual/pkgconfig"
