# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit xorg-3

DESCRIPTION="video driver for framebuffer device"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"

DEPEND="x11-base/xorg-proto"
RDEPEND="${DEPEND}
	x11-base/xorg-server"
