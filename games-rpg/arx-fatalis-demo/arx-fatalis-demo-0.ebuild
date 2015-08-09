# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils games

DESCRIPTION="Arx Fatalis demo"
HOMEPAGE="http://www.arkane-studios.com/uk/arx.php"
SRC_URI="arx_demo_english.zip"

LICENSE="ArxFatalisDemo"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
RESTRICT="fetch"

RDEPEND="games-rpg/arx-libertatis"
DEPEND="app-arch/cabextract
	app-arch/unzip"

S=${WORKDIR}

pkg_nofetch() {
	einfo "Please find and download ${SRC_URI} and put it into ${DISTDIR}."
	einfo "There is a list of possible download locations at"
	einfo "http://wiki.arx-libertatis.org/Getting_the_game_data#Demo"
}

src_unpack() {
	unpack ${A}
	cabextract Setup1.cab || die "cabextract failed"
	cabextract Setup2.cab || die "cabextract failed"
	cabextract Setup3.cab || die "cabextract failed"
}

src_install() {
	insinto "${GAMES_DATADIR}/${PN}"
	doins -r *.pak bin/*.pak
	insinto "${GAMES_DATADIR}/${PN}/misc"
	doins bin/Logo.bmp bin/Arx.ttf

	# convert to lowercase
	cd "${D}"
	find . -type f -exec sh -c 'echo "${1}"
	lower="`echo "${1}" | tr [:upper:] [:lower:]`"
	[ "${1}" = "${lower}" ] || mv "${1}" "${lower}"' - {} \;

	make_desktop_entry "arx --data-dir=${GAMES_DATADIR}/arx-fatalis-demo" \
		"Arx Fatalis Demo" arx-libertatis

	prepgamesdirs
}
