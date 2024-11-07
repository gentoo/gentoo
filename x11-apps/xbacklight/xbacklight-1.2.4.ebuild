# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
XORG_TARBALL_SUFFIX="xz"
inherit xorg-3

DESCRIPTION="Sets backlight level using the RandR 1.2 BACKLIGHT output property"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"

RDEPEND="x11-libs/libxcb
	>=x11-libs/xcb-util-0.3.8"
DEPEND="${RDEPEND}"
