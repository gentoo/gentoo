# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils games

DESCRIPTION="Flight of the Amazon Queen - 2D point-and-click adventure game set in the 1940s"
HOMEPAGE="http://scummvm.sourceforge.net/"
SF_BASE_URL="mirror://sourceforge/scummvm/"
LYS_BASE_URL="http://www.lysator.liu.se/~zino/scummvm/queen/"
FILE_DE="FOTAQ_Ger_talkie-1.0.zip"
FILE_EN="FOTAQ_Talkie-1.1.zip"
FILE_FR="FOTAQ_Fr_Talkie_1.0.zip"
FILE_HE="FOTAQ_Heb_talkie.zip"
FILE_IT="FOTAQ_It_Talkie_1.0.zip"
SRC_URI="
	l10n_de? (
		${SF_BASE_URL}${FILE_DE}
		${LYS_BASE_URL}readme.txt -> queen-readme.txt
	)
	l10n_en? (
		mp3? ( ${SF_BASE_URL}${FILE_EN} )
		!mp3? (
			${LYS_BASE_URL}queen.1.bz2
			${LYS_BASE_URL}readme.txt -> queen-readme.txt
		)
	)
	l10n_fr? ( ${SF_BASE_URL}${FILE_FR} )
	l10n_he? (
		${SF_BASE_URL}${FILE_HE}
		${LYS_BASE_URL}readme.txt -> queen-readme.txt
	)
	l10n_it? ( ${SF_BASE_URL}${FILE_IT} )
	http://www.scummvm.org/images/cat-queen.png
"

LICENSE="queen"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE="mp3 l10n_de +l10n_en l10n_fr l10n_he l10n_it"
REQUIRED_USE="|| ( l10n_de l10n_en l10n_fr l10n_he l10n_it )"

RDEPEND="
	l10n_de? ( games-engines/scummvm[vorbis] )
	l10n_en? ( games-engines/scummvm[mp3?] )
	l10n_fr? ( games-engines/scummvm[vorbis] )
	l10n_he? ( games-engines/scummvm[vorbis] )
	l10n_it? ( games-engines/scummvm[vorbis] )
"
DEPEND="${RDEPEND}
	l10n_de? ( app-arch/unzip )
	l10n_en? ( mp3? ( app-arch/unzip ) )
	l10n_fr? ( app-arch/unzip )
	l10n_he? ( app-arch/unzip )
	l10n_it? ( app-arch/unzip )
"

S=${WORKDIR}

src_unpack() {
	if use l10n_de ; then
		mkdir de
		unpack ${FILE_DE}
		mv queen.1c de/queen.1c
		rm COPYING
		cp "${DISTDIR}"/queen-readme.txt de/readme.txt
	fi
	if use l10n_en ; then
		mkdir en
		if use mp3 ; then
			unpack ${FILE_EN}
			mv queen.1c en/queen.1c
			mv readme.txt en/readme.txt
		else
			unpack queen.1.bz2
			mv queen.1 en/queen.1
			cp "${DISTDIR}"/queen-readme.txt en/readme.txt
		fi
	fi
	if use l10n_fr ; then
		mkdir fr
		unpack ${FILE_FR}
		mv queen.1c fr/queen.1c
		mv readme.txt fr/readme.txt
	fi
	if use l10n_he ; then
		mkdir he
		unpack ${FILE_HE}
		mv queen.1c he/queen.1c
		rm COPYING
		cp "${DISTDIR}"/queen-readme.txt he/readme.txt
	fi
	if use l10n_it ; then
		mkdir it
		unpack ${FILE_IT}
		mv queen.1c it/queen.1c
		mv readme.txt it/readme.txt
	fi
}

src_install() {
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r *
	newicon "${DISTDIR}"/cat-queen.png queen.png
	if use l10n_de ; then
		games_make_wrapper queen-de "scummvm -f -p \"${GAMES_DATADIR}/${PN}/de\" queen" .
		make_desktop_entry ${PN}-de "Flight of the Amazon Queen (German)" queen
	fi
	if use l10n_en ; then
		games_make_wrapper queen-en "scummvm -f -p \"${GAMES_DATADIR}/${PN}/en\" queen" .
		make_desktop_entry ${PN}-en "Flight of the Amazon Queen (English)" queen
	fi
	if use l10n_fr ; then
		games_make_wrapper queen-fr "scummvm -f -p \"${GAMES_DATADIR}/${PN}/fr\" queen" .
		make_desktop_entry ${PN}-fr "Flight of the Amazon Queen (French)" queen
	fi
	if use l10n_he ; then
		games_make_wrapper queen-he "scummvm -f -p \"${GAMES_DATADIR}/${PN}/he\" queen" .
		make_desktop_entry ${PN}-he "Flight of the Amazon Queen (Hebrew)" queen
	fi
	if use l10n_it ; then
		games_make_wrapper queen-it "scummvm -f -p \"${GAMES_DATADIR}/${PN}/it\" queen" .
		make_desktop_entry ${PN}-it "Flight of the Amazon Queen (Italian)" queen
	fi
	prepgamesdirs
}
