# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

XORG_MULTILIB=yes
inherit xorg-3

DESCRIPTION="X C-language Bindings sample implementations"
HOMEPAGE="https://xcb.freedesktop.org/ https://gitlab.freedesktop.org/xorg/lib/libxcb-util"

KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x64-solaris"

RDEPEND=">=x11-libs/libxcb-1.9.1:=[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

PDEPEND="
	>=x11-libs/xcb-util-cursor-0.1.1:=[${MULTILIB_USEDEP}]
	>=x11-libs/xcb-util-image-${PV}:=[${MULTILIB_USEDEP}]
	>=x11-libs/xcb-util-keysyms-${PV}:=[${MULTILIB_USEDEP}]
	>=x11-libs/xcb-util-renderutil-0.3.9:=[${MULTILIB_USEDEP}]
	>=x11-libs/xcb-util-wm-${PV}:=[${MULTILIB_USEDEP}]
"
