# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

XORG_MULTILIB=yes
inherit xorg-3

DESCRIPTION="X.Org Xdamage library"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-solaris"

RDEPEND=">=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	>=x11-libs/libXfixes-5.0.1[${MULTILIB_USEDEP}]
	x11-base/xorg-proto"
