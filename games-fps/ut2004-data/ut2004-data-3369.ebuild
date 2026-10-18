# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CDROM_OPTIONAL="yes"
inherit cdrom check-reqs multiprocessing portability

DESCRIPTION="Data files for Unreal Tournament 2004"
HOMEPAGE="https://liandri.beyondunreal.com/Unreal_Tournament_2004"
GOG=( "setup_unreal_tournament_2004_1.0_(18947).exe" "setup_unreal_tournament_2004_1.0_(18947)-1.bin" )
SRC_URI="
	!cdinstall? ( !gog? ( fetch+https://files.oldunreal.net/UT2004.ISO -> UT2004.iso ) )
	gog? ( ${GOG[*]} )
	megapack? ( fetch+https://unreal-archive-files-na.s3.ca-east-tor.io.cloud.ovh.net/managed/Unreal%20Tournament%202004/patches-updates/bonus-packs/ut2004megapack-linux.tar.bz2 )
"
S="${WORKDIR}"

LICENSE="Epic-TOS" # See metadata.xml for the legal background.
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="megapack doc gog l10n_de l10n_es l10n_fr l10n_it l10n_ko"
RESTRICT="bindist gog? ( fetch ) mirror"
REQUIRED_USE="
	?? ( cdinstall gog )
	!cdinstall? ( !megapack )
"

UT_DEPEND=">=games-fps/ut2004-3374_pre23"

BDEPEND="
	${UT_DEPEND}
	gog? ( app-arch/innoextract )
	!gog? (
		app-arch/libarchive
		app-arch/unshield
	)
"
RDEPEND="
	${UT_DEPEND}
	!games-fps/ut2004-bonuspack-ece
	!games-fps/ut2004-bonuspack-mega
	!games-server/ut2004-ded
"

# Assuming the OldUnreal ISO.
CHECKREQS_DISK_BUILD="15G"

pkg_nofetch() {
	einfo "Please download ${GOG[0]} and"
	einfo "${GOG[1]} from GOG and move them"
	einfo "to your distfiles directory. Note that you can no longer buy this"
	einfo "game from GOG, so disable USE=\"gog\" to use OldUnreal's free ISO if"
	einfo "you don't already own the game."
}

locale_mismatch() {
	case "${1}" in
		*.det|*.det_*|4_UT2004_*_German*) ! use l10n_de ;;
		*.est|*.est_*|4_UT2004_*_Spanish) ! use l10n_es ;;
		*.frt|*.frt_*|4_UT2004_*_French)  ! use l10n_fr ;;
		*.itt|*.itt_*|4_UT2004_*_Italian) ! use l10n_it ;;
		*.kot|*.kot_*) ! use l10n_ko ;;
		*) return 1 ;;
	esac
}

src_unpack() {
	if use gog; then
		innoextract --extract "${DISTDIR}/${GOG[0]}" || die
		return
	elif use cdinstall; then
		ewarn "It is no longer necessary to install this from CD or DVD. Please"
		ewarn "disable USE=\"cdinstall\" if you would prefer to download the game for"
		ewarn "free. Note that the free download lacks localised audio and some"
		ewarn "localised text."
		echo
	else
		# We might as well handle a downloaded ISO and a user-provided ISO the
		# same way through cdrom.eclass.
		CD_ROOT="${DISTDIR}/UT2004.iso"
	fi

	# No really, Midway.tga is *not* on the Midway DVD.
	# The German Midway DVD doesn't include UT99.

	cdrom_get_cds \
		Manuals/UnrealTournament_English.pdf:autorund/unreal.ico:AutoRunData/Midway.tga:CD6/Sounds/TauntPack.det_uax.uz2:linux-installer.sh:System/UT2004.ini \
		::::Textures/2K4Fonts.utx.uz2:Textures/2K4Fonts.utx.uz2 \
		::::Textures/ONSDeadVehicles-TX.utx.uz2:Textures/ONSDeadVehicles-TX.utx.uz2 \
		::::StaticMeshes/AlienTech.usx.uz2:StaticMeshes/AlienTech.usx.uz2 \
		::::Speech/ons.xml:Speech/ons.xml \
		:::::Sounds/TauntPack.det_uax.uz2

	case ${CDROM_SET} in
		0) einfo "Found Midway Unreal Anthology DVD" ;;
		1) einfo "Found German Midway Unreal Anthology DVD" ;;
		2) einfo "Found OldUnreal UT2004 DVD" ;;
		3) einfo "Found UT2004 DVD (original or Editor's Choice Edition)" ;;
		4) einfo "Found UT2004 CD 1 of 5" ;;
		5) einfo "Found UT2004 CD 1 of 6" ;;
	esac

	case ${CDROM_SET} in
		3|4|5)
			if ! use megapack; then
				die "Your installation source lacks the Mega Pack. Please enable USE=\"megapack\" to download it."
			fi ;;
		*)
			if use megapack; then
				ewarn "Enabling USE=\"megapack\" just downloads an unnecessary file with"
				ewarn "this installation source. Please disable it."
			fi ;;
	esac

	local group dir cdnum
	case ${CDROM_SET} in
		0|1)
			# Symlinks for unshield. These files need to be in the same
			# directory but on the disk, they are not for some reason.
			ln -snf "${CDROM_ROOT}"/{Disk1/data1.hdr,Disk*/data*.cab} "${T}"/ || die

			for group in $(unshield g "${T}"/data1.cab || die); do
				case ${group} in
					4_UT2004_Benchmark|4_UT2004_EXE|4_UT2004_Manual_*|4_UT2004_Web) continue ;;
					4_UT2004_*) : ;;
					*) continue ;;
				esac
				locale_mismatch "${group}" && continue
				unshield -g "${group}" x "${T}"/data1.cab || die
			done

			for dir in 4_UT2004_*; do
				mv -v "${dir}" "${dir#4_UT2004_}" || die
			done

			for dir in *_*/; do
				mkdir -p "${dir%_*}" || die
				tar -C "${dir}" --remove-files -cf - . | tar -C "${dir%_*}" -xvf - || die
			done
			;;

		2)
			# Symlinks for unshield. These files need to be in the same
			# directory but on the disk, they are not for some reason.
			ln -snf "${CDROM_ROOT}"/{Disk1/data1.hdr,Disk*/data*.cab} "${T}"/ || die

			for group in $(unshield g "${T}"/data1.cab || die); do
				case ${group} in
					All_Benchmark|All_Web) continue ;;
					All_*|English_Sounds_Speech_System_Help|US_License.int) : ;;
					*) continue ;;
				esac
				unshield -g "${group}" x "${T}"/data1.cab || die
			done

			for dir in All_*; do
				mv -v "${dir}" "${dir#All_}" || die
			done

			mkdir -p Sounds Speech System Help || die
			mv -v UT2004.EXE/* US_License.int/* System/ || die
			for dir in English_Sounds_Speech_System_Help/*/; do
				mv -v "${dir}"/* "${dir#*/}" || die
			done
			;;

		3)
			for cdnum in {1..6}; do
				tar -C "${CDROM_ROOT}/CD${cdnum}" --mode=u+w -cf - . | tar -xvf - || die
			done
			;;

		4|5)
			tar -C "${CDROM_ROOT}" --mode=u+w -cf - . | tar -xvf - || die
			for cdnum in $(seq 2 $((CDROM_SET + 1))); do
				cdrom_load_next_cd
				tar -C "${CDROM_ROOT}" --mode=u+w -cf - . | tar -xvf - || die
			done
			;;
	esac

	case ${CDROM_SET} in
		3|4|5)
			# Some disks compress most of the files. The engine has the
			# decompresser. Annoyingly, it logs to the engine's directory.
			addpredict "${BROOT}"/opt/ut2004
			ls */*.uz2 | xargs -P "$(get_makeopts_jobs)" -ti ut2004-ucc decompress "${PWD}"/{} -nohomedir >/dev/null || die
			rm -v */*.uz2 || die

			# Install the Mega Pack where necessary for parity between different
			# installation sources. This includes the ECE content but *not* the
			# XP Bonus Maps (ONS-Aridoom and ONS-Ascendancy). The latter were
			# never released as part of the game and OldUnreal does not include
			# them in its installation.
			tar --strip-components=1 -jxvf "${DISTDIR}"/ut2004megapack-linux.tar.bz2 || die
		;;
	esac
}

