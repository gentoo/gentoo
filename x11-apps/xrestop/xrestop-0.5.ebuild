# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

XORG_EAUTORECONF=yes
inherit xorg-3

DESCRIPTION="'Top' like statistics of X11 client's server side resource usage"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/xrestop"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ppc ~ppc64 sparc x86"

RDEPEND="
	sys-libs/ncurses:=
	x11-libs/libX11
	x11-libs/libXres
	x11-libs/libXt
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"
BDEPEND="virtual/pkgconfig"

DOCS=( ChangeLog )

PATCHES=(
	"${FILESDIR}"/${PN}-0.4-tinfo.patch
)
