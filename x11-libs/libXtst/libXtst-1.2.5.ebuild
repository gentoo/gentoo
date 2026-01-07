# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

XORG_DOC=doc
XORG_MULTILIB=yes
inherit xorg-3

DESCRIPTION="X.Org Xlib-based client API for the XTEST & RECORD extensions library"

KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-solaris"

RDEPEND=">=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}]
	>=x11-libs/libXext-1.3.2[${MULTILIB_USEDEP}]
	>=x11-libs/libXi-1.7.2[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
