# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CDROM_OPTIONAL="yes"
inherit cdrom check-reqs multiprocessing

DESCRIPTION="Data files for Unreal Tournament (99)"
HOMEPAGE="https://liandri.beyondunreal.com/Unreal_Tournament"
GOG="setup_ut_goty_2.0.0.5.exe"
SRC_URI="
	fetch+https://files.oldunreal.net/utbonuspack4-zip.7z
	!cdinstall? ( !gog? ( fetch+https://files.oldunreal.net/UT_GOTY_CD1.ISO -> UT_GOTY_CD1.iso ) )
	gog? ( ${GOG} )
	bonuspacks? (
		fetch+https://unreal-archive-files-na.s3.ca-east-tor.io.cloud.ovh.net/managed/Unreal%20Tournament/patches-updates/bonus-packs/utbonuspack-zip.zip
		fetch+https://unreal-archive-files-na.s3.ca-east-tor.io.cloud.ovh.net/managed/Unreal%20Tournament/patches-updates/bonus-packs/utbonuspack2.zip
		fetch+https://unreal-archive-files-na.s3.ca-east-tor.io.cloud.ovh.net/managed/Unreal%20Tournament/patches-updates/bonus-packs/utbonuspack3-zip.zip
	)
"
S="${WORKDIR}"

LICENSE="Epic-TOS" # See metadata.xml for the legal background.
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="bonuspacks doc gog l10n_es l10n_fr l10n_it"
RESTRICT="bindist gog? ( fetch ) mirror"
REQUIRED_USE="
	?? ( cdinstall gog )
	!cdinstall? ( !bonuspacks )
"

UT_DEPEND=">=games-fps/unreal-tournament-469e"

BDEPEND="
	${UT_DEPEND}
	app-arch/libarchive
	cdinstall? ( app-arch/unshield )
	gog? ( app-arch/innoextract )
"
RDEPEND="
	${UT_DEPEND}
"

# Assuming the OldUnreal ISO.
CHECKREQS_DISK_BUILD="2G"

pkg_nofetch() {
	einfo "Please download ${GOG} from GOG and move it"
	einfo "to your distfiles directory. Note that you can no longer buy this"
	einfo "game from GOG, so disable USE=\"gog\" to use OldUnreal's free ISO if"
	einfo "you don't already own the game."
}

locale_mismatch() {
	case "${1}" in
		*.est|*.est_*|3_UnrealTournament_*_Spanish) ! use l10n_es ;;
		*.frt|*.frt_*|3_UnrealTournament_*_French)  ! use l10n_fr ;;
		*.itt|*.itt_*|3_UnrealTournament_*_Italian) ! use l10n_it ;;
		*) return 1 ;;
	esac
}

