# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-rpg/lure/lure-1.1.ebuild,v 1.6 2015/03/03 20:57:00 tupone Exp $

EAPI=5
inherit eutils games

DAT_PV=0.13.1
DESCRIPTION="Lure of the Temptress"
HOMEPAGE="http://www.revolution.co.uk/_display.php?id=10"
SRC_URI="
	http://scummvm.svn.sourceforge.net/svnroot/scummvm/scummvm/tags/release-0-13-1/dists/engine-data/lure.dat -> lure-${DAT_PV}.dat
	!linguas_en? ( !linguas_es? ( !linguas_fr? ( !linguas_de? ( !linguas_it?
		( mirror://sourceforge/scummvm/${P}.zip -> ${PN}-en-${PV}.zip ) ) ) ) )
	linguas_en? ( mirror://sourceforge/scummvm/${P}.zip  -> ${PN}-en-${PV}.zip )
	linguas_es? ( mirror://sourceforge/scummvm/${PN}-es-${PV}.zip )
	linguas_fr? ( mirror://sourceforge/scummvm/${PN}-fr-${PV}.zip )
	linguas_de? ( mirror://sourceforge/scummvm/${PN}-de-${PV}.zip )
	linguas_it? ( mirror://sourceforge/scummvm/${PN}-it-${PV}.zip )"

LICENSE="lure"
SLOT="0"
KEYWORDS="amd64 x86"
LANGS_IUSE="linguas_en linguas_es linguas_de linguas_fr linguas_it"
IUSE=${LANGS_IUSE}
RESTRICT="mirror"

RDEPEND=">=games-engines/scummvm-0.13.1"
DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}

any_linguas() {
	use linguas_en || use linguas_es || use linguas_de || use linguas_fr || use linguas_it
}

src_unpack() {
	local lang

	if any_linguas ; then
		for lang in ${LANGS_IUSE}
		do
			use ${lang} && unpack ${PN}-${lang/linguas_}-${PV}.zip
		done
		mv lure lure-en 2> /dev/null
	else
		unpack ${PN}-en-${PV}.zip
	fi
}

src_prepare() {
	local lang f

	find . \
		\( -iname "*exe" \
		-o -iname "*ega" \
		-o -iname LICENSE.txt \) \
		-exec rm -f '{}' +
	mkdir docs
	if any_linguas ; then
		for lang in ${LANGS_IUSE}
		do
			mkdir docs/${lang}
			find lure-${lang/linguas_} \
				\( -iname "*pdf" \
				-o -iname README \
				-o -iname "*txt" \) \
				-exec mv '{}' docs/${lang} \; 2> /dev/null
		done
	else
		find lure \
			\( -iname "*pdf" \
			-o -iname README \
			-o -iname "*txt" \) \
			-exec mv '{}' docs \; 2> /dev/null
	fi
	for f in $(find docs -type f)
	do
		mv ${f} ${f%.*}.$(echo ${f#*.} | tr '[[:upper:]]' '[[:lower:]]') 2> /dev/null
	done
}

src_install() {
	local lang

	if any_linguas ; then
		for lang in ${LANGS_IUSE}
		do
			if use ${lang} ; then
				lang=${lang/linguas_}
				insinto "${GAMES_DATADIR}"/${PN}-${lang}
				newins "${DISTDIR}"/lure-${DAT_PV}.dat lure.dat
				doins -r ${PN}-${lang}/*
				games_make_wrapper ${PN}-${lang} "scummvm -q ${lang} -f -p \"${GAMES_DATADIR}/${PN}-${lang}\" lure" .
				make_desktop_entry ${PN}-${lang} "Lure of the Temptress (${lang})" ${PN}
				docinto linguas_${lang}
				dodoc docs/linguas_${lang}/*
			fi
		done
	else
		insinto "${GAMES_DATADIR}"/${PN}
		newins "${DISTDIR}"/lure-${DAT_PV}.dat lure.dat
		doins -r ${PN}/*
		games_make_wrapper ${PN} "scummvm -f -p \"${GAMES_DATADIR}/${PN}\" lure" .
		make_desktop_entry ${PN} "Lure of the Temptress"
	fi
	prepgamesdirs
}
