# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit mercurial qmake-utils gnome2-utils fdo-mime

DESCRIPTION="Cloth patternmaking software"
HOMEPAGE="http://valentinaproject.bitbucket.org/"
SRC_URI=""
EHG_REPO_URI="https://bitbucket.org/dismine/valentina"
EHG_REVISION="develop"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gnome"

# en_IN not supported in Gentoo so not added here
LANGS="cs_CZ de_DE en_CA en_US es_ES fi_FI fr_FR he_IL id_ID it_IT nl_NL ro_RO ru_RU uk_UA zh_CN"

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
DEPEND="${CDEPEND}"

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

	dodoc LICENSE_GPL.txt ChangeLog.txt README.txt

	doman dist/debian/${PN}.1
	doman dist/debian/tape.1

	cp dist/debian/valentina.sharedmimeinfo dist/debian/${PN}.xml || die
	insinto /usr/share/mime/packages
	doins dist/debian/${PN}.xml
}

pkg_postinst() {
	fdo-mime_desktop_database_update

	if use gnome ; then
		gnome2_icon_cache_update
	fi
}
