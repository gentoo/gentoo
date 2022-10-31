# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xorg-3

DESCRIPTION="X rendering operation stress test utility"
SRC_URI="https://xorg.freedesktop.org/archive/individual/test/${P}.tar.xz"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="x11-libs/libX11
	x11-libs/libXmu
	x11-libs/libXft
	x11-libs/libXrender
	x11-libs/libXext"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
