# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

DESCRIPTION="UT2004 Megapack - Megapack bonus pack"
HOMEPAGE="https://liandri.beyondunreal.com/Unreal_Tournament_2004"
SRC_URI="https://unreal-archive-files-na.s3.ca-east-tor.io.cloud.ovh.net/managed/Unreal%20Tournament%202004/patches-updates/bonus-packs/ut2004megapack-linux.tar.bz2"
S="${WORKDIR}"

LICENSE="ut2003"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="bindist mirror"

src_prepare() {
	default

	mv -f UT2004MegaPack/* . || die
	rmdir UT2004MegaPack || die

	# Remove files in Megapack which are already installed
	rm -r Animations Speech Web || die

	rm Help/{ReadMePatch.int.txt,UT2004Logo.bmp} || die
	mv Help/BonusPackReadme.txt Help/MegapackReadme.txt || die

	rm Maps/ONS-{Adara,IslandHop,Tricky,Urban}.ut2 || die
	rm Sounds/{CicadaSnds,DistantBooms,ONSBPSounds}.uax || die
	rm StaticMeshes/{BenMesh02,BenTropicalSM01,HourAdara,ONS-BPJW1,PC_UrbanStatic}.usx || die

	# System
	rm System/{AL,AS-,B,b,C,D,E,F,G,I,L,O,o,S,s,U,V,W,X,x}* || die
	rm System/{ucc,ut2004}-bin || die
	rm System/{ucc,ut2004}-bin-linux-amd64 || die
	rm Textures/{AW-2k4XP,BenTex02,BenTropical01,BonusParticles,CicadaTex,Construction_S,HourAdaraTexor,jwfasterfiles,ONSBP_DestroyedVehicles,ONSBPTextures,PC_UrbanTex,UT2004ECEPlayerSkins}.utx || die
}

src_install() {
	insinto /opt/ut2004
	doins -r Help Maps Music Sounds StaticMeshes System Textures

	dosym ut2004 /opt/ut2004-ded
}
