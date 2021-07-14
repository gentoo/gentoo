# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop wrapper

DAT_PV="0.13.1"

DESCRIPTION="Play as the young peasant named Diermot who has to overthrow an evil sorceress"
HOMEPAGE="https://revolution.co.uk/games_catalog/lure-of-the-temptress-copy/"
SRC_URI="
	https://raw.githubusercontent.com/scummvm/scummvm/266aef932a8a052df897e4d79b4572e5d169916f/dists/engine-data/lure.dat -> lure-${DAT_PV}.dat
	l10n_en? ( mirror://sourceforge/scummvm/${P}.zip -> ${PN}-en-${PV}.zip )
	l10n_es? ( mirror://sourceforge/scummvm/${PN}-es-${PV}.zip )
	l10n_fr? ( mirror://sourceforge/scummvm/${PN}-fr-${PV}.zip )
	l10n_de? ( mirror://sourceforge/scummvm/${PN}-de-${PV}.zip )
	l10n_it? ( mirror://sourceforge/scummvm/${PN}-it-${PV}.zip )
	!l10n_en? ( !l10n_es? ( !l10n_fr? ( !l10n_de? ( !l10n_it?
		( mirror://sourceforge/scummvm/${P}.zip -> ${PN}-en-${PV}.zip ) ) ) ) )"
S="${WORKDIR}"

LICENSE="lure"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="l10n_de +l10n_en l10n_es l10n_fr l10n_it"

RDEPEND="games-engines/scummvm"
BDEPEND="app-arch/unzip"

src_install() {
	local my_l10n=( $(usev l10n_es) $(usev l10n_de) $(usev l10n_en) $(usev l10n_fr) $(usev l10n_it) )
	[[ ${my_l10n} ]] || my_l10n=( l10n_en )

	local lang name
	for lang in "${my_l10n[@]//l10n_/}"; do
		[[ ${lang} == en ]] && name=${PN} || name=${PN}-${lang}

		insinto /usr/share/${PN}/${lang}
		newins "${DISTDIR}"/${PN}-${DAT_PV}.dat ${PN}.dat
		doins ${name}/D*[1-4].[vV][gG][aA]

		docinto ${lang}
		dodoc ${name}/{Manual.pdf,README}
		newdoc ${name}/PROTECT.PDF PROTECT.pdf

		make_wrapper ${PN}-${lang} "scummvm -q ${lang} -f -p \"${EPREFIX}/usr/share/${PN}/${lang}\" lure"
		make_desktop_entry ${PN}-${lang} "Lure of the Temptress (${lang})" applications-games
	done
}
