# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

DESCRIPTION="UT2004 Community Bonus Pack Volume 1"
HOMEPAGE="https://liandri.beyondunreal.com/Unreal_Tournament_2004"
SRC_URI="https://unrealmassdestruction.com/downloads/ut2k4/essentials/cbp1.zip"
S="${WORKDIR}"

LICENSE="free-noncomm"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
RESTRICT="strip"

BDEPEND="
	app-arch/unzip
	>=games-fps/ut2004-3374_pre23
"
RDEPEND="
	games-fps/ut2004-data
"

src_compile() {
	ut2004-ucc exportcache -mod=Gentoo Maps/*.ut2 || die
}

src_install() {
	insinto /opt/ut2004
	doins -r *
}
