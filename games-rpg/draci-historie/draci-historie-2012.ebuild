# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit unpacker eutils games

DESCRIPTION="Bert the little dragon searches for his father"
HOMEPAGE="http://www.ucw.cz/draci-historie/index-en.html"
BASE_URL="http://www.ucw.cz/draci-historie/binary/dh"
SRC_URI="linguas_cs? ( ${BASE_URL}-cz-${PV}.zip )
	linguas_de? ( ${BASE_URL}-de-${PV}.zip )
	linguas_en? ( ${BASE_URL}-en-${PV}.zip )
	linguas_pl? ( ${BASE_URL}-pl-${PV}.zip )
	!linguas_cs? ( !linguas_de? ( !linguas_en? ( !linguas_pl? ( ${BASE_URL}-en-${PV}.zip ) ) ) )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="linguas_cs linguas_de linguas_en linguas_pl"

RDEPEND=">=games-engines/scummvm-1.1"
DEPEND="$(unpacker_src_uri_depends)"

S=${WORKDIR}

src_unpack() {
	if use linguas_en || ( ! use linguas_cs && ! use linguas_de && ! use linguas_en && ! use linguas_pl ) ; then
		mkdir en || die
		unpacker dh-en-${PV}.zip
		mv *.{dfw,fon,mid,sam} en/ || die
	fi
	if use linguas_cs ; then
		mkdir cs || die
		unpacker dh-cz-${PV}.zip
		mv *.{dfw,fon,mid,sam,zzz} cs/ || die
	fi
	if use linguas_de ; then
		mkdir de || die
		unpacker dh-de-${PV}.zip
		mv *.{dfw,fon,mid,sam} de/ || die
	fi
	if use linguas_pl ; then
		mkdir pl || die
		unpacker dh-pl-${PV}.zip
		mv *.{dfw,fon,mid,sam,zzz} pl/ || die
	fi
}

src_prepare() {
	rm -f *.{bat,exe,ins} readme.* || die
}

src_install() {
	newicon bert.ico draci-historie.ico
	insinto "${GAMES_DATADIR}"/${PN}
	for lingua in $(find * -type d); do
		doins -r ${lingua}
	done
	if use linguas_en || ( ! use linguas_cs && ! use linguas_de && ! use linguas_en && ! use linguas_pl ) ; then
		games_make_wrapper draci-historie-en "scummvm -f -p \"${GAMES_DATADIR}/${PN}/en\" draci" .
		make_desktop_entry ${PN}-en "Dračí Historie (English)" /usr/share/pixmaps/draci-historie.ico
	fi
	if use linguas_cs ; then
		games_make_wrapper draci-historie-cs "scummvm -f -p \"${GAMES_DATADIR}/${PN}/cs\" draci" .
		make_desktop_entry ${PN}-cs "Dračí Historie (Čeština)" /usr/share/pixmaps/draci-historie.ico
	fi
	if use linguas_de ; then
		games_make_wrapper draci-historie-de "scummvm -f -p \"${GAMES_DATADIR}/${PN}/de\" draci" .
		make_desktop_entry ${PN}-de "Dračí Historie (Deutsch)"  /usr/share/pixmaps/draci-historie.ico
	fi
	if use linguas_pl ; then
		games_make_wrapper draci-historie-pl "scummvm -f -p \"${GAMES_DATADIR}/${PN}/pl\" draci" .
		make_desktop_entry ${PN}-pl "Dračí Historie (Polski)"  /usr/share/pixmaps/draci-historie.ico
	fi
	prepgamesdirs
}
