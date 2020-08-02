# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit leechcraft

DESCRIPTION="AnHero, crash handler for LeechCraft"

SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND="~app-leechcraft/lc-core-${PV}"
RDEPEND="${DEPEND}
	sys-devel/gdb
"

src_configure() {
	local mycmakeargs=(
		-DSKIP_MAN_COMPRESS=True
	)
	cmake_src_configure
}
