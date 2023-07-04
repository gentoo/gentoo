# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

XORG_TARBALL_SUFFIX="xz"
inherit xorg-3

DESCRIPTION="'Top' like statistics of X11 client's server side resource usage"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/xrestop"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm64 ~hppa ppc ppc64 sparc x86"

RDEPEND="
	sys-libs/ncurses:=
	x11-libs/libX11
	x11-libs/libXres
	x11-libs/libXext
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"
BDEPEND="virtual/pkgconfig"
