# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
	l10n_es? ( ${INT_URI} )
	l10n_de? ( ${INT_URI} )
	l10n_fr? ( ${INT_URI} )
	l10n_it? ( ${INT_URI} )"

LICENSE="drascula"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="l10n_es l10n_de l10n_fr l10n_it +sound"
RESTRICT="mirror"

RDEPEND=">=games-engines/scummvm-0.13.1"
DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}

src_unpack() {
	if use l10n_es || use l10n_de || use l10n_fr || use l10n_it; then
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
		if use l10n_${lang} ; then
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
