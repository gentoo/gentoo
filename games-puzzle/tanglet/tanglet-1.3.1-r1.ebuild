# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
LANGS="cs de es en fr he hu it nl ro tr uk"
LANGSLONG="es_CL"

inherit desktop gnome2-utils qmake-utils

DESCRIPTION="A single player word finding game based on Boggle"
HOMEPAGE="https://gottcode.org/tanglet/"
SRC_URI="https://gottcode.org/${PN}/${P}-src.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	sys-libs/zlib
	dev-qt/qtcore:5
	dev-qt/qtwidgets:5
	dev-qt/qtgui:5
"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	eapply "${FILESDIR}"/${P}-datadir.patch
	sed -i \
		-e "s:@GENTOO_DATADIR@:/usr/share/${PN}:" \
		src/locale_dialog.cpp \
		src/main.cpp || die
}

src_configure() {
	eqmake5 tanglet.pro
}

src_install() {
	dobin ${PN}
	insinto /usr/share/${PN}
	doins -r data

	# Translations
	insinto /usr/share/${PN}/translations/
	for lang in ${LINGUAS};do
		for x in ${LANGS};do
			if [[ ${lang} == ${x} ]];then
				doins translations/${PN}_${x}.qm
			fi
		done
	done

	insinto /usr/share/icons
	doins -r icons/hicolor

	einstalldocs
	doicon icons/${PN}.xpm
	domenu icons/${PN}.desktop
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
