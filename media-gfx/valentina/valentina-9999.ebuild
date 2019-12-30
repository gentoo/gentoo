# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit mercurial qmake-utils gnome2-utils xdg

DESCRIPTION="Cloth patternmaking software"
HOMEPAGE="https://valentinaproject.bitbucket.io/"
EHG_REPO_URI="https://bitbucket.org/dismine/valentina"
EHG_REVISION="develop"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

LANGS="cs de el en en es fi fr he id it nl pt-BR ro ru uk zh-CN"

for LANG in ${LANGS}; do
	IUSE="${IUSE} l10n_${LANG}"
done

CDEPEND="
	app-text/poppler
	dev-qt/linguist:5
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5[ssl]
	dev-qt/qtprintsupport:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	dev-qt/qtxmlpatterns:5"
RDEPEND="${CDEPEND}"
DEPEND="${CDEPEND}"

src_configure() {
	local locales=""

	for LANG in ${LANGS}; do
		if use l10n_${LANG}; then
			case ${LANG} in
			"cs")
				locale="cs_CZ"
				;;
			"de")
				locale="de_DE"
				;;
			"el")
				locale="el_GR"
				;;
			"en")
				locale="en_CA en_IN en_US"
				;;
			"es")
				locale="es_ES"
				;;
			"fi")
				locale="fi_FI"
				;;
			"fr")
				locale="fr_FR"
				;;
			"he")
				locale="he_IL"
				;;
			"id")
				locale="id_ID"
				;;
			"it")
				locale="it_IT"
				;;
			"nl")
				locale="nl_NL"
				;;
			"pt-BR")
				locale="pt_BR"
				;;
			"ro")
				locale="ro_RO"
				;;
			"ru")
				locale="ru_RU"
				;;
			"uk")
				locale="uk_UA"
				;;
			"zh-CN")
				locale="zh_CN"
				;;
			esac

			locales="${locales} ${locale}"
		fi
	done

	eqmake5 LOCALES="${locales}" "CONFIG+=noStripDebugSymbols no_ccache noRunPath noTests" Valentina.pro -r
}

src_install() {
	emake install INSTALL_ROOT="${D}"

	dodoc AUTHORS.txt ChangeLog.txt README.txt

	doman dist/debian/${PN}.1
	doman dist/debian/tape.1

	cp dist/debian/valentina.sharedmimeinfo dist/debian/${PN}.xml || die
	insinto /usr/share/mime/packages
	doins dist/debian/${PN}.xml
}
