# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="ut2004megapack-linux.tar.bz2"

DESCRIPTION="UT2004 Editor's Choice Edition - Editor's Choice Edition bonus pack"
HOMEPAGE="http://www.unrealtournament2004.com/"
SRC_URI="
	http://ut2004.ut-files.com/BonusPacks/${MY_P}
	http://unrealmassdestruction.com/downloads/ut2k4/essentials/UT2004-ONSBonusMapPack.zip"

LICENSE="ut2003"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="app-arch/unzip"

S="${WORKDIR}"

src_unpack() {
	unpack "${MY_P}"

	cd UT2004MegaPack/Maps || die
	unpack UT2004-ONSBonusMapPack.zip # bug #278002
}

src_prepare() {
	default

	mv -f UT2004MegaPack/* . || die
	rmdir UT2004MegaPack || die

	rm -r Music Speech || die

	# Remove megapack files which are not in ece
	rm Animations/ONSNewTank-A.ukx || die
	rm Help/ReadMePatch.int.txt || die
	# Help/{DebuggerLogo.bmp,InstallerLogo.bmp,Unreal.ico,UnrealEd.ico}
	# are not in megapack.
	# Keep new Help/UT2004Logo.bmp
	# Manual dir does not exist in megapack
	rm Maps/{AS*,CTF*,DM*} || die
	rm Sounds/A_Announcer_BP2.uax || die
	rm StaticMeshes/{JumpShipObjects.usx,Ty_RocketSMeshes.usx} || die
	rm System/{A*,b*,B*,CacheRecords.ucl} || die
	rm System/{*.det,*.est,*.frt,*.itt,*.kot} || die
	rm System/{CTF*,D*,Editor*,G*,I*,L*,Onslaught.*,*.md5} || die
	rm System/{u*,U*,V*,X*,Core.u,Engine.u,F*,*.ucl,Sk*} || die
	rm Textures/{J*,j*,T*} || die
	rm -r Web || die

	# The file lists of ut2004-3369-r1 and -r2 are identical
	# Remove files owned by ut2004-3369-r2
	rm Help/UT2004Logo.bmp || die
	# The 2 Manifest files have not changed
	rm System/{Manifest.in{i,t},OnslaughtFull.int} || die
	rm System/{Core.int,Engine.int,Setup.int,Window.int} || die
	rm System/{OnslaughtFull.u,OnslaughtBP.u} || die
}

src_install() {
	insinto /opt/ut2004
	doins -r Animations Help Maps Sounds StaticMeshes System Textures

	dosym ut2004 /opt/ut2004-ded
}
