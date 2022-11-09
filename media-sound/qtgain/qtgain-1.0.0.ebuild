# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="QtGain"
inherit desktop optfeature qmake-utils

DESCRIPTION="Simple frontend to mp3gain, vorbisgain and metaflac"
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
DEPEND="${RDEPEND}"
BDEPEND="app-arch/unzip"

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
	optfeature "FLAC support" media-libs/flac
	optfeature "AAC support" media-sound/aacgain
	optfeature "MP3 support" media-sound/mp3gain
	optfeature "Vorbis support" media-sound/vorbisgain
	optfeature "Mass renamer and cover downloader" media-sound/id3v2
}
