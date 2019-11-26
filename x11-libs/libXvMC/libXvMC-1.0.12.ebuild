# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

XORG_MULTILIB=yes
inherit xorg-3

DESCRIPTION="X.Org XvMC library"

KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-solaris"
IUSE=""

RDEPEND="
	>=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}]
	>=x11-libs/libXext-1.3.2[${MULTILIB_USEDEP}]
	>=x11-libs/libXv-1.0.10[${MULTILIB_USEDEP}]
	!<x11-base/xorg-proto-2019.2"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
PDEPEND="app-eselect/eselect-xvmc"
