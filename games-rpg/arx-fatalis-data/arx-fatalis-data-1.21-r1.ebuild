# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-rpg/arx-fatalis-data/arx-fatalis-data-1.21-r1.ebuild,v 1.3 2013/01/30 19:08:34 ago Exp $

EAPI=4

inherit eutils cdrom check-reqs games

DESCRIPTION="Arx Fatalis data files"
HOMEPAGE="http://www.arkane-studios.com/uk/arx.php"
SRC_URI="http://download.zenimax.com/arxfatalis/patches/1.21/ArxFatalis_1.21_MULTILANG.exe"

LICENSE="ArxFatalis-EULA-JoWooD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="games-rpg/arx-libertatis"
DEPEND="app-arch/cabextract
	app-arch/innoextract"

LANGS="linguas_de +linguas_en linguas_es linguas_fr linguas_it linguas_ru"
IUSE="$IUSE $LANGS"
REQUIRED_USE="^^ ( ${LANGS//+/} )"

CHECKREQS_DISK_BUILD="621M"
CHECKREQS_DISK_USR="617M"

S=${WORKDIR}

src_unpack() {
	cdrom_get_cds bin/Arx.ttf

	local mylang
	case ${LINGUAS} in
		de) mylang="german" ;;
		en) mylang="english" ;;
		es) mylang="spanish" ;;
		fr) mylang="french" ;;
		it) mylang="italian" ;;
		ru) mylang="russian" ;;
	esac
	elog "Chosen language is ${mylang}"

	find "${CDROM_ROOT}" -iname "setup*.cab" -exec cabextract '{}' \;
	innoextract --lowercase --language=${mylang} \
		"${DISTDIR}"/ArxFatalis_1.21_MULTILANG.exe || die
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

pkg_postinst() {
	elog "You need Arx Fatalis in the chosen language, otherwise set it in package.use!"
	games_pkg_postinst
}
