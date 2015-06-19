# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-rpg/nwn-data/nwn-data-1.29-r5.ebuild,v 1.6 2014/10/16 22:56:26 calchan Exp $

EAPI=5

CDROM_OPTIONAL="yes"
inherit eutils cdrom games

# 3-in-1 DVD - NWN, SoU, HotU (1 disk)
# Diamond DVD - NWN, SoU, HotU (1 disk)
# Platinum CD/DVD - NWN, SoU, HotU (4 disks/1 disk)
# Deluxe CD - NWN, SoU, HotU (5 disks)
# Gold CD - NWN, SoU (4 disks)
# Original CD - NWN (1 disk)

LANGUAGES="linguas_fr linguas_it linguas_es linguas_de linguas_en"

MY_PV=${PV//.}
CLIENT_BASEURL="http://nwdownloads.bioware.com/neverwinternights/linux"
UPDATE_BASEURL="http://files.bioware.com/neverwinternights/updates/linux"

NOWIN_SRC_URI="${UPDATE_BASEURL}/nwresources${MY_PV}.tar.gz
	http://bsd.mikulas.com/nwresources${MY_PV}.tar.gz
	http://163.22.12.40/FreeBSD/distfiles/nwresources${MY_PV}.tar.gz"

LINGUAS_SRC_URI="linguas_fr? (
		${UPDATE_BASEURL}/nwfrench${MY_PV}.tar.gz )
	linguas_it? (
		${UPDATE_BASEURL}/nwitalian${MY_PV}.tar.gz )
	linguas_es? (
		${UPDATE_BASEURL}/nwspanish${MY_PV}.tar.gz )
	linguas_de? (
		${UPDATE_BASEURL}/nwgerman${MY_PV}.tar.gz )"

DESCRIPTION="Neverwinter Nights Data Files"
HOMEPAGE="http://nwn.bioware.com/downloads/linuxclient.html"
SRC_URI="${CLIENT_BASEURL}/${MY_PV}/nwclient${MY_PV}.tar.gz
	nowin? ( ${NOWIN_SRC_URI} ${LINGUAS_SRC_URI} )
	!nowin? ( cdinstall? ( ${LINGUAS_SRC_URI} ) )
	mirror://gentoo/nwn.png"

LICENSE="NWN-EULA"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="cdinstall hou nowin sou videos ${LANGUAGES}"
RESTRICT="strip mirror"

RDEPEND=""
DEPEND="cdinstall? (
		games-util/biounzip
		app-arch/unshield )
	app-arch/unzip
	app-arch/p7zip
"

QA_PREBUILT="${GAMES_PREFIX_OPT:1}/nwn/lib/libSDL-1.2.so.0.0.5
	${GAMES_PREFIX_OPT:1}/nwn/miles/msssoft.m3d
	${GAMES_PREFIX_OPT:1}/nwn/miles/libmss.so.6.5.2
	${GAMES_PREFIX_OPT:1}/nwn/miles/mssmp3.asi
	${GAMES_PREFIX_OPT:1}/nwn/miles/mssdsp.flt"

S=${WORKDIR}/nwn

dir=${GAMES_PREFIX_OPT}/nwn
Ddir=${D}/${dir}

NWN_SET=

