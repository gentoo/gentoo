# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PLOCALES="ar ca ca_ES da de_DE el en es es_AR es_ES fi fi_FI fr he_IL hr hu
ia it jv nl pl pl_PL pt_BR ro ru sk sl tr zh_CN"
PLOCALE_BACKUP="en"

inherit l10n qt4-r2

DESCRIPTION="Qt4 YouTube Client"
HOMEPAGE="http://flavio.tordini.org/minitube"
SRC_URI="https://github.com/flaviotordini/${PN}/archive/${PV}.tar.gz ->
${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug download gstreamer kde"

DEPEND=">=dev-qt/qtgui-4.8:4[accessibility]
	>=dev-qt/qtdbus-4.8:4
	>=dev-qt/qtsql-4.8:4
	dev-qt/qtsingleapplication[qt4(+),X]
	kde? ( || ( media-libs/phonon[gstreamer?,qt4] >=dev-qt/qtphonon-4.8:4 ) )
	!kde? ( || ( >=dev-qt/qtphonon-4.8:4 media-libs/phonon[gstreamer?,qt4] ) )
	gstreamer? (
		media-plugins/gst-plugins-soup:0.10
		media-plugins/gst-plugins-ffmpeg:0.10
		media-plugins/gst-plugins-faac:0.10
		media-plugins/gst-plugins-faad:0.10
		media-plugins/gst-plugins-theora
	)
"
RDEPEND="${DEPEND}"

DOCS="AUTHORS CHANGES TODO"

#455976
PATCHES=( "${FILESDIR}"/${P}-disable-updates.patch )

pkg_pretend() {
	if [[ -z ${MINITUBE_GOOGLE_API_KEY} ]]; then
		eerror ""
		eerror "Since version 2.4, you need to generate a Google API Key to use"
		eerror "with this application. Please head over to"
		eerror "https://console.developers.google.com/ and"
		eerror "https://github.com/flaviotordini/minitube/blob/master/README.md"
		eerror "for more information. Once you have generated your key,"
		eerror "please export it to your environment ie :"
		eerror "'export MINITUBE_GOOGLE_API_KEY=\"YourAPIKeyHere\""
		eerror "and then try to merge this package again"
		eerror ""
		die "MINITUBE_GOOGLE_API_KEY env variable not defined!"
	fi
}

src_prepare() {
	qt4-r2_src_prepare

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
}

src_install() {
	qt4-r2_src_install
	newicon images/app.png minitube.png
}

pkg_postinst() {
	if use download; then
		elog "You activated the 'download' USE flag. This allows you to"
		elog "download videos from youtube, which might violate the youtube"
		elog "terms-of-service (TOS) in some legislations. If downloading"
		elog "youtube-videos is not allowed in your legislation, please"
		elog "disable the 'download' use flag. For details on the youtube TOS,"
		elog "see http://www.youtube.com/t/terms"
	fi
}
