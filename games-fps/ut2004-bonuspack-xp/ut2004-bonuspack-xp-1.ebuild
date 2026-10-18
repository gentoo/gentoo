# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

DESCRIPTION="UT2004 XP Bonus Maps"
HOMEPAGE="https://liandri.beyondunreal.com/Unreal_Tournament_2004"
SRC_URI="http://unrealmassdestruction.com/downloads/ut2k4/essentials/UT2004-ONSBonusMapPack.zip"
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
	!games-fps/ut2004-bonuspack-ece
"

src_unpack() {
	mkdir Maps || die
	cd Maps || die
	default
}

src_compile() {
	ut2004-ucc exportcache -mod=Gentoo Maps/*.ut2 || die
	# The base game already knows about these maps, so it writes the cache to a
	# single file rather than separate ones. We must rename to avoid a conflict.
	mv -v System/{CacheRecords,${PN}}.ucl || die
}

src_install() {
	insinto /opt/ut2004
	doins -r *
}