# This is my fun section where I try to determine which CD/DVD set we have.
# Expect this to be very messy and ugly, and hopefully it all works as we want
# it to on all of the various media.
get_nwn_set() {
	# First we check to see if we have CD_ROOT defined already.  If we do,
	# this will make our lives so much easier.
	if [[ -n "${CD_ROOT}" ]]
	then
		if [[ -f "${CD_ROOT}"/data5.cab ]]
		then
			NWN_SET="3in1_dvd"
			einfo "Neverwinter Nights 3-in-1 DVD found..."
		elif [[ -f "${CD_ROOT}"/KingmakerSetup.exe ]]
		then
			NWN_SET="diamond_dvd"
			einfo "Neverwinter Nights Diamond DVD found..."
		elif [[ -f "${CD_ROOT}"/ArcadeInstallNWNXP213f.EXE ]]
		then
			NWN_SET="platinum_cd"
			einfo "Neverwinter Nights Platinum DVD/CD set found..."
		elif [[ -f "${CD_ROOT}"/ArcadeInstallNWNXP1_12d.EXE ]]
		then
			NWN_SET="gold_cd"
			einfo "Neverwinter Nights Gold CD set found..."
		elif [[ -f "${CD_ROOT}"/ArcadeInstallNWN109.exe ]]
		then
			NWN_SET="original_cd"
			einfo "Neverwinter Nights Original/Deluxe CD set found..."
		fi
	# Now we check to see if we have CD_ROOT_1 set, which means we have a CD
	# set, or even a DVD set.
	elif [[ -n "${CD_ROOT_1}" ]]
	then
		if [[ -f "${CD_ROOT_1}"/data5.cab ]]
		then
			NWN_SET="3in1_dvd"
			einfo "Neverwinter Nights 3-in-1 DVD found..."
		elif [[ -f "${CD_ROOT_1}"/KingmakerSetup.exe ]]
		then
			NWN_SET="diamond_dvd"
			einfo "Neverwinter Nights Diamond DVD found..."
		elif [[ -f "${CD_ROOT_1}"/ArcadeInstallNWNXP213f.EXE ]]
		then
			NWN_SET="platinum_cd"
			einfo "Neverwinter Nights Platinum DVD/CD set found..."
		elif [[ -f "${CD_ROOT_1}"/ArcadeInstallNWNXP1_12d.EXE ]]
		then
			NWN_SET="gold_cd"
			einfo "Neverwinter Nights Gold CD set found..."
		elif [[ -f "${CD_ROOT_1}"/ArcadeInstallNWN109.exe ]]
		then
			NWN_SET="original_cd"
			einfo "Neverwinter Nights Original/Deluxe CD set found..."
		fi
	# OK.  Neither were set, so now we're going to start our detection and try
	# to figure out what we have to work from.
	else
		local mline=
		for mline in $(cat /etc/mtab | egrep -e '(iso|cdrom|udf)' | awk '{print $2}')
		do
			if [[ -f "${mline}"/data5.cab ]]
			then
				NWN_SET="3in1_dvd"
				einfo "Neverwinter Nights 3-in-1 DVD found..."
			elif [[ -f "${mline}"/KingmakerSetup.exe ]]
			then
				NWN_SET="diamond_dvd"
				einfo "Neverwinter Nights Diamond DVD found..."
			elif [[ -f "${mline}"/ArcadeInstallNWNXP213f.EXE ]]
			then
				NWN_SET="platinum_cd"
				einfo "Neverwinter Nights Platinum DVD/CD set found..."
			elif [[ -f "${mline}"/ArcadeInstallNWNXP1_12d.EXE ]]
			then
				NWN_SET="gold_cd"
				einfo "Neverwinter Nights Gold CD set found..."
			elif [[ -f "${mline}"/ArcadeInstallNWN109.exe ]]
			then
				NWN_SET="original_cd"
				einfo "Neverwinter Nights Original/Original CD set found..."
			fi
		done
	fi
}

