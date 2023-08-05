# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

XORG_TARBALL_SUFFIX="xz"
inherit xorg-3

DESCRIPTION="window information utility for X"
KEYWORDS="amd64 ~arm arm64 ~hppa ~ia64 ~loong ~ppc ~ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	>=x11-libs/libxcb-1.6:=
	x11-libs/xcb-util-wm
	x11-libs/xcb-util-errors
"
DEPEND="${RDEPEND}
	x11-base/xorg-proto
	x11-libs/libX11"

XORG_CONFIGURE_OPTIONS=(
	--with-xcb-icccm
	--with-xcb-errors
)