src_install() {
	local dir file

	if use doc; then
		case ${CDROM_SET} in
			0|1)
				newdoc "${CDROM_ROOT}"/Manuals/UT2004_English.pdf Manual.pdf
				use l10n_de && newdoc "${CDROM_ROOT}"/Manuals/UT2004_German.pdf Manual_de.pdf
				use l10n_es && newdoc "${CDROM_ROOT}"/Manuals/UT2004_Spanish.pdf Manual_es.pdf
				use l10n_fr && newdoc "${CDROM_ROOT}"/Manuals/Français/UT2004.pdf Manual_fr.pdf
				use l10n_it && newdoc "${CDROM_ROOT}"/Manuals/UT2004_Italian.pdf Manual_it.pdf ;;
			2) dodoc "${CDROM_ROOT}"/Manual.pdf ;;
			3) dodoc "${CDROM_ROOT}"/CD1/Manual/Manual.pdf ;;
			*) dodoc Manual/Manual.pdf ;;
		esac
	fi

	# Drop unwanted localisation files.
	while read -r file; do
		if locale_mismatch "${file}"; then
			rm -v "${file}" || die
		fi
	done < <(find -type f)

	# The OldUnreal patches currently lack localisation files for French,
	# Italian, and Korean even though some editions did include these. Move them
	# from System to SystemLocalized as recommended, but only if each has an
	# equivalent English (.int) file. Also match the casing of the English
	# filename for sanity and to avoid duplicates.
	(
		shopt -s extglob nocaseglob nullglob || die
		local lang match
		for lang in fr it ko; do
			mkdir -p SystemLocalized/${lang}t || die
			for file in System/*.${lang}t; do
				file=${file#*/}
				eval "match=( \"${BROOT}\"/opt/ut2004/SystemLocalized/int/?(${file%.*}.int) )"
				if [[ -n ${match[0]} ]]; then
					match=${match[0]##*/}
					mv -v "System/${file}" "SystemLocalized/${lang}t/${match%.int}.${lang}t" || die
				fi
			done
		done
	)

	insinto /opt/ut2004
	doins -r SystemLocalized

	# Drop any other non-localisation files not included in our listings for
	# cleanliness and consistency between installation sources. These listings
	# are (mostly) based on OldUnreal's installation.
	for file in "${FILESDIR}"/listings/*; do
		dir=${file##*/}
		find "${dir}" -type f ! -name "*.*_uax" | grep -Fxvf <(sed "s:^:${dir}/:" "${file}") | xargs -r rm -v -- || die
	done

	# https://github.com/OldUnreal/UT2004Patches/issues/514
	# We could regenerate the cache for the entire base game, but it's awkward,
	# so just cover the missing BP2 maps in a separate file.
	ut2004-ucc exportcache -mod=Gentoo Maps/*-BP2-*.ut2 || die
	mv -v System/{CacheRecords,BP2}.ucl || die

	for file in "${FILESDIR}"/listings/*; do
		doins -r "${file##*/}"
	done

	for dir in CSVs Logs Results; do
		keepdir /opt/ut2004/Benchmark/${dir}
	done
}
