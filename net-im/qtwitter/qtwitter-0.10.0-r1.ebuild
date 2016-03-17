# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
PLOCALES="ca_ES cs_CZ de_DE es_ES fr_FR it_IT ja_JP nb_NO pl_PL pt_BR"

inherit l10n qt4-r2

DESCRIPTION="A Qt-based microblogging client"
HOMEPAGE="http://www.qt-apps.org/content/show.php/qTwitter?content=99087"
SRC_URI="http://files.ayoy.net/qtwitter/release/${PV}/src/${P}-src.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug"

DEPEND="x11-libs/libX11
	>=dev-qt/qtcore-4.5:4
	>=dev-qt/qtgui-4.5:4
	>=dev-qt/qtdbus-4.5:4
	>=dev-libs/qoauth-1.0:0"
RDEPEND="${DEPEND}"

DOCS="README CHANGELOG"
PATCHES=( "${FILESDIR}/${P}-gold.patch" )

src_prepare() {
	qt4-r2_src_prepare

	echo "CONFIG += nostrip" >> "${S}"/${PN}.pro

	l10n_find_plocales_changes "${S}/translations" '${PN}' '.ts'

	local langs
	langs="$(l10n_get_locales)"
	# remove translations and add only the selected ones
	sed -e '/^ *LANGS/,/^$/s/^/#/' \
		-e "/LANGS =/s/.*/LANGS = ${langs}/" \
		-i translations/translations.pri || die "sed translations failed"

	# fix insecure runpaths
	sed -e '/-Wl,-rpath,\$\${DESTDIR}/d' \
		-i qtwitter-app/qtwitter-app.pro || die "sed rpath failed"

	# to pass validation
	sed -e 's/Instant Messaging/InstantMessaging/' \
		-i qtwitter-app/x11/qtwitter.desktop || die "sed .desktop failed"
}

src_configure() {
	eqmake4 PREFIX="/usr"
}
