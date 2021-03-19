# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xorg-3

DESCRIPTION="X.Org driver for dummy cards"

KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux"
IUSE="dga"

RDEPEND="x11-base/xorg-server"
DEPEND="
	${RDEPEND}
	dga? ( x11-base/xorg-proto )"

src_configure() {
	local XORG_CONFIGURE_OPTIONS=(
		$(use_enable dga)
	)
	xorg-3_src_configure
}
