# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-rpg/drascula/drascula-1.0-r2.ebuild,v 1.3 2014/08/10 17:37:05 ago Exp $

EAPI=5
inherit eutils games

INT_PV=1.1
INT_URI="mirror://sourceforge/scummvm/drascula-int-${INT_PV}.zip"
DAT_PV=1.5.0
AUD_PV=2.0
DESCRIPTION="Drascula: The Vampire Strikes Back"
HOMEPAGE="http://www.alcachofasoft.com/"
SRC_URI="mirror://sourceforge/scummvm/drascula-${PV}.zip
	https://github.com/scummvm/scummvm/raw/v1.5.0/dists/engine-data/drascula.dat -> drascula-${DAT_PV}.dat
	sound? ( mirror://sourceforge/scummvm/drascula-audio-${AUD_PV}.zip )
	linguas_es? ( ${INT_URI} )
	linguas_de? ( ${INT_URI} )
	linguas_fr? ( ${INT_URI} )
	linguas_it? ( ${INT_URI} )"

LICENSE="drascula"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="linguas_es linguas_de linguas_fr linguas_it +sound"
RESTRICT="mirror"

RDEPEND=">=games-engines/scummvm-0.13.1"
DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}

src_unpack() {
	if use linguas_es || use linguas_de || use linguas_fr || use linguas_it; then
		unpack drascula-int-${INT_PV}.zip
	fi
	if use sound; then
		unpack drascula-audio-${AUD_PV}.zip
	fi
	unpack drascula-${PV}.zip
}

src_install() {
	local lang

	games_make_wrapper ${PN} "scummvm -f -p \"${GAMES_DATADIR}/${PN}\" drascula" .
	for lang in es de fr it
	do
		if use linguas_${lang} ; then
			games_make_wrapper ${PN}-${lang} "scummvm -q ${lang} -f -p \"${GAMES_DATADIR}/${PN}\" drascula" .
			make_desktop_entry ${PN}-${lang} "Drascula: The Vampire Strikes Back (${lang})" ${PN}
		fi
	done
	insinto "${GAMES_DATADIR}"/${PN}
	find . -name "P*.*" -execdir doins '{}' +
	newins "${DISTDIR}"/drascula-${DAT_PV}.dat drascula.dat
	if use sound; then
		doins audio/*
	fi
	dodoc readme.txt drascula.doc
	make_desktop_entry ${PN} "Drascula: The Vampire Strikes Back"
	prepgamesdirs
}
