# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

XORG_TARBALL_SUFFIX="xz"
inherit xorg-3

DESCRIPTION="Controls the keyboard layout of a running X server"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"

COMMON_DEPEND="
	x11-libs/libxkbfile
	x11-libs/libX11
	x11-libs/libXrandr"
DEPEND="${COMMON_DEPEND}
	x11-base/xorg-proto"
RDEPEND="${COMMON_DEPEND}
	x11-misc/xkeyboard-config"
