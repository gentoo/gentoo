# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cdrom desktop eutils portability unpacker xdg-utils

DESCRIPTION="Unreal Tournament 2004 - This is the data portion of UT2004"
HOMEPAGE="https://liandri.beyondunreal.com/Unreal_Tournament_2004"

LICENSE="ut2003"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="
	games-util/uz2unpack
	>=app-arch/unshield-0.5-r1
"

PDEPEND=">=games-fps/ut2004-3369.3-r2"
RDEPEND="!games-fps/ut2004-ded"

S="${WORKDIR}"

check_dvd() {
	# The following is a nasty mess to determine if we are installing from
	# a DVD or from multiple CDs. Anyone feel free to submit patches to this
	# to bugs.gentoo.org as I know it is a very ugly hack.

	USE_DVD=
	USE_ECE_DVD=
	USE_MIDWAY_DVD=
	USE_GERMAN_MIDWAY_DVD=

	local point foo fs mnts=()
	while read point foo fs foo ; do
		[[ ${fs} =~ (9660|udf) ]] && mnts+=( "${point//\040/ }" )
	done < <(get_mounts)

	local r
	for r in "${CD_ROOT}" "${CD_ROOT_1}" "${mnts[@]}" ; do
		if [[ -n ${r} ]] ; then
			einfo "Searching ${r}"
			if [[ -f ${r}/AutoRunData/Unreal.ico ]] \
				&& [[ -f ${r}/Disk5/data6.cab ]] ; then
				USE_MIDWAY_DVD=1
				USE_DVD=1
			elif [[ -f ${r}/autorund/unreal.ico ]] \
				&& [[ -f ${r}/disk7/data8.cab ]] ; then
				USE_MIDWAY_DVD=1
				USE_GERMAN_MIDWAY_DVD=1
				USE_DVD=1
			else
				[[ -d ${r}/CD1 ]] && USE_DVD=1
				[[ -d ${r}/CD7 ]] && USE_ECE_DVD=1
			fi
		fi
	done
}

grabdirs() {
	local d
	for d in {Music,Sounds,Speech,StaticMeshes,Textures} ; do
		local srcdir=${CDROM_ROOT}/${1}/${d}
		# Is flexible to handle CD_ROOT vs CD_ROOT_1 mixups
		[[ -d ${srcdir} ]] || srcdir=${CDROM_ROOT}/${d}
		if [[ -d ${srcdir} ]] ; then
			insinto /opt/ut2004
			doins -r "${srcdir}"
		fi
	done
}

ut_unpack() {
	local ut_unpack="$1"
	local f=

	if [[ -z ${ut_unpack} ]] ; then
		die "You must provide an argument to ut_unpack"
	fi
	if [[ -f ${ut_unpack} ]] ; then
		uz2unpack "${ut_unpack}" "${ut_unpack%.uz2}" \
			|| die "uncompressing file ${ut_unpack}"
	fi
	if [[ -d ${ut_unpack} ]] ; then
		while read f ; do
			uz2unpack "${ut_unpack}/${f}" "${ut_unpack}/${f%.uz2}" \
				|| die "uncompressing file ${f}"
			rm -f "${ut_unpack}/${f}" || die "deleting compressed file ${f}"
		done < <(find "${ut_unpack}" -maxdepth 1 -name '*.uz2' -printf '%f\n' 2>/dev/null)
	fi
}

pkg_setup() {
	ewarn "This is a huge package. If you do not have at least 7GB of free"
	ewarn "disk space in ${PORTAGE_TMPDIR} and also in /opt"
	ewarn "then you should abort this installation now and free up some space."
}

