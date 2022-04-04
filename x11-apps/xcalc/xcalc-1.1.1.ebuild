# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

XORG_TARBALL_SUFFIX="xz"
inherit xorg-3

DESCRIPTION="scientific calculator for X"

KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~sparc-solaris ~x86-solaris"

RDEPEND="x11-libs/libXaw
	x11-libs/libXt
	x11-libs/libX11"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
