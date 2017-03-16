# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

XORG_MULTILIB=yes
inherit xorg-2

DESCRIPTION="X Present Extension C Library"

KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	x11-libs/libX11[${MULTILIB_USEDEP}]
	x11-libs/libXext[${MULTILIB_USEDEP}]
	x11-libs/libXfixes[${MULTILIB_USEDEP}]
	x11-libs/libXrandr[${MULTILIB_USEDEP}]
	x11-proto/presentproto[${MULTILIB_USEDEP}]
	x11-proto/xextproto[${MULTILIB_USEDEP}]
	x11-proto/xproto[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${P}-add-depends-to-pkgconfig.patch )