get_cd_set() {
	while `[[ -z "${NWN_SET}" ]]`
	do
		echo "Please insert your first Neverwinter Nights CD/DVD into your drive and"
		echo "press any key to continue"
		read -n 1
		get_nwn_set
	done
	# Here is where we start our CD/DVD detection for changing disks.
	export CDROM_NAME_1="CD1" CDROM_NAME_2="CD2" CDROM_NAME_3="CD3"
	case "${NWN_SET}" in
	3in1_dvd)
		einfo "Both Shadows of Undrentide and Hordes of the Underdark will"
		einfo "be installed from your DVD along with Neverwinter Nights."
		touch .metadata/sou || die "touch sou"
		touch .metadata/hou || die "touch hou"
		touch .metadata/orig || die "touch orig"
		cdrom_get_cds data5.cab
		;;
	diamond_dvd)
		einfo "Both Shadows of Undrentide and Hordes of the Underdark will"
		einfo "be installed from your DVD along with Neverwinter Nights."
		touch .metadata/sou || die "touch sou"
		touch .metadata/hou || die "touch hou"
		touch .metadata/orig || die "touch orig"
		cdrom_get_cds KingmakerSetup.exe
		;;
	platinum_cd)
		einfo "Both Shadows of Undrentide and Hordes of the Underdark will"
		einfo "be installed from your CDs along with Neverwinter Nights."
		touch .metadata/orig || die "touch orig"
		touch .metadata/sou || die "touch sou"
		touch .metadata/hou || die "touching hou"
		export CDROM_NAME_4="CD4"
		cdrom_get_cds ArcadeInstallNWNXP213f.EXE \
			disk2.zip disk3.zip disk4.zip
		;;
	gold_cd)
		einfo "Shadow of Undrentide will be installed from your CDs along"
		einfo "with the original Neverwinter Nights. If you have the"
		einfo "Hordes of the Underdark expansion, it will be installed after."
		touch .metadata/orig || die "touch orig"
		touch .metadata/sou || die "touch sou"
		export CDROM_NAME_4="CD4"
		if use hou
		then
			einfo "You will also need the HoU CD for this installation."
			export CDROM_NAME_5="HoU"
			cdrom_get_cds ArcadeInstallNWNXP1_12d.EXE disk2.zip \
				disk3.zip disk4.zip ArcadeInstallNWNXP213f.EXE
		else
			cdrom_get_cds ArcadeInstallNWNXP1_12d.EXE disk2.zip \
				disk3.zip disk4.zip
		fi
		;;
	original_cd)
		einfo "We will be installing the original Neverwinter Nights.  If"
		einfo "you also have the Shadows of Undrentide or Hordes of the"
		einfo "Underdark expansions, they will be installed afterwards."
		touch .metadata/orig || die "touch orig"
		if use sou && use hou
		then
			einfo "You will also need the SoU and HoU CDs for this installation."
			export CDROM_NAME_4="SoU" CDROM_NAME_5="HoU"
			cdrom_get_cds ArcadeInstallNWN109.exe disk2.bzf \
				movies/NWNintro.bik NWNSoUInstallGuide.rtf \
				ArcadeInstallNWNXP213f.EXE
		elif use sou
		then
			einfo "You will also need the SoU CD for this installation."
			export CDROM_NAME_4="SoU"
			cdrom_get_cds ArcadeInstallNWN109.exe disk2.bzf \
				movies/NWNintro.bik NWNSoUInstallGuide.rtf
		elif use hou
		then
			einfo "You will also need the HoU CD for this installation."
			export CDROM_NAME_4="HoU"
			cdrom_get_cds ArcadeInstallNWN109.exe disk2.bzf \
				movies/NWNintro.bik ArcadeInstallNWNXP213f.EXE
		else
			cdrom_get_cds ArcadeInstallNWN109.exe disk2.bzf \
				movies/NWNintro.bik
		fi
		;;
	esac
}

