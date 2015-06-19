# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/ut2004-data/ut2004-data-3186-r4.ebuild,v 1.6 2012/02/05 06:10:53 vapier Exp $

inherit eutils unpacker cdrom portability games

DESCRIPTION="Unreal Tournament 2004 - This is the data portion of UT2004"
HOMEPAGE="http://www.unrealtournament2004.com/"
SRC_URI=""

LICENSE="ut2003"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="games-util/uz2unpack
	>=app-arch/unshield-0.5-r1"
PDEPEND="games-fps/ut2004"

S=${WORKDIR}
dir=${GAMES_PREFIX_OPT}/ut2004
Ddir=${D}/${dir}

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
			insinto "${dir}"
			doins -r "${srcdir}" || die "doins ${srcdir} failed"
		fi
	done
}

pkg_setup() {
	games_pkg_setup

	ewarn "This is a huge package. If you do not have at least 7GB of free"
	ewarn "disk space in ${PORTAGE_TMPDIR} and also in ${GAMES_PREFIX_OPT}"
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

	if [[ ${USE_MIDWAY_DVD} -eq 1 ]] ; then
		einfo "Copying files from UT2004 Midway DVD."

		if [[ -f ${CDROM_ROOT}/Manual/Manual.pdf ]] ; then
			insinto "${dir}"/Manual
			doins "${CDROM_ROOT}"/Manual/Manual.pdf \
				|| die "doins Manual.pdf failed"
		elif [[ -f ${CDROM_ROOT}/Manual.pdf ]] ; then
			insinto "${dir}"/Manual
			doins "${CDROM_ROOT}"/Manual.pdf \
				|| die "doins Manual.pdf failed"
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
		unshield x data1.cab || die "unshield data1.cab failed"

		if [[ -d 4_UT2004_Animations ]] ; then
			# Delete the other games on the Anthology DVD
			rm -rf {1,2,3}_Unreal* 4_UT2004_EXE Launcher_* OCXFiles
			# Rename directories to be same as Midway UT2004-only DVD,
			# i.e. rename "4_UT2004_Animations" to "Animations".
			for j in 4_UT2004_* ; do
				mv -f ${j} ${j/4_UT2004_} || die "mv ${j} failed"
			done
		fi

		# The "logging" subdirectory is created by unshield.
		rm -rf logging
		rm -f *.{cab,hdr}

		for j in Animations Benchmark ForceFeedback Help KarmaData \
			Manual Maps Music Sounds Speech StaticMeshes \
			System Textures Web ; do

			# UT2004-only DVD has "All_*" dirs, and Anthology DVD has "*_All"
			if [[ -d All_${j} ]] ; then
				if [[ -d ${j} ]] ; then
					cp -rf All_${j}/* ${j}/ || die "cp All_${j} failed"
				else
					mv -f All_${j} ${j} || die "mv All_${j} failed"
				fi
			fi
			if [[ -d ${j}_All ]] ; then
				if [[ -d ${j} ]] ; then
					cp -rf ${j}_All/* ${j}/ || die "cp ${j}_All failed"
				else
					mv -f ${j}_All ${j} || die "mv ${j}_All failed"
				fi
			fi

			if [[ -d English_${j} ]] ; then
				if [[ -d ${j} ]] ; then
					cp -rf English_${j}/* ${j}/ || die "cp English_${j} failed"
				else
					mv -f English_${j} ${j} || die "mv English_${j}"
				fi
			fi
			if [[ -d ${j}_English ]] ; then
				if [[ -d ${j} ]] ; then
					cp -rf ${j}_English/* ${j}/ || die "cp ${j}_English failed"
				else
					mv -f ${j}_English ${j} || die "mv ${j}_English failed"
				fi
			fi

			# Ensure that the directory exists
			mkdir -p ${j}
		done

		# Rearrange directories
		if [[ -d English_Sounds_Speech_System_Help ]] ; then
			# http://utforums.epicgames.com/showthread.php?t=558146
			for j in Sounds Speech System Help ; do
				cp -rf English_Sounds_Speech_System_Help/${j}/* ${j}/ \
					|| die "cp English_Sounds_Speech_System_Help/${j} failed"
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
		insinto "${dir}"
		doins -r * || die "doins -r * failed"
	else
		# Disk 1
		einfo "Copying files from Disk 1..."
		insinto "${dir}"
		doins -r "${CDROM_ROOT}"/${DISK1}/{Animations,ForceFeedback,Help,KarmaData,Maps,Sounds,Web} \
			|| die "doins failed"
		insinto "${dir}"/System
		doins -r "${CDROM_ROOT}"/${DISK1}/System/{editorres,*.{bat,bmp,dat,det,est,frt,ini,int,itt,kot,md5,smt,tmt,u,ucl,upl,url}} \
			|| die "doins System failed"
		insinto "${dir}"/Manual
		doins "${CDROM_ROOT}"/${DISK1}/Manual/Manual.pdf \
			|| die "doins Manual.pdf failed"
		insinto "${dir}"/Benchmark/Stuff
		doins -r "${CDROM_ROOT}"/${DISK1}/Benchmark/Stuff/* \
			|| die "doins Benchmark failed"
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
		insinto "${dir}"/Help
		doins README.linux Unreal.bmp UT2004_EULA.txt ut2004.xpm

		doicon ut2004.xpm

		# Uncompress files
		einfo "Uncompressing files... this *will* take a while..."
		for j in Animations Maps Sounds StaticMeshes Textures ; do
			fperms -R u+w "${dir}/${j}" || die "fperms ${j} failed"
			games_ut_unpack "${Ddir}"/${j}
		done
	fi

	# Create empty files in Benchmark
	for j in {CSVs,Logs,Results} ;do
		keepdir "${dir}"/Benchmark/${j}
	done

	make_wrapper ut2004 ./ut2004-bin "${dir}"/System "${dir}"/System "${dir}"

	# Remove unneccessary files
	rm -f "${Ddir}"/*.{bat,exe,EXE,int}
	rm -f "${Ddir}"/Help/{.DS_Store,SAPI-EULA.txt}
	rm -f "${Ddir}"/Manual/*.exe
	rm -rf "${Ddir}"/Speech/Redist
	rm -f "${Ddir}"/System/*.{bat,dll,exe,tar}
	rm -f "${Ddir}"/System/{{License,Manifest}.smt,{ucc,StdOut}.log}
	rm -f "${Ddir}"/System/{User,UT2004}.ini

	# Remove file collisions with ut2004-3369-r4
	rm -f "${Ddir}"/Animations/ONSNewTank-A.ukx
	rm -f "${Ddir}"/Help/UT2004Logo.bmp
	rm -f "${Ddir}"/System/{ALAudio.kot,AS-{Convoy,FallenCity,Glacier}.kot,AS-{Convoy,FallenCity,Glacier,Junkyard,Mothership,RobotFactory}.int,bonuspack.{det,est,frt},BonusPack.{int,itt,u},BR-Serenity.int}
	rm -f "${Ddir}"/System/CTF-{AbsoluteZero,BridgeOfFate,DE-ElecFields,DoubleDammage,January,LostFaith}.int
	rm -f "${Ddir}"/System/DM-{1on1-Albatross,1on1-Desolation,1on1-Mixer,Corrugation,IronDeity,JunkYard}.int
	rm -f "${Ddir}"/System/{DOM-Atlantis.int,OnslaughtBP.{kot,u,ucl},OnslaughtFull.int}
	rm -f "${Ddir}"/System/{Build.ini,CacheRecords.ucl,Core.{est,frt,kot,int,itt,u},CTF-January.kot,D3DDrv.kot,DM-1on1-Squader.kot}
	rm -f "${Ddir}"/System/{Editor,Engine,Gameplay,GamePlay,UnrealGame,UT2k4Assault,XInterface,XPickups,xVoting,XVoting,XWeapons,XWebAdmin}.{det,est,frt,int,itt,u}
	rm -f "${Ddir}"/System/{Fire.u,IpDrv.u,License.int,ONS-ArcticStronghold.kot}
	rm -f "${Ddir}"/System/{OnslaughtFull,onslaughtfull,UT2k4AssaultFull}.{det,est,frt,itt,u}
	rm -f "${Ddir}"/System/{GUI2K4,Onslaught,skaarjpack,SkaarjPack,XGame}.{det,est,frt,int,itt,kot,u}
	rm -f "${Ddir}"/System/{Setup,Window}.{det,est,frt,int,itt,kot}
	rm -f "${Ddir}"/System/XPlayers.{det,est,frt,int,itt}
	rm -f "${Ddir}"/System/{UnrealEd.u,UTClassic.u,UTV2004c.u,UTV2004s.u,UWeb.u,Vehicles.kot,Vehicles.u,Xweapons.itt,UT2K4AssaultFull.int,UTV2004.kot,UTV2004s.kot}
	rm -f "${Ddir}"/System/{XAdmin.kot,XAdmin.u,XMaps.det,XMaps.est}
	rm -f "${Ddir}"/Textures/jwfasterfiles.utx
	rm -f "${Ddir}"/Web/ServerAdmin/{admins_home.htm,current_bots.htm,ut2003.css,current_bots_species_group.inc}
	rm -f "${Ddir}"/Web/ServerAdmin/ClassicUT/current_bots.htm
	rm -f "${Ddir}"/Web/ServerAdmin/UnrealAdminPage/{adminsframe.htm,admins_home.htm,admins_menu.htm,current_bots.htm,currentframe.htm,current_menu.htm}
	rm -f "${Ddir}"/Web/ServerAdmin/UnrealAdminPage/{defaultsframe.htm,defaults_menu.htm,footer.inc,mainmenu.htm,mainmenu_itemd.inc,rootframe.htm,UnrealAdminPage.css}
	rm -f "${Ddir}"/Web/ServerAdmin/UT2K3Stats/{admins_home.htm,current_bots.htm,ut2003stats.css}

	# Remove file collisions with ut2004-bonuspack-ece
	rm -f "${Ddir}"/Animations/{MechaSkaarjAnims,MetalGuardAnim,NecrisAnim,ONSBPAnimations}.ukx
	rm -f "${Ddir}"/Help/BonusPackReadme.txt
	rm -f "${Ddir}"/Maps/ONS-{Adara,IslandHop,Tricky,Urban}.ut2
	rm -f "${Ddir}"/Sounds/{CicadaSnds,DistantBooms,ONSBPSounds}.uax
	rm -f "${Ddir}"/StaticMeshes/{BenMesh02,BenTropicalSM01,HourAdara,ONS-BPJW1,PC_UrbanStatic}.usx
	rm -f "${Ddir}"/System/{ONS-Adara.int,ONS-IslandHop.int,ONS-Tricky.int,ONS-Urban.int,OnslaughtBP.int,xaplayersl3.upl}
	rm -f "${Ddir}"/Textures/{AW-2k4XP,BenTex02,BenTropical01,BonusParticles,CicadaTex,Construction_S}.utx
	rm -f "${Ddir}"/Textures/{HourAdaraTexor,ONSBPTextures,ONSBP_DestroyedVehicles,PC_UrbanTex,UT2004ECEPlayerSkins}.utx

	# Remove file collisions with ut2004-bonuspack-mega
	rm -f "${Ddir}"/Help/MegapackReadme.txt
	rm -f "${Ddir}"/Maps/{AS-BP2-Acatana,AS-BP2-Jumpship,AS-BP2-Outback,AS-BP2-SubRosa,AS-BP2-Thrust}.ut2
	rm -f "${Ddir}"/Maps/{CTF-BP2-Concentrate,CTF-BP2-Pistola,DM-BP2-Calandras,DM-BP2-GoopGod}.ut2
	rm -f "${Ddir}"/Music/APubWithNoBeer.ogg
	rm -f "${Ddir}"/Sounds/A_Announcer_BP2.uax
	rm -f "${Ddir}"/StaticMeshes/{JumpShipObjects,Ty_RocketSMeshes}.usx
	rm -f "${Ddir}"/System/{AssaultBP.u,Manifest.in{i,t},Packages.md5}
	rm -f "${Ddir}"/Textures/{JumpShipTextures,T_Epic2k4BP2,Ty_RocketTextures}.utx

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst

	elog "This is only the data portion of the game. To play UT2004,"
	elog "you still need to install games-fps/ut2004."
}
