# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Automatic BPM detection utility"
HOMEPAGE="https://github.com/Tatsh/bpmdetect"
SRC_URI="https://github.com/Tatsh/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-qt/qtbase:6[gui,widgets]
	dev-qt/qtmultimedia:6
	media-libs/flac:=
	media-libs/libmad
	media-libs/libvorbis
	media-libs/portaudio
	media-libs/taglib:=
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_install() {
	einstalldocs
	dobin "${BUILD_DIR}"/src/${PN}
}
