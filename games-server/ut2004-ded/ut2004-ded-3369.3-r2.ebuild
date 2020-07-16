# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit check-reqs eutils

BONUSPACK_P="dedicatedserver3339-bonuspack.zip"
PATCH_P="ut2004-lnxpatch${PV%.*}-2.tar.bz2"
DESCRIPTION="Unreal Tournament 2004 Linux Dedicated Server"
HOMEPAGE="https://liandri.beyondunreal.com/Unreal_Tournament_2004"
SRC_URI="
	https://ut2004.ut-files.com/Entire_Server_Download/${BONUSPACK_P}
	https://ut2004.ut-files.com/Patches/Linux/${PATCH_P}
	https://dev.gentoo.org/~chewi/distfiles/ut2004-v${PV/./-}-linux-dedicated.7z
"

LICENSE="ut2003"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
RESTRICT="bindist mirror strip"

BDEPEND="
	app-arch/p7zip
	app-arch/unzip
"

RDEPEND="
	!games-fps/ut2004
	!games-fps/ut2004-data
	games-fps/ut2004-bonuspack-ece
	games-fps/ut2004-bonuspack-mega
	sys-libs/glibc
"

CHECKREQS_DISK_BUILD="2G"
QA_PREBUILT="*"

S="${WORKDIR}"
DIR="/opt/${PN%-ded}"

src_prepare() {
	default

	if use amd64; then
		mv ut2004-ucc-bin-09192008/ucc-bin{-linux-amd64,} || die
	fi

	cp -r UT2004-Patch/* ./ || die
	mv ut2004-ucc-bin-09192008/ucc-bin System/ || die
	rm -r System/{ut2004-bin*,*.dll,*.exe} UT2004-Patch/ ut2004-ucc-bin-09192008/ || die

	# In ut2004-bonuspack-ece.
	rm \
		Animations/{MechaSkaarjAnims,MetalGuardAnim,NecrisAnim,ONSBPAnimations}.ukx \
		Help/BonusPackReadme.txt \
		Maps/ONS-{Adara,Aridoom,Ascendancy,IslandHop,Tricky,Urban}.ut2 \
		Sounds/{CicadaSnds,DistantBooms,ONSBPSounds}.uax \
		StaticMeshes/{BenMesh02,BenTropicalSM01,HourAdara,ONS-BPJW1,PC_UrbanStatic}.usx \
		System/{ONS-{Adara,IslandHop,Tricky,Urban},OnslaughtBP}.int \
		System/xaplayersl3.upl \
		Textures/{AW-2k4XP,BenTex02,BenTropical01,BonusParticles,CicadaTex,Construction_S,HourAdaraTexor,ONSBP{_DestroyedVehicles,Textures},PC_UrbanTex,UT2004ECEPlayerSkins}.utx \
		|| die

	# In ut2004-bonuspack-mega.
	rm System/{Manifest.in[it],Packages.md5} || die
}

src_install() {
	insinto "${DIR}"
	doins -r *
	fperms +x "${DIR}"/System/ucc-bin

	make_wrapper ${PN} "./ucc-bin server" "${DIR}"/System
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
}

pkg_postinst() {
	elog "You should take the time to edit the default server INI. Consult the INI"
	elog "Reference at https://unrealadmin.org/server_ini_reference/ut2004 for"
	elog "assistance in adjusting ${DIR}/System/Default.ini."
	elog
	elog "To have your server authenticate properly to the central server, you"
	elog "MUST visit https://www.unrealadmin.org/server_cdkey and request a key."
	elog "This is not required if you want an unlisted private server with"
	elog "[DoUplink=False]."
}
