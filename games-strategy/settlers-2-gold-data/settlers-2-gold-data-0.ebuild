# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CDROM_OPTIONAL="yes"
inherit cdrom estack

# For GOG install
MY_EXE="setup_the_settlers_2_gold_1.5.1_(30319).exe"

DESCRIPTION="Data files for The Settlers II: Gold Edition"
HOMEPAGE="https://www.gog.com/game/the_settlers_2_gold_edition"
# There are non-English GOG downloads but RTTR uses its own translations.
SRC_URI="!cdinstall? ( ${MY_EXE} )"
LICENSE="!cdinstall? ( GOG-EULA ) cdinstall? ( all-rights-reserved )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="bindist !cdinstall? ( fetch )"

RDEPEND="
	games-strategy/s25rttr
"

BDEPEND="
	!cdinstall? ( >=app-arch/innoextract-1.8 )
"

S="${WORKDIR}/target"

pkg_nofetch() {
	einfo "Please buy and download ${MY_EXE} from:"
	einfo "  https://www.gog.com/game/the_settlers_2_gold_edition"
	einfo "and move it to your distfiles directory."
	echo
	einfo "If you wish to install from CD-ROM instead, please enable the cdinstall flag."
}

dotar() {
	eshopts_push -s globstar nocaseglob nullglob

	# Uppercase
	# Avoid copying files twice
	# Don't include *.ENG or *.GER files as they are unused by RTTR

	tar c \
		--mode=u+w \
		--ignore-case \
		--xform='s:.*:\U\0:x' \
		--exclude-from=<(find "${S}"/ -type f -printf "%P\n" 2>/dev/null) \
		{DATA,GFX}/**/*.{BBM,BOB,DAT,FNT,IDX,LBM,LST,RTX,WLD} \
		| tar x -C "${S}"

	assert "tar failed"
	eshopts_pop
}

src_unpack() {
	unset CDROM_SET
	mkdir -p "${S}" || die

	if use cdinstall; then
		default
		cdrom_get_cds S2/GFX/PICS/MISSION/AFRICA.LBM:GFX/PICS/MISSION/AFRICA.LBM:S2/GFX/PICS/SETUP010.LBM ::S2/S2/GFX/PICS/MISSION/AFRICA.LBM

		case ${CDROM_SET} in
			0)
				einfo "Found The Settlers II: Gold Edition CD"
				cd "${CDROM_ROOT}"/[Ss]2 || die ;;
			1)
				einfo "Found The Settlers II: Gold Edition installation"
				cd "${CDROM_ROOT}" || die ;;
			2)
				einfo "Found The Settlers II: Veni, Vidi, Vici CD"
				cd "${CDROM_ROOT}/"[Ss]2 || die ;;
		esac
	else
		einfo "Unpacking ${MY_EXE}."
		innoextract -e -s -p1 -I DATA -I GFX -d gog "${DISTDIR}/${MY_EXE}" || die
		cd gog || die
	fi

	dotar

	if [[ ${CDROM_SET} == 2 ]]; then
		cdrom_load_next_cd
		einfo "Found The Settlers II: Mission CD"
		cd "${CDROM_ROOT}"/[Ss]2/[Ss]2 || die
		dotar
	fi
}

src_install() {
	insinto /usr/share/s25rttr/S2
	doins -r *
}
