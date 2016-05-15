# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MOD_DESC="Editor's Choice Edition bonus pack"
MOD_NAME="Editor's Choice Edition"

inherit games games-mods

MY_P="ut2004megapack-linux.tar.bz2"
HOMEPAGE="http://www.unrealtournament2004.com/"
SRC_URI="mirror://3dgamers/unrealtourn2k4/Missions/${MY_P}
	http://0day.icculus.org/ut2004/${MY_P}
	ftp://ftp.games.skynet.be/pub/misc/${MY_P}
	http://sonic-lux.net/data/mirror/ut2004/${MY_P}
	http://unrealmassdestruction.com/downloads/ut2k4/essentials/UT2004-ONSBonusMapPack.zip"

LICENSE="ut2003"
KEYWORDS="amd64 x86"
IUSE=""

src_unpack() {
	unpack ${MY_P}
	cd UT2004MegaPack/Maps || die
	unpack UT2004-ONSBonusMapPack.zip # bug #278002
}

src_prepare() {
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
