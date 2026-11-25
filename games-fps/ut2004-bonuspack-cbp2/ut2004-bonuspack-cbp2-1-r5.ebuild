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
KEYWORDS="~amd64 ~arm64"
RESTRICT="bindist mirror strip"

BDEPEND="
	app-arch/unzip
	>=games-fps/ut2004-3374_pre23
"
RDEPEND="
	games-fps/ut2004-data
	games-fps/ut2004-bonuspack-cbp1
"

src_prepare() {
	default

	# In ut2004-bonuspack-cbp1.
	rm -v Music/Soeren.ogg || die

	# In ut2004-data with Mega Pack.
	rm -v Textures/Ty_RocketTextures.utx || die

	cd Help || die
	rm -v CBP2InstallerLogoP1.bmp Note.txt || die
	mv -v Readme.txt CBP2-Readme.txt || die
	mv -v GERROIDREADME.txt DOM-CBP2-Gerroid.txt || die
	mv -v ons-cbp2-valarna.txt ONS-CBP2-Valarna.txt || die
	mv -v Tydal.txt DM-CBP2-Tydal.txt || die
}

src_compile() {
	ut2004-ucc exportcache -mod=Gentoo System/*.u Maps/*.ut2 || die
}

src_install() {
	insinto /opt/ut2004
	doins -r *
}