src_unpack() {
	mkdir -p "${S}"
	cd "${S}"
	# We create this .metadata directory so we can keep track of what we have
	# installed without needing to keep all of these multiple USE flags in all
	# of the ebuilds.
	mkdir -p .metadata || die "Creating .metadata"
	# Since we don't *always* want to do this, we check for USE=cdinstall
	if use cdinstall
	then
		# Here, we determine which CD/DVD set that we have.  This will seem a
		# bit odd, since we'll be doing the detection a few times.
		get_nwn_set
		# Now that we know what we're looking for, let's look for the media.
		get_cd_set

		case ${NWN_SET} in
		3in1_dvd)
			mkdir -p "${S}"
			cd "${S}"
			einfo "Unpacking files..."
			# We don't give the user the option to install SoU/HotU.  While some
			# people might complain about this, most newer NWN stuff requires
			# them both anyway, so it makes no sense not to install them.
			unshield x "${CDROM_ROOT}"/data1.hdr || die "unpacking"
			# We have to adjust the files after unpacking the cab file.
			rm -rf _*

			mv -f App_Executables/{ambient,data,modules,music,texturepacks} .
			mv -f App_Executables/{dm,local}vault .
			mv -f App_Executables/*.key .
			mv -f App_Executables/nwm .
			if use videos
			then
				mv -f App_Executables/movies .
			fi
			mkdir -p utils/nwupdateskins/
			mv -f App_Executables/utils/nwupdateskins/*.bmp utils/nwupdateskins/
			rm -rf App_Executables/
			;;
		diamond_dvd)
			# This is probably the simplest NWN to install.
			mkdir -p "${S}"
			cd "${S}"
			einfo "Unpacking files..."
			unzip -qo "${CDROM_ROOT}"/Data_Shared.zip || die "unpacking"
			# I think these are not needed.  Can someone verify this?
#			unzip -qo "${CDROM_ROOT}"/Language_data.zip || die "unpacking"
#			unzip -qo "${CDROM_ROOT}"/Language_update.zip || die "unpacking"
			unzip -qo "${CDROM_ROOT}"/Data_linux.zip || die "unpacking"
			# We don't give the user the option to install SoU/HotU.  While some
			# people might complain about this, most newer NWN stuff requires
			# them both anyway, so it makes no sense not to install them.
			unzip -qo "${CDROM_ROOT}"/data/XP1.zip
			unzip -qo "${CDROM_ROOT}"/data/XP2.zip
			7z x "${CDROM_ROOT}/KingmakerSetup.exe" -xr0\!*PLUGINSDIR* -xr\!*.exe -xr\!*.dat &> /dev/null || die "unpacking"
			use videos || rm -rf \$0/movies
			cp -rf \$0/* ./
			rm -rf \$0
			;;
		platinum_cd)
			# This one isn't too bad, either.  Luckily, everything is in a ZIP.
			mkdir -p "${S}"
			cd "${S}"
			einfo "Unpacking files..."
			unzip -qo "${CDROM_ROOT}"/Data_Shared.zip || die "unpacking"
			unzip -qo "${CDROM_ROOT}"/Language_data.zip || die "unpacking"
			unzip -qo "${CDROM_ROOT}"/Language_update.zip || die "unpacking"
			unshield x "${CDROM_ROOT}"/data2.cab || die "unpacking"
			# We have to adjust the files after unpacking the cab file.
			mkdir -p miles/
			mkdir -p ambient/
			mkdir -p utils/nwupdateskins/
			mv -f NWN_Platinum/Miles/* miles/
			mv -f NWN_Platinum/ambient/*.wav ambient/
			mv -f NWN_Platinum/docs .
			mv -f NWN_Platinum/modules .
			mv -f NWN_Platinum/nwm .
			mv -f NWN_Platinum/utils/nwupdateskins/*.bmp utils/nwupdateskins/
			rm -rf NWN_Platinum/
			rm -rf _*
			# If we have the DVD, we're done.  If not, we need to switch CDs and
			# unpack the files on them.
			if [[ $(du -b "${CDROM_ROOT}"/Data_Shared.zip | awk '{print $1}') -lt 700000000 ]]
			then
				cdrom_load_next_cd
				einfo "Unpacking files..."
				unzip -qo "${CDROM_ROOT}"/disk2.zip || die "unpacking"
				cdrom_load_next_cd
				einfo "Unpacking files..."
				unzip -qo "${CDROM_ROOT}"/disk3.zip || die "unpacking"
				unzip -qo "${CDROM_ROOT}"/Data_Linux.zip || die "unpacking"
				unzip -qo "${CDROM_ROOT}"/language_data.zip || die "unpacking"
				cdrom_load_next_cd
				einfo "Unpacking files..."
				unzip -qo "${CDROM_ROOT}"/disk4.zip || die "unpacking"
				unzip -qo "${CDROM_ROOT}"/xp1.zip || die "unpacking"
				unzip -qo "${CDROM_ROOT}"/xp1_data.zip || die "unpacking"
			fi
			;;
		gold_cd)
			# Variety of ZIP's off 4 CD's
			mkdir -p "${S}"
			cd "${S}"
			einfo "Unpacking files..."
			einfo "Copying files from CD1"
			cp "${CDROM_ROOT}"/Data_Shared.zip . || die "unpacking"
			cp "${CDROM_ROOT}"/Language_data.zip . || die "unpacking"
			cp "${CDROM_ROOT}"/Language_update.zip . || die "unpacking"
			# Yay cd switching
			cdrom_load_next_cd
			unzip -qo "${CDROM_ROOT}"/disk2.zip || die "unpacking"
			cdrom_load_next_cd
			unzip -qo "${CDROM_ROOT}"/disk3.zip || die "unpacking"
			cdrom_load_next_cd
			unzip -qo "${CDROM_ROOT}"/disk4.zip || die "unpacking"
			# Amazingly enough, the order of operations matter.
			unzip -qo "${S}"/Data_Shared.zip || die "unpacking"
			unzip -qo "${S}"/Language_data.zip || die "unpacking"
			unzip -qo "${S}"/Language_update.zip || die "unpacking"
			rm -f Data_Shared.zip
			rm -f Language_data.zip
			rm -f Language_update.zip
			# Expansion pack
			if use hou
			then
				rm -f xp1patch.key data/xp1patch.bif override/*
				cdrom_load_next_cd
				einfo "Unpacking files..."
				unzip -qo "${CDROM_ROOT}"/Data_Shared.zip || die "unpacking"
				unzip -qo "${CDROM_ROOT}"/Language_data.zip || die "unpacking"
				unzip -qo "${CDROM_ROOT}"/Language_update.zip || die "unpacking"
				touch .metadata/hou || die "touching hou"
			fi
			;;
		original_cd)
			# Now, we need to create our directories, since we know we'll end up
			# needing them for our install.
			mkdir -p ambient data dmvault docs lib localvault miles modules \
				music nwm override texturepacks scripttemplates

			# Handle NWN CD1
			mkdir "${S}"/disc1_tmp
			cd "${S}"/disc1_tmp
			einfo "Unpacking files..."
			unshield x ${CDROM_ROOT}/data1.cab || die "unpacking files"
			rm -f miles/Mss32.dll
			mv -f */* .
			cd "${S}"

			mv -f disc1_tmp/*.bif data
			mv -f disc1_tmp/dungeonmaster.bic dmvault
			mv -f disc1_tmp/*.bic localvault
			mv -f disc1_tmp/*.{pdf,txt} docs
			mv -f disc1_tmp/*.erf texturepacks
			mv -f disc1_tmp/chitin.key .
			rm -rf disc1_tmp

			# NWN CD2
			cdrom_load_next_cd
			biounzip ${CDROM_ROOT}/disk2.bzf . || die "unpacking files"

			# NWN CD3
			cdrom_load_next_cd
			einfo "Copying files from cd..."
			for i in ambient data music
			do
				cp ${CDROM_ROOT}/${i}/* "${S}"/${i} || die "error copying data"
				chmod -x "${S}"/${i}/*
			done
			if use videos
			then
				mkdir -p "${S}"/movies
				cp ${CDROM_ROOT}/movies/* "${S}"/movies || die "error copying data"
				chmod -x "${S}"/movies/*
			fi

			# Now, we install HoU and SoU, if necessary
			if use sou
			then
				cdrom_load_next_cd
				einfo "Unpacking files..."
				unzip -qo "${CDROM_ROOT}"/Data_Shared.zip || die "unpacking"
				unzip -qo "${CDROM_ROOT}"/Language_data.zip || die "unpacking"
				unzip -qo "${CDROM_ROOT}"/Language_update.zip || die "unpacking"
				unzip -qo "${CDROM_ROOT}"/Data_Linux.zip || die "unpacking"
				touch .metadata/sou || die "touching sou"
			fi
			if use hou
			then
				cdrom_load_next_cd
				if use sou && use hou
				then
					rm -f xp1patch.key data/xp1patch.bif override/*
				fi
				einfo "Unpacking files..."
				unzip -qo "${CDROM_ROOT}"/Data_Shared.zip || die "unpacking"
				unzip -qo "${CDROM_ROOT}"/Language_data.zip || die "unpacking"
				unzip -qo "${CDROM_ROOT}"/Language_update.zip || die "unpacking"
				touch .metadata/hou || die "touching hou"
			fi
			;;
		esac
	fi
	# We unpack this for all media sets.
	unpack nwclient${MY_PV}.tar.gz
	if use nowin
	then
		if (use sou || use hou) && ! use cdinstall ; then
			ewarn "If you really want to install SoU and/or HoU, you must"
			ewarn "emerge with USE=cdinstall."
			die "SoU and/or HoU require USE=cdinstall."
		fi
		cd "${WORKDIR}"
		unpack nwresources${MY_PV}.tar.gz \
			|| die "unpacking nwresources${MY_PV}.tar.gz"
		cd "${S}"
	fi

	rm -rf override/*
	for a in ${A}
	do
		currentlocale=""
		if [[ -z ${a/*german*/} ]]
		then
			currentlocale=de
		elif [[ -z ${a/*spanish*/} ]]
		then
			currentlocale=es
		elif [[ -z ${a/*italian*/} ]]
		then
			currentlocale=it
		elif [[ -z ${a/*french*/} ]]
		then
			currentlocale=fr
		fi
		if [[ -n "$currentlocale" ]]
		then
			touch ".metadata/linguas_$currentlocale"
			mkdir -p $currentlocale
			cd ${currentlocale}
			unpack ${a} || die "unpacking ${a}"
			cd ..
		fi
	done
	if use linguas_en
	then
		touch ".metadata/linguas_en"
	fi
	# These files aren't needed and come from the patches (games-rpg/nwn)
	rm -f data/patch.bif patch.key
	rm -f data/xp1patch.bif xp1patch.key

	# Rename nwn.ini to avoid overwriting it every time
	mv nwn.ini nwn.ini.default

	sed -i -e 's,/bin/sh,/bin/bash,g' -e '\:^./nwmain .*:i \
'"dir='${dir}';LINGUAS='${LINGUAS}'"';LANG="${LANG/_*}" \
die() { \
	echo "$*" 1>&2 \
	exit 1 \
} \
cd "${dir}" || die "cd ${dir}" \
if [[ -d "$LANG" ]] \
then \
	p=${HOME}/.nwn/${LANG} \
elif [[ -d "en" ]] \
then \
	LANG=en \
	p=${HOME}/.nwn/${LANG} \
else \
	LANG="" \
	p=${HOME}/.nwn \
	for i in ${LINGUAS} \
	do \
		if [ -z "${LANG}" -a -r ".metadata/linguas_$i" -a -d "$i" ] \
		then \
			LANG=$i \
			p=${HOME}/.nwn \
		fi \
	done \
fi \
mkdir -p "${p}" \
find "${p}" -type l -delete \
for i in * ; do \
	if [[ ! -f ".metadata/linguas_${i}" && ${i: -4} != ".ini" ]] \
	then \
		cp -rfs ${dir}/${i} ${p}/. || die "copy ${i}" \
	fi \
done \
if [[ -n "$LANG" ]] \
then \
	cd "${LANG}" || die "cd ${LANG}" \
	for i in * ; do \
		cp -rfs ${dir}/${LANG}/${i} ${p}/. || die "copy ${LANG}/${i}" \
	done \
fi \
cd "${p}" || die "cd ${p}" \
if [[ -r ./nwmovies.so ]]; then \
	export LD_PRELOAD=./nwmovies.so:$LD_PRELOAD \
	export SDL_AUDIODRIVER=alsa \
fi \
if [[ -r ./nwmouse.so ]]; then \
	export XCURSOR_PATH="$(pwd)" \
	export XCURSOR_THEME=nwmouse \
	export LD_PRELOAD=./nwmouse.so:$LD_PRELOAD \
fi \
	' "${S}"/nwn || die "sed nwn"
}

