# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

DESCRIPTION="UT2004 Community Bonus Pack 2 Volume 1 and 2"
HOMEPAGE="https://liandri.beyondunreal.com/Unreal_Tournament_2004"
SRC_URI="
	https://unrealmassdestruction.com/downloads/ut2k4/essentials/cbp2-volume1_zip.zip
	https://unrealmassdestruction.com/downloads/ut2k4/essentials/cbp2-volume2_zip.zip
"
S="${WORKDIR}"

LICENSE="free-noncomm all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror bindist strip"

BDEPEND="app-arch/unzip"
RDEPEND="|| ( games-fps/ut2004 >=games-server/ut2004-ded-3369.3-r2 )
	games-fps/ut2004-bonuspack-cbp1
	games-fps/ut2004-bonuspack-mega"

src_prepare() {
	default

	# In ut2004-bonuspack-cbp1.
	rm Music/Soeren.ogg || die

	# In ut2004-bonuspack-mega.
	rm Textures/Ty_RocketTextures.utx || die

	# Useless file.
	rm Help/Note.txt || die

	cd Help || die
	mv Readme.txt CBP2-Readme.txt || die
	mv GERROIDREADME.txt DOM-CBP2-Gerroid.txt || die
	mv Tydal.txt DM-CBP2-Tydal.txt || die
}

src_install() {
	insinto /opt/ut2004
	doins -r *
}
