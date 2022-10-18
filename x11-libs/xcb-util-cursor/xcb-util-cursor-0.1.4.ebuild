# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

XORG_MULTILIB=yes
XORG_TARBALL_SUFFIX="xz"
inherit xorg-3

DESCRIPTION="X C-language Bindings sample implementations"
HOMEPAGE="https://xcb.freedesktop.org/ https://gitlab.freedesktop.org/xorg/lib/libxcb-cursor"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x64-solaris"

RDEPEND=">=x11-libs/libxcb-1.9.1:=[${MULTILIB_USEDEP}]
	>=x11-libs/xcb-util-image-0.3.9-r1[${MULTILIB_USEDEP}]
	>=x11-libs/xcb-util-renderutil-0.3.9[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	>=x11-base/xcb-proto-1.8-r3:=
	x11-base/xorg-proto"
BDEPEND=">=dev-util/gperf-3.0.1"

XORG_CONFIGURE_OPTIONS=(
	--with-cursorpath='~/.cursors:~/.icons:/usr/local/share/cursors/xorg-x11:/usr/local/share/cursors:/usr/local/share/icons:/usr/local/share/pixmaps:/usr/share/cursors/xorg-x11:/usr/share/cursors:/usr/share/pixmaps/xorg-x11:/usr/share/icons:/usr/share/pixmaps'
)
