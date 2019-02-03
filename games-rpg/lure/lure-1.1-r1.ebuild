# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils

DAT_PV=0.13.1
DESCRIPTION="Lure of the Temptress"
HOMEPAGE="http://www.revolution.co.uk/_display.php?id=10"
SRC_URI="
	https://raw.githubusercontent.com/scummvm/scummvm/266aef932a8a052df897e4d79b4572e5d169916f/dists/engine-data/lure.dat -> lure-${DAT_PV}.dat
	!l10n_en? ( !l10n_es? ( !l10n_fr? ( !l10n_de? ( !l10n_it?
		( mirror://sourceforge/scummvm/${P}.zip -> ${PN}-en-${PV}.zip ) ) ) ) )
	l10n_en? ( mirror://sourceforge/scummvm/${P}.zip  -> ${PN}-en-${PV}.zip )
	l10n_es? ( mirror://sourceforge/scummvm/${PN}-es-${PV}.zip )
	l10n_fr? ( mirror://sourceforge/scummvm/${PN}-fr-${PV}.zip )
	l10n_de? ( mirror://sourceforge/scummvm/${PN}-de-${PV}.zip )
	l10n_it? ( mirror://sourceforge/scummvm/${PN}-it-${PV}.zip )"

LICENSE="lure"
SLOT="0"
KEYWORDS="~amd64 ~x86"
LANGS_IUSE="l10n_en l10n_es l10n_de l10n_fr l10n_it"
IUSE=${LANGS_IUSE}
RESTRICT="mirror"

RDEPEND=">=games-engines/scummvm-0.13.1"
DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}

any_l10n() {
	use l10n_en || use l10n_es || use l10n_de || use l10n_fr || use l10n_it
}

src_unpack() {
	local lang

	if any_l10n ; then
		for lang in ${LANGS_IUSE}
		do
			use ${lang} && unpack ${PN}-${lang/l10n_}-${PV}.zip
		done
		mv lure lure-en 2> /dev/null
	else
		unpack ${PN}-en-${PV}.zip
	fi
}

src_prepare() {
	local lang f

	default

	find . \
		\( -iname "*exe" \
		-o -iname "*ega" \
		-o -iname LICENSE.txt \) \
		-exec rm -f '{}' +
	mkdir docs
	if any_l10n ; then
		for lang in ${LANGS_IUSE}
		do
			mkdir docs/${lang}
			find lure-${lang/l10n_} \
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

	if any_l10n ; then
		for lang in ${LANGS_IUSE}
		do
			if use ${lang} ; then
				lang=${lang/l10n_}
				insinto "/usr/share/${PN}-${lang}"
				newins "${DISTDIR}"/lure-${DAT_PV}.dat lure.dat
				doins -r ${PN}-${lang}/*
				make_wrapper ${PN}-${lang} "scummvm -q ${lang} -f -p \"/usr/share/${PN}-${lang}\" lure" .
				make_desktop_entry ${PN}-${lang} "Lure of the Temptress (${lang})" ${PN}
				docinto l10n_${lang}
				dodoc docs/l10n_${lang}/*
			fi
		done
	else
		insinto "/usr/share/${PN}"
		newins "${DISTDIR}"/lure-${DAT_PV}.dat lure.dat
		doins -r ${PN}/*
		make_wrapper ${PN} "scummvm -f -p \"/usr/share/${PN}\" lure" .
		make_desktop_entry ${PN} "Lure of the Temptress"
	fi
}
