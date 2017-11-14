# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit qmake-utils gnome2-utils xdg-utils epatch

DESCRIPTION="Cloth patternmaking software"
HOMEPAGE="https://valentinaproject.bitbucket.io/"
SRC_URI="https://bitbucket.org/dismine/${PN}/get/v${PV}.zip -> ${P}.zip
	https://bitbucket.org/dismine/${PN}/commits/d78ca13c4891ccf3542b0704a7d66af0f9b02938/raw -> valentina-4798.patch
	https://bitbucket.org/dismine/${PN}/commits/98e869c4146204ef31822087fa826cfa1cd7e0f4/raw -> valentina-4802.patch"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gnome"

# en_IN not supported in Gentoo so not added here
LANGS="cs_CZ de_DE el_GR en_CA en_US es_ES fi_FI fr_FR he_IL id_ID it_IT nl_NL pt_BR ro_RO ru_RU uk_UA zh_CN"

for LANG in ${LANGS}; do
	IUSE="${IUSE} linguas_${LANG}"
done

CDEPEND="
	app-text/poppler
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
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
		"${DISTDIR}/${PN}-4802.patch"

	default
}

src_configure() {
	local locales=""

	for LANG in ${LANGS}; do
		if use linguas_${LANG}; then
			locales="${locales} ${LANG}"
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
