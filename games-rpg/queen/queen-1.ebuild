# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-rpg/queen/queen-1.ebuild,v 1.3 2013/01/13 11:30:29 ago Exp $

EAPI=4
inherit eutils games

DESCRIPTION="Flight of the Amazon Queen - a 2D point-and-click adventure game set in the 1940s"
HOMEPAGE="http://scummvm.sourceforge.net/"
SF_BASE_URL="mirror://sourceforge/scummvm/"
LYS_BASE_URL="http://www.lysator.liu.se/~zino/scummvm/queen/"
FILE_DE="FOTAQ_Ger_talkie-1.0.zip"
FILE_EN="FOTAQ_Talkie-1.1.zip"
FILE_FR="FOTAQ_Fr_Talkie_1.0.zip"
FILE_HE="FOTAQ_Heb_talkie.zip"
FILE_IT="FOTAQ_It_Talkie_1.0.zip"
SRC_URI="
	linguas_de? (
		${SF_BASE_URL}${FILE_DE}
		${LYS_BASE_URL}readme.txt -> queen-readme.txt
	)
	linguas_en? (
		mp3? ( ${SF_BASE_URL}${FILE_EN} )
		!mp3? (
			${LYS_BASE_URL}queen.1.bz2
			${LYS_BASE_URL}readme.txt -> queen-readme.txt
		)
	)
	linguas_fr? ( ${SF_BASE_URL}${FILE_FR} )
	linguas_he? (
		${SF_BASE_URL}${FILE_HE}
		${LYS_BASE_URL}readme.txt -> queen-readme.txt
	)
	linguas_it? ( ${SF_BASE_URL}${FILE_IT} )
	http://www.scummvm.org/images/cat-queen.png
"

LICENSE="queen"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
IUSE="mp3 linguas_de +linguas_en linguas_fr linguas_he linguas_it"
REQUIRED_USE="|| ( linguas_de linguas_en linguas_fr linguas_he linguas_it )"

RDEPEND="
	linguas_de? ( games-engines/scummvm[vorbis] )
	linguas_en? ( games-engines/scummvm[mp3?] )
	linguas_fr? ( games-engines/scummvm[vorbis] )
	linguas_he? ( games-engines/scummvm[vorbis] )
	linguas_it? ( games-engines/scummvm[vorbis] )
"
DEPEND="${RDEPEND}
	linguas_de? ( app-arch/unzip )
	linguas_en? ( mp3? ( app-arch/unzip ) )
	linguas_fr? ( app-arch/unzip )
	linguas_he? ( app-arch/unzip )
	linguas_it? ( app-arch/unzip )
"

S=${WORKDIR}

src_unpack() {
	if use linguas_de ; then
		mkdir de
		unpack ${FILE_DE}
		mv queen.1c de/queen.1c
		rm COPYING
		cp "${DISTDIR}"/queen-readme.txt de/readme.txt
	fi
	if use linguas_en ; then
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
	if use linguas_fr ; then
		mkdir fr
		unpack ${FILE_FR}
		mv queen.1c fr/queen.1c
		mv readme.txt fr/readme.txt
	fi
	if use linguas_he ; then
		mkdir he
		unpack ${FILE_HE}
		mv queen.1c he/queen.1c
		rm COPYING
		cp "${DISTDIR}"/queen-readme.txt he/readme.txt
	fi
	if use linguas_it ; then
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
	if use linguas_de ; then
		games_make_wrapper queen-de "scummvm -f -p \"${GAMES_DATADIR}/${PN}/de\" queen" .
		make_desktop_entry ${PN}-de "Flight of the Amazon Queen (German)" queen
	fi
	if use linguas_en ; then
		games_make_wrapper queen-en "scummvm -f -p \"${GAMES_DATADIR}/${PN}/en\" queen" .
		make_desktop_entry ${PN}-en "Flight of the Amazon Queen (English)" queen
	fi
	if use linguas_fr ; then
		games_make_wrapper queen-fr "scummvm -f -p \"${GAMES_DATADIR}/${PN}/fr\" queen" .
		make_desktop_entry ${PN}-fr "Flight of the Amazon Queen (French)" queen
	fi
	if use linguas_he ; then
		games_make_wrapper queen-he "scummvm -f -p \"${GAMES_DATADIR}/${PN}/he\" queen" .
		make_desktop_entry ${PN}-he "Flight of the Amazon Queen (Hebrew)" queen
	fi
	if use linguas_it ; then
		games_make_wrapper queen-it "scummvm -f -p \"${GAMES_DATADIR}/${PN}/it\" queen" .
		make_desktop_entry ${PN}-it "Flight of the Amazon Queen (Italian)" queen
	fi
	prepgamesdirs
}
