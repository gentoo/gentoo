# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit qmake-utils gnome2-utils xdg-utils epatch

DESCRIPTION="Cloth patternmaking software"
HOMEPAGE="https://valentinaproject.bitbucket.io/"
SRC_URI="https://bitbucket.org/dismine/${PN}/get/v${PV}.zip -> ${P}.zip
	https://bitbucket.org/dismine/${PN}/commits/d78ca13c4891ccf3542b0704a7d66af0f9b02938/raw -> valentina-4798.patch
	https://bitbucket.org/dismine/${PN}/commits/98e869c4146204ef31822087fa826cfa1cd7e0f4/raw -> valentina-4802.patch
	https://bitbucket.org/dismine/${PN}/commits/572fe909f75e013be310905c118e1afe4368db1c/raw -> valentina-5406.patch"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gnome"

LANGS="cs de el en en es fi fr he id it nl pt-BR ro ru uk zh-CN"

for LANG in ${LANGS}; do
	IUSE="${IUSE} l10n_${LANG}"
done

CDEPEND="
	app-text/poppler
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5[ssl]
	dev-qt/qtprintsupport:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	dev-qt/qtxmlpatterns:5"
RDEPEND="${CDEPEND}"
DEPEND="${CDEPEND}
	app-arch/unzip"

S=${WORKDIR}/dismine-${PN}-31c95eadca8b

src_prepare() {
	epatch "${DISTDIR}/${PN}-4798.patch" \
		"${DISTDIR}/${PN}-4802.patch" \
		"${DISTDIR}/${PN}-5406.patch"

	default
}

src_configure() {
	local locales=""
	local locale

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

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update

	if use gnome ; then
		gnome2_icon_cache_update
	fi
}