src_unpack() {
	if use gog; then
		if use l10n_es || use l10n_fr || use l10n_it; then
			ewarn "The GOG edition lacks localised audio. Please disable USE=\"gog\" if you"
			ewarn "would prefer to use a free game download that does include this content."
			echo
		fi

		ln -s . app || die
		innoextract --extract --include app "${DISTDIR}/${GOG}" || die
	else
		if use cdinstall; then
			ewarn "It is no longer necessary to install this from CD or DVD. Please"
			ewarn "disable USE=\"cdinstall\" if you would prefer to download the game for"
			ewarn "free."
			echo
		else
			# We might as well handle a downloaded ISO and a user-provided ISO
			# the same way through cdrom.eclass.
			CD_ROOT="${DISTDIR}/UT_GOTY_CD1.iso"
		fi

		# The German Midway DVD doesn't include UT99.
		cdrom_get_cds Manuals/UnrealTournament_English.pdf:Maps/DM-SpaceNoxx.unr.uz:Maps/DM-Pressure.unr

		case ${CDROM_SET} in
			0) einfo "Found Midway Unreal Anthology DVD" ;;
			1) einfo "Found Unreal Tournament Game of the Year Edition CD" ;;
			2) einfo "Found Unreal Tournament original CD" ;;
		esac

		case ${CDROM_SET} in
			2)
				if ! use bonuspacks; then
					die "Your installation source lacks Bonus Packs 1 to 3. Please enable USE=\"bonuspacks\" to download them."
				fi ;;
			*)
				if use bonuspacks; then
					ewarn "Enabling USE=\"bonuspacks\" just downloads unnecessary files with"
					ewarn "this installation source. Please disable it."
				fi ;;
		esac

		local group dir cdnum
		case ${CDROM_SET} in
			0)
				# Symlinks for unshield. These files need to be in the same
				# directory but on the disk, they are not for some reason.
				ln -snf "${CDROM_ROOT}"/{Disk1/data1.hdr,Disk*/data*.cab} "${T}"/ || die

				for group in $(unshield g "${T}"/data1.cab || die); do
					case ${group} in
						3_UnrealTournament_System_All) : ;;
						3_UnrealTournament_EXE|3_UnrealTournament_Manual_*|3_UnrealTournament_NetGamesUSA|3_UnrealTournament_System_*|3_UnrealTournament_Web) continue ;;
						3_UnrealTournament_*) : ;;
						*) continue ;;
					esac
					locale_mismatch "${group}" && continue
					unshield -g "${group}" x "${T}"/data1.cab || die
				done

				for dir in 3_UnrealTournament_*; do
					mv -v "${dir}" "${dir#3_UnrealTournament_}" || die
				done

				use l10n_es && { rename -v .uax .est_uax Sounds_Spanish/*.uax || die; }
				use l10n_fr && { rename -v .uax .frt_uax Sounds_French/*.uax || die; }
				use l10n_it && { rename -v .uax .itt_uax Sounds_Italian/*.uax || die; }

				for dir in *_*/; do
					mkdir -p "${dir%_*}" || die
					tar -C "${dir}" --remove-files -cf - . | tar -C "${dir%_*}" -xvf - || die
				done
				;;

			1)
				tar -C "${CDROM_ROOT}" --mode=u+w -cf - . | tar -xvf - || die

				# The engine has the decompresser for the maps. TODO: Use the
				# new -samefolder option when bumping the engine to 469f.
				unreal-tournament-ucc &>/dev/null || die # Create ~/.utpg early to avoid race.
				ls Maps/*.unr.uz | xargs -P "$(get_makeopts_jobs)" -ti unreal-tournament-ucc decompress "${PWD}"/{} >/dev/null || die
				mv -v ~/.utpg/System/*.unr Maps/ || die
				rm -v Maps/*.unr.uz || die
				;;

			2)
				tar -C "${CDROM_ROOT}" --mode=u+w -cf - . | tar -xvf - || die

				# Extract Bonus Packs 1-3, which were included in GOTY Edition.
				bsdtar --strip-components=1 -xvf "${DISTDIR}"/utbonuspack-zip.zip || die
				bsdtar -C Maps -xvf "${DISTDIR}"/utbonuspack2.zip \*.unr || die
				bsdtar --strip-components=1 -xvf "${DISTDIR}"/utbonuspack3-zip.zip || die
				mv system/* System/ || die
				mv textures/* Textures/ || die
				;;
		esac

		# Filename casing of localised audio needs to match the English version.
		mv -v Sounds/{OpeningWave,openingwave}.est_uax || die
	fi

	# None of the installation sources include Bonus Pack 4, but OldUnreal's
	# installer includes it, so we should too.
	bsdtar -xvf "${DISTDIR}"/utbonuspack4-zip.7z || die
}

src_install() {
	local dir file

	if use doc; then
		case ${CDROM_SET} in
			0) newdoc "${CDROM_ROOT}"/Manuals/UnrealTournament_English.pdf Manual.pdf ;;
			1|2) : ;; # No PDF
			*) dodoc Manual/Manual.pdf ;;
		esac
	fi

	# Drop unwanted localisation files.
	while read -r file; do
		if locale_mismatch "${file}"; then
			rm -v "${file}" || die
		fi
	done < <(find -type f)

	insinto /opt/unreal-tournament
	keepdir /opt/unreal-tournament/Logs

	# Drop any other non-localisation files not included in our listings for
	# cleanliness and consistency between installation sources. These listings
	# are (mostly) based on OldUnreal's installation.
	for file in "${FILESDIR}"/listings/*; do
		dir=${file##*/}
		find "${dir}" -type f | grep -Fxvf <(sed -r -e "s:^:${dir}/:" -e 's:(.*)\.uax$:\1.uax\n\1.est_uax\n\1.frt_uax\n\1.itt_uax:' "${file}") | xargs -r rm -v -- || die
		doins -r "${dir}"
	done

	# The same map with different filenames works for Deathmatch and Domination.
	dosym "DM-Cybrosis][.unr" "/opt/unreal-tournament/Maps/DOM-Cybrosis][.unr"
}

pkg_postinst() {
	einfo "Much better textures are available from the Unreal HD Textures project."
	einfo "You can simply extract their .utx files into ~/.utpg/Textures."
}
