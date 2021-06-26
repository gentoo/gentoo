# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop wrapper

DESCRIPTION="Bert the little dragon searches for his father"
HOMEPAGE="https://www.ucw.cz/draci-historie/index-en.html"
BASE_URL="https://www.ucw.cz/draci-historie/binary/dh"
SRC_URI="
	l10n_cs? ( ${BASE_URL}-cz-${PV}.zip )
	l10n_de? ( ${BASE_URL}-de-${PV}.zip )
	l10n_en? ( ${BASE_URL}-en-${PV}.zip )
	l10n_pl? ( ${BASE_URL}-pl-${PV}.zip )
	!l10n_cs? ( !l10n_de? ( !l10n_en? ( !l10n_pl? ( ${BASE_URL}-en-${PV}.zip ) ) ) )
	https://dev.gentoo.org/~ionen/distfiles/${PN}.png
"
S="${WORKDIR}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="l10n_cs l10n_de +l10n_en l10n_pl"

RDEPEND="games-engines/scummvm"
BDEPEND="app-arch/unzip"

src_unpack() {
	MY_L10N=( $(usev l10n_{cs,cz}) $(usev l10n_de) $(usev l10n_en) $(usev l10n_pl) )
	[[ ${MY_L10N} ]] || MY_L10N=( l10n_en )

	local lang
	for lang in "${MY_L10N[@]//l10n_/}"; do
		mkdir ${lang} || die
		unpack dh-${lang}-${PV}.zip
		mv *.{dfw,fon,mid,sam} ${lang}/ || die
	done
}

src_install() {
	insinto /usr/share/${PN}
	local lang
	for lang in "${MY_L10N[@]//l10n_/}"; do
		doins -r ${lang}
		make_wrapper ${PN}-${lang} "scummvm -f -p \"${EPREFIX}/usr/share/${PN}/${lang}\" draci"
		make_desktop_entry ${PN}-${lang} "Dračí Historie (${lang})"
	done

	doicon "${DISTDIR}"/${PN}.png
}
