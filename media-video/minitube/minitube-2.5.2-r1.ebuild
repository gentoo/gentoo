# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PLOCALES="ar ca ca_ES da de_DE el en es es_AR es_ES fi fi_FI fr he_IL hr hu
ia it jv nl pl pl_PL pt_BR ro ru sk sl tr zh_CN"
PLOCALE_BACKUP="en"

inherit l10n qmake-utils

DESCRIPTION="Qt5 YouTube Client"
HOMEPAGE="http://flavio.tordini.org/minitube"
SRC_URI="https://github.com/flaviotordini/${PN}/archive/${PV}.tar.gz ->
${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug download"

DEPEND="dev-qt/qtgui:5[accessibility]
	dev-qt/qtdbus:5
	dev-qt/qtnetwork:5
	dev-qt/qtscript:5
	dev-qt/qtsql:5[sqlite]
	dev-qt/qtwidgets:5
	dev-qt/qtsingleapplication[qt5(+),X]
	media-libs/phonon[qt5]
"
RDEPEND="${DEPEND}"

DOCS="AUTHORS CHANGES TODO"

#455976
PATCHES=( "${FILESDIR}"/${PN}-2.5.1-disable-updates.patch )

src_prepare() {
	epatch "${PATCHES[@]}"

	# Remove unneeded translations
	local trans=
	for x in $(l10n_get_locales); do
		trans+="${x}.ts "
	done
	if [[ -n ${trans} ]]; then
		sed -i -e "/^TRANSLATIONS/s/+=.*/+=${trans}/" locale/locale.pri || die
	fi
	sed -i \
		's|include(src/qtsingleapplication/qtsingleapplication.pri)|CONFIG += qtsingleapplication|g' \
		${PN}.pro || die "Failed to unbundle qtsingleapplication"

	# Enable video downloads. Bug #491344
	use download && { echo "DEFINES += APP_DOWNLOADS" >> ${PN}.pro; }
	echo "DEFINES += APP_GOOGLE_API_KEY=${MINITUBE_GOOGLE_API_KEY}" >> ${PN}.pro

	epatch_user
}

src_configure() {
	eqmake5
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	einstalldocs
	newicon images/app.png minitube.png
}

pkg_postinst() {
	elog ""
	elog "Since version 2.4, you need to generate a Google API Key to use"
	elog "with this application. Please head over to"
	elog "https://console.developers.google.com/ and"
	elog "https://github.com/flaviotordini/minitube/blob/master/README.md"
	elog "for more information. Once you have generated your key,"
	elog "please put it in QSettings key \"googleApiKey\", e.g.:"
	elog "# echo 'googleApiKey=YourKeyHere' >> \"\${HOME}/.config/Flavio Tordini/Minitube.conf\""
	elog ""

	if use download; then
		elog "You activated the 'download' USE flag. This allows you to"
		elog "download videos from youtube, which might violate the youtube"
		elog "terms-of-service (TOS) in some legislations. If downloading"
		elog "youtube-videos is not allowed in your legislation, please"
		elog "disable the 'download' use flag. For details on the youtube TOS,"
		elog "see http://www.youtube.com/t/terms"
	fi
}
