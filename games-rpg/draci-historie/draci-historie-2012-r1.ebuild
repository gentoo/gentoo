# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils

DESCRIPTION="Bert the little dragon searches for his father"
HOMEPAGE="http://www.ucw.cz/draci-historie/index-en.html"
BASE_URL="http://www.ucw.cz/draci-historie/binary/dh"
SRC_URI="
	l10n_cs? ( ${BASE_URL}-cz-${PV}.zip )
	l10n_de? ( ${BASE_URL}-de-${PV}.zip )
	l10n_en? ( ${BASE_URL}-en-${PV}.zip )
	l10n_pl? ( ${BASE_URL}-pl-${PV}.zip )
	!l10n_cs? ( !l10n_de? ( !l10n_en? ( !l10n_pl? ( ${BASE_URL}-en-${PV}.zip ) ) ) )
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="l10n_cs l10n_de l10n_en l10n_pl"

RDEPEND=">=games-engines/scummvm-1.1"
DEPEND="app-arch/unzip"

S="${WORKDIR}"

src_unpack() {
	if use l10n_en || ( ! use l10n_cs && ! use l10n_de && ! use l10n_en && ! use l10n_pl ) ; then
		mkdir en || die
		unpack dh-en-${PV}.zip
		mv *.{dfw,fon,mid,sam} en/ || die
	fi
	if use l10n_cs ; then
		mkdir cs || die
		unpack dh-cz-${PV}.zip
		mv *.{dfw,fon,mid,sam,zzz} cs/ || die
	fi
	if use l10n_de ; then
		mkdir de || die
		unpack dh-de-${PV}.zip
		mv *.{dfw,fon,mid,sam} de/ || die
	fi
	if use l10n_pl ; then
		mkdir pl || die
		unpack dh-pl-${PV}.zip
		mv *.{dfw,fon,mid,sam,zzz} pl/ || die
	fi
}

src_prepare() {
	default
	rm -f *.{bat,exe,ins} readme.* || die
}

src_install() {
	newicon bert.ico draci-historie.ico
	insinto /usr/share/${PN}
	for lingua in $(find * -type d); do
		doins -r ${lingua}
	done
	if use l10n_en || ( ! use l10n_cs && ! use l10n_de && ! use l10n_en && ! use l10n_pl ) ; then
		make_wrapper draci-historie-en "scummvm -f -p \"/usr/share/${PN}/en\" draci" .
		make_desktop_entry ${PN}-en "Dračí Historie (English)" /usr/share/pixmaps/draci-historie.ico
	fi
	if use l10n_cs ; then
		make_wrapper draci-historie-cs "scummvm -f -p \"/usr/share/${PN}/cs\" draci" .
		make_desktop_entry ${PN}-cs "Dračí Historie (Čeština)" /usr/share/pixmaps/draci-historie.ico
	fi
	if use l10n_de ; then
		make_wrapper draci-historie-de "scummvm -f -p \"/usr/share/${PN}/de\" draci" .
		make_desktop_entry ${PN}-de "Dračí Historie (Deutsch)"  /usr/share/pixmaps/draci-historie.ico
	fi
	if use l10n_pl ; then
		make_wrapper draci-historie-pl "scummvm -f -p \"/usr/share/${PN}/pl\" draci" .
		make_desktop_entry ${PN}-pl "Dračí Historie (Polski)"  /usr/share/pixmaps/draci-historie.ico
	fi
	einstalldocs
}