src_install() {
	dodir "${dir}"
	mkdir -p "${S}"/dmvault "${S}"/hak "${S}"/portraits "${S}"/localvault
	rm -rf "${S}"/dialog*.{tlk,TLK} "${S}"/*/dialog*.{tlk,TLK} \
		"${S}"/dmclient "${S}"/nwmain "${S}"/nwserver  \
		"${S}"/SDL-1.2.5 "${S}"/fixinstall
	# Remove the softlink to the built-in SDL library so that we don't have to re-install
	# this whole thing whenever we need to update to a different custom SDL
	rm "${S}"/lib/libSDL-1.2.so.0
	if ! use videos
	then
		rm -rf "${S}"/movies/*
	fi
	mv "${S}"/* "${Ddir}"
	mv "${S}"/.metadata "${Ddir}"
	keepdir "${dir}"/servervault
	keepdir "${dir}"/scripttemplates
	keepdir "${dir}"/saves
	keepdir "${dir}"/portraits
	keepdir "${dir}"/hak
	cd "${Ddir}"
	for d in ambient data dmvault hak localvault movies music override portraits
	do
		if [[ -d ${d} ]]
		then
			( cd ${d}
			for f in $(find . -name '*.*') ; do
				lcf=$(echo ${f} | tr [:upper:] [:lower:])
				if [[ ${f} != ${lcf} ]] && [[ -f ${f} ]]
				then
					mv ${f} ${lcf}
				fi
			done )
		fi
	done

	doicon "${DISTDIR}"/nwn.png

	prepgamesdirs
	chmod -R g+rwX "${Ddir}/saves" "${Ddir}/localvault" "${Ddir}/dmvault" \
		2>&1 > /dev/null || die "could not chmod"
	chmod g+rwX "${Ddir}" || die "could not chmod"
}

pkg_postinst() {
	games_pkg_postinst
	if ! use cdinstall && ! use nowin ; then
		elog "The NWN linux client data is now installed."
		elog "Proceed with the following steps in order to get it working:"
		elog "1) Copy the following directories/files from your installed and"
		elog "   patched (1.68) Neverwinter Nights to ${dir}:"
		elog "    ambient/"
		elog "    data/"
		elog "    dmvault/"
		elog "    hak/"
		elog "    localvault/"
		elog "    modules/"
		if use videos
		then
			elog "    movies/"
		fi
		elog "    music/"
		elog "    portraits/"
		elog "    saves/"
		elog "    servervault/"
		elog "    texturepacks/"
		elog "    chitin.key"
		elog "2) Remove some files to make way for the patch"
		elog "    rm ${dir}/music/mus_dd_{kingmaker,shadowgua,witchwake}.bmu"
		elog "    rm ${dir}/override/iit_medkit_001.tga"
		elog "    rm ${dir}/data/patch.bif"
		if use sou
		then
			elog "    rm ${dir}/xp1patch.key ${dir}/data/xp1patch.bif"
		fi
		if use hou
		then
			elog "    rm ${dir}/xp2patch.key ${dir}/data/xp2patch.bif"
		fi
		elog "3) Chown and chmod the files with the following commands"
		elog "    chown -R ${GAMES_USER}:${GAMES_GROUP} ${dir}"
		elog "    chmod -R g+rwX ${dir}"
		echo
		elog "Or try emerging with USE=nowin and/or USE=cdinstall."
		echo
	else
		einfo "The NWN linux client data is now installed."
		echo
	fi
	if use cdinstall && ! use nowin ; then
		ewarn "Some/all demo modules will be missing. You can copy them manually into :"
		ewarn "${dir}/modules"
		ewarn "or emerge with USE=nowin."
	fi
	if ! use cdinstall && use nowin && use videos
	then
		ewarn "Some/all movies will be missing. You can copy them manually into :"
		ewarn "${dir}/movies"
		ewarn "or emerge with USE=cdinstall and/or USE=-nowin."
	fi
	elog "This is only the data portion, you will also need games-rpg/nwn to"
	elog "play Neverwinter Nights."
	echo
}
