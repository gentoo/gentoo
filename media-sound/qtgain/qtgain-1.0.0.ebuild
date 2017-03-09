# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="QtGain"
inherit eutils qmake-utils

DESCRIPTION="A simple frontend to mp3gain, vorbisgain and metaflac"
HOMEPAGE="https://www.linux-apps.com/content/show.php/QtGain?content=56842"
SRC_URI="https://dl.opendesktop.org/api/files/download/id/1466640864/56842-${MY_PN}_${PV}.zip"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="flac mp3 mp4 vorbis"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
"
DEPEND="${RDEPEND}
	app-arch/unzip
"
DEPEND="dev-qt/qtgui:4"

S="${WORKDIR}/${PN}"

src_configure() {
	eqmake5 ${MY_PN}.pro
}

src_install() {
	dobin bin/${PN}
	newicon Icons/lsongs.png ${PN}.png
	make_desktop_entry ${PN} ${MY_PN}
}

pkg_postinst() {
	elog "Additional features can be enabled by installing optional packages:"
	elog ""
	elog "media-libs/flac - flac support"
	elog "media-sound/aacgain - aac support"
	elog "media-sound/mp3gain - mp3 support"
	elog "media-sound/vorbisgain - vorbis support"
	elog "media-sound/id3v2 - mass renamer and cover downloader"
}
