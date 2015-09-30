# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit games

BONUSPACK_P="dedicatedserver3339-bonuspack.zip"
PATCH_P="ut2004-lnxpatch${PV%.*}-2.tar.bz2"
DESCRIPTION="Unreal Tournament 2004 Linux Dedicated Server"
HOMEPAGE="http://www.unrealtournament.com/"
SRC_URI="mirror://3dgamers/unrealtourn2k4/${BONUSPACK_P}
	http://files.chaoticdreams.org/UT2004/DedicatedServer3339-BonusPack.zip -> ${BONUSPACK_P}
	http://downloads.unrealadmin.org/UT2004/Server/${BONUSPACK_P}
	http://sonic-lux.net/data/mirror/ut2004/${BONUSPACK_P}
	mirror://3dgamers/unrealtourn2k4/${PATCH_P}
	http://downloads.unrealadmin.org/UT2004/Patches/Linux/${PATCH_P}
	http://sonic-lux.net/data/mirror/ut2004/${PATCH_P}
	mirror://gentoo/ut2004-v${PV/./-}-linux-dedicated.7z"

LICENSE="ut2003"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
RESTRICT="mirror strip"

DEPEND="app-arch/unzip
	app-arch/p7zip"
RDEPEND="sys-libs/glibc
	!games-fps/ut2004[dedicated]
	games-fps/ut2004-bonuspack-ece
	games-fps/ut2004-bonuspack-mega"

S=${WORKDIR}

dir=${GAMES_PREFIX_OPT}/${PN}

src_prepare() {
	cp -rf UT2004-Patch/* . || die
	rm -rf System/{ucc-bin*,ut2004-bin*,*.dll,*.exe} UT2004-Patch
	if use amd64 ; then
		mv -f ut2004-ucc-bin-09192008/ucc-bin-linux-amd64 System/ucc-bin || die
	else
		mv -f ut2004-ucc-bin-09192008/ucc-bin System/ || die
	fi
	rm -rf ut2004-ucc-bin-09192008
	# Owned by ut2004-bonuspack-ece
	rm -f Animations/{MetalGuardAnim,ONSBPAnimations,NecrisAnim,MechaSkaarjAnims}.ukx
	rm -f Help/BonusPackReadme.txt
	rm -f Maps/{ONS-Adara,ONS-IslandHop,ONS-Tricky,ONS-Urban}.ut2
	rm -f Sounds/{CicadaSnds,DistantBooms,ONSBPSounds}.uax
	rm -f StaticMeshes/{HourAdara,BenMesh02,BenTropicalSM01,ONS-BPJW1,PC_UrbanStatic}.usx
	rm -f System/{ONS-IslandHop,ONS-Tricky,ONS-Adara,ONS-Urban,OnslaughtBP}.int
	rm -f System/xaplayersl3.upl
	rm -f Textures/{ONSBPTextures,BonusParticles,HourAdaraTexor,BenTex02,BenTropical01,PC_UrbanTex,AW-2k4XP,ONSBP_DestroyedVehicles,UT2004ECEPlayerSkins,CicadaTex,Construction_S}.utx
	# Owned by ut2004-bonuspack-mega
	rm -f System/{Manifest.ini,Manifest.int,Packages.md5}
}

src_install() {
	einfo "This will take a while... go get a pizza or something"

	games_make_wrapper ${PN} "./ucc-bin server" "${dir}"/System

	insinto "${dir}"
	doins -r *
	fperms +x "${dir}"/System/ucc-bin

	sed \
		-e "s:@USER@:${GAMES_USER_DED}:" \
		-e "s:@GROUP@:${GAMES_GROUP}:" \
		-e "s:@HOME@:${GAMES_PREFIX}:" \
		"${FILESDIR}"/${PN}.confd > "${T}"/${PN}.confd || die
	newconfd "${T}"/${PN}.confd ${PN}

	sed \
		-e "s:@DIR@:${GAMES_BINDIR}:g" \
		"${FILESDIR}"/${PN}.initd > "${T}"/${PN}.initd || die
	newinitd "${T}"/${PN}.initd ${PN}

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	ewarn "You should take the time to edit the default server INI."
	ewarn "Consult the INI Reference at http://www.unrealadmin.org/"
	ewarn "for assistance in adjusting the following file:"
	ewarn "${dir}/System/Default.ini"
	ewarn
	ewarn "To have your server authenticate properly to the"
	ewarn "central server, you MUST visit the following site"
	ewarn "and request a key. This is not required if you"
	ewarn "want an unfindable private server. [DoUplink=False]"
	ewarn
	ewarn "http://unreal.epicgames.com/ut2004server/cdkey.php"
}