src_unpack() {
	check_dvd

	if [[ ${USE_DVD} -eq 1 ]] ; then
		if [[ ${USE_MIDWAY_DVD} -eq 1 ]] ; then
			# Is 1 DVD, either UT2004-only or Anthology
			if [[ ${USE_GERMAN_MIDWAY_DVD} -eq 1 ]] ; then
				cdrom_get_cds autorund/unreal.ico
			else
				cdrom_get_cds AutoRunData/Unreal.ico
			fi
		else
			DISK1="CD1"
			DISK2="CD2"
			DISK3="CD3"
			DISK4="CD4"
			DISK5="CD5"
			DISK6="CD6"
			if [[ ${USE_ECE_DVD} -eq 1 ]] ; then
				# Editor's Choice Edition DVD
				cdrom_get_cds \
					${DISK1}/System/UT2004.ini \
					${DISK2}/Textures/2K4Fonts.utx.uz2 \
					${DISK3}/Textures/ONSDeadVehicles-TX.utx.uz2 \
					${DISK4}/Textures/XGameShaders2004.utx.uz2 \
					${DISK5}/Speech/ons.xml \
					${DISK6}/Sounds/TauntPack.det_uax.uz2
			else
				# Original DVD
				cdrom_get_cds \
					${DISK1}/System/UT2004.ini \
					${DISK2}/Textures/2K4Fonts.utx.uz2 \
					${DISK3}/Textures/ONSDeadVehicles-TX.utx.uz2 \
					${DISK4}/StaticMeshes/AlienTech.usx.uz2 \
					${DISK5}/Speech/ons.xml \
					${DISK6}/Sounds/TauntPack.det_uax.uz2
			fi
		fi
	else
		# 6 CDs
		cdrom_get_cds \
			System/UT2004.ini \
			Textures/2K4Fonts.utx.uz2 \
			Textures/ONSDeadVehicles-TX.utx.uz2 \
			StaticMeshes/AlienTech.usx.uz2 \
			Speech/ons.xml \
			Sounds/TauntPack.det_uax.uz2
	fi

	if [[ ${USE_MIDWAY_DVD} -ne 1 ]] ; then
		unpack_makeself "${CDROM_ROOT}"/linux-installer.sh
		use x86 && unpack ./linux-x86.tar
		use amd64 && unpack ./linux-amd64.tar
	fi
}

