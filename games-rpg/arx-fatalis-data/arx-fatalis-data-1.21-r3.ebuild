# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

CDROM_OPTIONAL="yes"
inherit eutils cdrom check-reqs games

DESCRIPTION="Arx Fatalis data files"
HOMEPAGE="http://www.arkane-studios.com/uk/arx.php"
SRC_URI="cdinstall? ( http://download.zenimax.com/arxfatalis/patches/1.21/ArxFatalis_1.21_MULTILANG.exe )
	gog? ( setup_arx_fatalis_2.0.0.7.exe )"

LICENSE="cdinstall? ( ArxFatalis-EULA-JoWooD ) gog? ( GOG-EULA )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gog"
REQUIRED_USE="^^ ( cdinstall gog )"
RESTRICT="binchecks mirror gog? ( fetch )"

RDEPEND="games-rpg/arx-libertatis"
DEPEND="app-arch/innoextract
	cdinstall? ( app-arch/cabextract )"

CHECKREQS_DISK_BUILD="621M"
CHECKREQS_DISK_USR="617M"

S=${WORKDIR}

detect_language() {
	speech_checksum=$(find '.' -iname "speech.pak" \
		-exec md5sum -b '{}' \; | sed "s/ .*//g")
	if [[ -z $speech_checksum ]] ; then
		speech_checksum=$(find '.' -iname "speech_default.pak" \
			-exec md5sum -b '{}' \; | sed "s/ .*//g")
	fi

	# check if the checksum is of a known localisation and set data_lang to
	# the language string to be used with the 1.21 patch installer
	case "$speech_checksum" in
		'4c3fdb1f702700255924afde49081b6e') data_lang='german' ;;
		# Bundled version of AF included with NVIDIA card
		'ab8a93161688d793a7c78fbefd7d133e') data_lang='german' ;;
		'4e8f962d8204bcfd79ce6f3226d6d6de') data_lang='english' ;;
		'2f88c67ae1537919e69386d27583125b') data_lang='spanish' ;;
		'4edf9f8c799190590b4cd52cfa5f91b1') data_lang='french' ;;
		'81f05dea47c52d43f01c9b44dd8fe962') data_lang='italian' ;;
		'677163bc319cd1e9aa1b53b5fb3e9402') data_lang='russian' ;;
		'') eerror "speech*.pak not found"
			die "speech*.pak not found" ;;
		*) eerror "unsupported data language - speech*.pak checksum:" \
		        "$speech_checksum" \
				"please file a gentoo bug"
			die "unsupported data language, file a gentoo bug" ;;
	esac
}

pkg_nofetch() {
	einfo "Please download ${A} from your GOG.com account after buying Arx Fatalis"
	einfo "and put it into ${DISTDIR}."
}

src_unpack() {
	local data_lang

	if use cdinstall ; then
		cdrom_get_cds bin/Arx.ttf
		find "${CDROM_ROOT}" -iname "setup*.cab" -exec cabextract '{}' \;
		detect_language
	else
		# gog only offers english
		data_lang="english"
	fi

	einfo "Data language: $data_lang"
	innoextract --lowercase --language=${data_lang} \
		"${DISTDIR}"/${A} || die
}

src_install() {
	insinto "${GAMES_DATADIR}"/arx
	doins -r app/{graph,misc}
	find . -iname "*.pak" -exec doins '{}' \;

	dodoc app/{manual,map}.pdf

	# convert to lowercase
	cd "${D}"
	find . -type f -exec sh -c 'echo "${1}"
	lower="`echo "${1}" | tr [:upper:] [:lower:]`"
	[ "${1}" = "${lower}" ] || mv "${1}" "${lower}"' - {} \;

	prepgamesdirs
}
