# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="UT2003 Community Bonus Pack for UT2004 Volume 1"
HOMEPAGE="https://liandri.beyondunreal.com/Unreal_Tournament_2004"
SRC_URI="https://ut2004.ut-files.com/BonusPacks/cbp1.zip"
LICENSE="free-noncomm"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="strip"

BDEPEND="app-arch/unzip"
RDEPEND="|| ( games-fps/ut2004 >=games-server/ut2004-ded-3369.3-r2 )"

S="${WORKDIR}"

src_install() {
	insinto /opt/ut2004
	doins -r *
}
