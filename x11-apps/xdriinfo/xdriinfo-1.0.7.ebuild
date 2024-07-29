# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

XORG_TARBALL_SUFFIX="xz"
inherit xorg-3

DESCRIPTION="query configuration information of DRI drivers"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv sparc x86"

RDEPEND="
	x11-libs/libX11
	virtual/opengl"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
