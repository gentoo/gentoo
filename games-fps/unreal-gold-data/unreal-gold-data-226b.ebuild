# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CDROM_OPTIONAL="yes"
inherit cdrom check-reqs

DESCRIPTION="Data files for Unreal and Return to Na Pali"
HOMEPAGE="https://liandri.beyondunreal.com/Unreal_Gold"
GOG="setup_unreal_gold_2.0.0.6.exe"
SRC_URI="
	!cdinstall? ( !gog? ( fetch+https://files.oldunreal.net/UNREAL_GOLD.ISO -> UNREAL_GOLD.iso ) )
	gog? ( ${GOG} )
"
S="${WORKDIR}"

LICENSE="Epic-TOS" # See metadata.xml for the legal background.
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="doc gog l10n_de l10n_es l10n_fr l10n_it"
RESTRICT="bindist gog? ( fetch ) mirror"
REQUIRED_USE="?? ( cdinstall gog )"

UT_DEPEND=">=games-fps/unreal-227k_p14"

BDEPEND="
	${UT_DEPEND}
	cdinstall? ( app-arch/unshield )
	gog? ( app-arch/innoextract )
	!gog? ( app-arch/libarchive )
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
		*.det|*/det/*|1_UnrealGold_*_German) ! use l10n_de ;;
		*.est|*/est/*|1_UnrealGold_*_Spanish) ! use l10n_es ;;
		*.frt|*/frt/*|1_UnrealGold_*_French)  ! use l10n_fr ;;
		*.itt|*/itt/*|1_UnrealGold_*_Italian) ! use l10n_it ;;
		*) return 1 ;;
	esac
}

src_unpack() {
	if use gog; then
		if use l10n_de || use l10n_es || use l10n_fr || use l10n_it; then
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
			CD_ROOT="${DISTDIR}/UNREAL_GOLD.iso"
		fi

		# The German Midway DVD doesn't include UT99.
		cdrom_get_cds Manuals/UnrealTournament_English.pdf:autorund/unreal.ico:MAPS/Vortex2.unr

		case ${CDROM_SET} in
			0) einfo "Found Midway Unreal Anthology DVD" ;;
			1) einfo "Found German Midway Unreal Anthology DVD" ;;
			2) einfo "Found Unreal Gold CD" ;;
		esac

		local group dir cdnum
		case ${CDROM_SET} in
			0|1)
				# Symlinks for unshield. These files need to be in the same
				# directory but on the disk, they are not for some reason.
				ln -snf "${CDROM_ROOT}"/{Disk1/data1.hdr,Disk*/data*.cab} "${T}"/ || die

				for group in $(unshield g "${T}"/data1.cab || die); do
					case ${group} in
						1_UnrealGold_System_All) : ;;
						1_UnrealGold_EXE|1_UnrealGold_Manual_*|1_UnrealGold_System_*) continue ;;
						1_UnrealGold_*) : ;;
						*) continue ;;
					esac
					locale_mismatch "${group}" && continue
					unshield -g "${group}" x "${T}"/data1.cab || die
				done

				for dir in 1_UnrealGold_*; do
					mv -v "${dir}" "${dir#1_UnrealGold_}" || die
				done

				mkdir -p Sounds/{de,es,fr,in,it}t || die
				mv -v Sounds_English/*.uax Sounds/int/ || die
				use l10n_de && { mv -v Sounds_German/*.uax Sounds/det/ || die; }
				use l10n_es && { mv -v Sounds_Spanish/*.uax Sounds/est/ || die; }
				use l10n_fr && { mv -v Sounds_French/*.uax Sounds/frt/ || die; }
				use l10n_it && { mv -v Sounds_Italian/*.uax Sounds/itt/ || die; }

				for dir in *_*/; do
					mkdir -p "${dir%_*}" || die
					tar -C "${dir}" --remove-files -cf - . | tar -C "${dir%_*}" -xvf - || die
				done
				;;

			2)
				# Convert uppercased directories to mixed case while copying.
				tar -C "${CDROM_ROOT}" --mode=u+w --xform='s:\./(.)([^/]*):\u\1\L\2:x' -cf - . | tar -xvf - || die
				;;
		esac
	fi
}

src_install() {
	local dir file

	if use doc; then
		case ${CDROM_SET} in
			0|1)
				newdoc "${CDROM_ROOT}"/Manuals/Unreal_English.pdf Manual.pdf
				use l10n_fr && newdoc "${CDROM_ROOT}"/Manuals/Français/Unreal.pdf Manual_fr.pdf ;;
			2)
				newdoc "Manuals/Unreal manual.pdf" Manual.pdf
				newdoc "Manuals/Unreal NaPali Manual.pdf" "Return to Na Pali Manual.pdf" ;;
			*)
				dodoc Manual/Manual.pdf ;;
		esac
	fi

	# Drop unwanted localisation files.
	while read -r file; do
		if locale_mismatch "${file}"; then
			rm -v "${file}" || die
		fi
	done < <(find -type f)

	insinto /opt/unreal

	# Drop any other non-localisation files not included in our listings for
	# cleanliness and consistency between installation sources. These listings
	# are (mostly) based on OldUnreal's installation.
	for file in "${FILESDIR}"/listings/*; do
		dir=${file##*/}
		find "${dir}" -type f | grep -Fxvf <(sed -r -e "s:^:${dir}/:" -e 's:(.*)/int/(.*\.uax)$:\0\n\1/det/\2\n\1/est/\2\n\1/frt/\2\n\1/itt/\2:' "${file}") | xargs -r rm -v -- || die
		doins -r "${dir}"
	done
}

pkg_postinst() {
	einfo "Much better textures are available from the Unreal HD Textures project."
	einfo "You can simply extract their .utx files into ~/.Unreal/Textures."
}