src_install() {
	local j
	local Ddir="${ED}"/opt/ut2004

	if [[ ${USE_MIDWAY_DVD} -eq 1 ]] ; then
		einfo "Copying files from UT2004 Midway DVD."

		if [[ -f ${CDROM_ROOT}/Manual/Manual.pdf ]] ; then
			insinto /opt/ut2004/Manual
			doins "${CDROM_ROOT}"/Manual/Manual.pdf
		elif [[ -f ${CDROM_ROOT}/Manual.pdf ]] ; then
			insinto /opt/ut2004/Manual
			doins "${CDROM_ROOT}"/Manual.pdf
		fi

		# Symlinks for unshield. data1&2.cab are both in Disk1.
		# unshield needs data1.hdr
		# The Midway Anthology DVD contains up to data9.cab
		local cabfile
		for cabfile in "${CDROM_ROOT}"/[dD]isk*/data*.{cab,hdr} ; do
			ln -sfn "${cabfile}" .
		done

		# The big extraction
		einfo "Extracting from CAB files - this will take several minutes..."
		unshield x data1.cab || die

		if [[ -d 4_UT2004_Animations ]] ; then
			# Delete the other games on the Anthology DVD
			rm -rf {1,2,3}_Unreal* 4_UT2004_EXE Launcher_* OCXFiles || die
			# Rename directories to be same as Midway UT2004-only DVD,
			# i.e. rename "4_UT2004_Animations" to "Animations".
			for j in 4_UT2004_* ; do
				mv -f ${j} ${j/4_UT2004_} || die
			done
		fi

		# The "logging" subdirectory is created by unshield.
		rm -rf logging || die
		rm -f *.{cab,hdr} || die

		for j in Animations Benchmark ForceFeedback Help KarmaData \
			Manual Maps Music Sounds Speech StaticMeshes \
			System Textures Web ; do

			# UT2004-only DVD has "All_*" dirs, and Anthology DVD has "*_All"
			if [[ -d All_${j} ]] ; then
				if [[ -d ${j} ]] ; then
					cp -rf All_${j}/* ${j}/ || die
				else
					mv -f All_${j} ${j} || die
				fi
			fi
			if [[ -d ${j}_All ]] ; then
				if [[ -d ${j} ]] ; then
					cp -rf ${j}_All/* ${j}/ || die
				else
					mv -f ${j}_All ${j} || die
				fi
			fi

			if [[ -d English_${j} ]] ; then
				if [[ -d ${j} ]] ; then
					cp -rf English_${j}/* ${j}/ || die
				else
					mv -f English_${j} ${j} || die
				fi
			fi
			if [[ -d ${j}_English ]] ; then
				if [[ -d ${j} ]] ; then
					cp -rf ${j}_English/* ${j}/ || die
				else
					mv -f ${j}_English ${j} || die
				fi
			fi

			# Ensure that the directory exists
			mkdir -p ${j}
		done

		# Rearrange directories
		if [[ -d English_Sounds_Speech_System_Help ]] ; then
			# http://utforums.epicgames.com/showthread.php?t=558146
			for j in Sounds Speech System Help ; do
				cp -rf English_Sounds_Speech_System_Help/${j}/* ${j}/ || die
			done
		fi

		if [[ ! -d Benchmark/Stuff ]] ; then
			mkdir -p Benchmark/Stuff || die
			cp -f BenchmarkStuff/timedemo.txt Benchmark/Stuff || die
		fi

		if [[ ! -d System/editorres ]] ; then
			mkdir -p System/editorres || die
			cp -rf Systemeditorres/* System/editorres || die
		fi

		if [[ ! -d Web/images ]] ; then
			mkdir -p Web/{images,ServerAdmin,Src} || die
			cp -rf Webimages/* Web/images || die
			cp -rf WebServerAdmin/* Web/ServerAdmin || die
			cp -rf WebSrc/* Web/Src || die
		fi

		# Other languages
		for j in Help_* Sounds_* System_* ; do
			[[ ! -d ${j} ]] && continue
			mv -n ${j}/* ${j/_*}/ || die
		done

		# Remove unnecessary directories
		rm -rf Benchmark{CSVs,Logs,Results,Stuff}
		rm -rf Systemeditorres Web{images,ServerAdmin,Src}
		rm -rf Help_* Sounds_* Speech_* System_*
		rm -rf \<* \[* _* All_* English_* *_All *_English

		# These files are replaced later, for all installations
		rm -f $(find . -type f -name 'DO_NOT_DELETE.ME')

		# Install icon
		if [[ -f ut2004.xpm ]] ; then
			doicon ut2004.xpm
		elif [[ -f Help/Unreal.ico ]] ; then
			newicon Help/Unreal.ico ut2004.ico
		elif [[ -f ${CDROM_ROOT}/AutoRunData/Unreal.ico ]] ; then
			newicon "${CDROM_ROOT}"/AutoRunData/Unreal.ico ut2004.ico
		elif [[ -f Help/Unreal.bmp ]] ; then
			newicon Help/Unreal.bmp ut2004.bmp
		fi

		# The big install
		einfo "Installing UT2004 directories..."
		insinto /opt/ut2004
		doins -r .
	else
		# Disk 1
		einfo "Copying files from Disk 1..."
		insinto /opt/ut2004
		doins -r "${CDROM_ROOT}"/${DISK1}/{Animations,ForceFeedback,Help,KarmaData,Maps,Sounds,Web}
		insinto /opt/ut2004/System
		doins -r "${CDROM_ROOT}"/${DISK1}/System/{editorres,*.{bat,bmp,dat,det,est,frt,ini,int,itt,kot,md5,smt,tmt,u,ucl,upl,url}}
		insinto /opt/ut2004/Manual
		doins "${CDROM_ROOT}"/${DISK1}/Manual/Manual.pdf
		insinto /opt/ut2004/Benchmark/Stuff
		doins -r "${CDROM_ROOT}"/${DISK1}/Benchmark/Stuff/.
		cdrom_load_next_cd

		local diskno
		for diskno in {2..5} ; do
			einfo "Copying files from Disk ${diskno}..."
			local varname="DISK${diskno}"
			grabdirs ${!varname}
			cdrom_load_next_cd
		done

		# Disk 6
		einfo "Copying files from Disk 6..."
		grabdirs "${DISK6}"

		# Install extra help files
		insinto /opt/ut2004/Help
		doins README.linux Unreal.bmp UT2004_EULA.txt ut2004.xpm

		doicon ut2004.xpm

		# Uncompress files
		einfo "Uncompressing files... this *will* take a while..."
		for j in Animations Maps Sounds StaticMeshes Textures ; do
			fperms -R u+w /opt/ut2004/${j}
			ut_unpack "${Ddir}"/${j}
		done
	fi

	# Create empty files in Benchmark
	for j in {CSVs,Logs,Results} ;do
		keepdir /opt/ut2004/Benchmark/${j}
	done

	# Remove unneccessary files
	rm -f "${Ddir}"/*.{bat,exe,EXE,int} || die
	rm -f "${Ddir}"/Help/{.DS_Store,SAPI-EULA.txt} || die
	rm -f "${Ddir}"/Manual/*.exe || die
	rm -rf "${Ddir}"/Speech/Redist || die
	rm -f "${Ddir}"/System/*.{bat,dll,exe,tar} || die
	rm -f "${Ddir}"/System/{{License,Manifest}.smt,{ucc,StdOut}.log} || die
	rm -f "${Ddir}"/System/{User,UT2004}.ini || die

	# Remove file collisions with ut2004-3369-r4
	rm -f "${Ddir}"/Animations/ONSNewTank-A.ukx || die
	rm -f "${Ddir}"/Help/UT2004Logo.bmp || die
	rm -f "${Ddir}"/System/{ALAudio.kot,AS-{Convoy,FallenCity,Glacier}.kot,AS-{Convoy,FallenCity,Glacier,Junkyard,Mothership,RobotFactory}.int,bonuspack.{det,est,frt},BonusPack.{int,itt,u},BR-Serenity.int} || die
	rm -f "${Ddir}"/System/CTF-{AbsoluteZero,BridgeOfFate,DE-ElecFields,DoubleDammage,January,LostFaith}.int || die
	rm -f "${Ddir}"/System/DM-{1on1-Albatross,1on1-Desolation,1on1-Mixer,Corrugation,IronDeity,JunkYard}.int || die
	rm -f "${Ddir}"/System/{DOM-Atlantis.int,OnslaughtBP.{kot,u,ucl},OnslaughtFull.int} || die
	rm -f "${Ddir}"/System/{Build.ini,CacheRecords.ucl,Core.{est,frt,kot,int,itt,u},CTF-January.kot,D3DDrv.kot,DM-1on1-Squader.kot} || die
	rm -f "${Ddir}"/System/{Editor,Engine,Gameplay,GamePlay,UnrealGame,UT2k4Assault,XInterface,XPickups,xVoting,XVoting,XWeapons,XWebAdmin}.{det,est,frt,int,itt,u} || die
	rm -f "${Ddir}"/System/{Fire.u,IpDrv.u,License.int,ONS-ArcticStronghold.kot} || die
	rm -f "${Ddir}"/System/{OnslaughtFull,onslaughtfull,UT2k4AssaultFull}.{det,est,frt,itt,u} || die
	rm -f "${Ddir}"/System/{GUI2K4,Onslaught,skaarjpack,SkaarjPack,XGame}.{det,est,frt,int,itt,kot,u} || die
	rm -f "${Ddir}"/System/{Setup,Window}.{det,est,frt,int,itt,kot} || die
	rm -f "${Ddir}"/System/XPlayers.{det,est,frt,int,itt} || die
	rm -f "${Ddir}"/System/{UnrealEd.u,UTClassic.u,UTV2004c.u,UTV2004s.u,UWeb.u,Vehicles.kot,Vehicles.u,Xweapons.itt,UT2K4AssaultFull.int,UTV2004.kot,UTV2004s.kot} || die
	rm -f "${Ddir}"/System/{XAdmin.kot,XAdmin.u,XMaps.det,XMaps.est} || die
	rm -f "${Ddir}"/Textures/jwfasterfiles.utx || die
	rm -f "${Ddir}"/Web/ServerAdmin/{admins_home.htm,current_bots.htm,ut2003.css,current_bots_species_group.inc} || die
	rm -f "${Ddir}"/Web/ServerAdmin/ClassicUT/current_bots.htm || die
	rm -f "${Ddir}"/Web/ServerAdmin/UnrealAdminPage/{adminsframe.htm,admins_home.htm,admins_menu.htm,current_bots.htm,currentframe.htm,current_menu.htm} || die
	rm -f "${Ddir}"/Web/ServerAdmin/UnrealAdminPage/{defaultsframe.htm,defaults_menu.htm,footer.inc,mainmenu.htm,mainmenu_itemd.inc,rootframe.htm,UnrealAdminPage.css} || die
	rm -f "${Ddir}"/Web/ServerAdmin/UT2K3Stats/{admins_home.htm,current_bots.htm,ut2003stats.css} || die

	# Remove file collisions with ut2004-bonuspack-ece
	rm -f "${Ddir}"/Animations/{MechaSkaarjAnims,MetalGuardAnim,NecrisAnim,ONSBPAnimations}.ukx || die
	rm -f "${Ddir}"/Help/BonusPackReadme.txt || die
	rm -f "${Ddir}"/Maps/ONS-{Adara,IslandHop,Tricky,Urban}.ut2 || die
	rm -f "${Ddir}"/Sounds/{CicadaSnds,DistantBooms,ONSBPSounds}.uax || die
	rm -f "${Ddir}"/StaticMeshes/{BenMesh02,BenTropicalSM01,HourAdara,ONS-BPJW1,PC_UrbanStatic}.usx || die
	rm -f "${Ddir}"/System/{ONS-Adara.int,ONS-IslandHop.int,ONS-Tricky.int,ONS-Urban.int,OnslaughtBP.int,xaplayersl3.upl} || die
	rm -f "${Ddir}"/Textures/{AW-2k4XP,BenTex02,BenTropical01,BonusParticles,CicadaTex,Construction_S}.utx || die
	rm -f "${Ddir}"/Textures/{HourAdaraTexor,ONSBPTextures,ONSBP_DestroyedVehicles,PC_UrbanTex,UT2004ECEPlayerSkins}.utx || die

	# Remove file collisions with ut2004-bonuspack-mega
	rm -f "${Ddir}"/Help/MegapackReadme.txt || die
	rm -f "${Ddir}"/Maps/{AS-BP2-Acatana,AS-BP2-Jumpship,AS-BP2-Outback,AS-BP2-SubRosa,AS-BP2-Thrust}.ut2 || die
	rm -f "${Ddir}"/Maps/{CTF-BP2-Concentrate,CTF-BP2-Pistola,DM-BP2-Calandras,DM-BP2-GoopGod}.ut2 || die
	rm -f "${Ddir}"/Music/APubWithNoBeer.ogg || die
	rm -f "${Ddir}"/Sounds/A_Announcer_BP2.uax || die
	rm -f "${Ddir}"/StaticMeshes/{JumpShipObjects,Ty_RocketSMeshes}.usx || die
	rm -f "${Ddir}"/System/{AssaultBP.u,Manifest.in{i,t},Packages.md5} || die
	rm -f "${Ddir}"/Textures/{JumpShipTextures,T_Epic2k4BP2,Ty_RocketTextures}.utx || die
}

pkg_postinst() {
	xdg_icon_cache_update

	elog "This is only the data portion of the game. To play UT2004,"
	elog "you still need to install games-fps/ut2004."
}

pkg_postrm() {
	xdg_icon_cache_update
}
