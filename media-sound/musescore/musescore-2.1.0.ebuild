# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="WYSIWYG Music Score Typesetter"
HOMEPAGE="http://musescore.org/"
SRC_URI="https://github.com/musescore/MuseScore/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~mgorny/dist/${P}-fix-buildsystem.patch.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa debug jack mp3 portaudio portmidi pulseaudio"
REQUIRED_USE="portmidi? ( portaudio )"

RDEPEND="
	dev-qt/designer:5
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qthelp:5
	dev-qt/qtprintsupport:5
	dev-qt/qtsvg:5
	dev-qt/qtwebkit:5
	dev-qt/qtxmlpatterns:5
	>=media-libs/freetype-2.5.2
	media-libs/libsndfile
	sys-libs/zlib
	alsa? ( >=media-libs/alsa-lib-1.0.0 )
	jack? ( virtual/jack )
	mp3? ( media-sound/lame )
	portaudio? ( media-libs/portaudio )
	portmidi? ( media-libs/portmidi )
	pulseaudio? ( media-sound/pulseaudio )
	"
DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5
	virtual/pkgconfig
	"
PATCHES=(
	"${WORKDIR}/${PN}-2.1.0-fix-buildsystem.patch"
)
S="${WORKDIR}/MuseScore-${PV}"

src_configure() {
	local mycmakeargs=(
		-DBUILD_ALSA="$(usex alsa)"
		-DBUILD_JACK="$(usex jack)"
		-DBUILD_LAME="$(usex mp3)"
		-DBUILD_PORTAUDIO="$(usex portaudio)"
		-DBUILD_PORTMIDI="$(usex portmidi)"
		-DBUILD_PULSEAUDIO="$(usex pulseaudio)"
	)
	cmake-utils_src_configure
}

src_compile() {
	cd "${BUILD_DIR}" || die
	cmake-utils_src_make -j1 lrelease manpages
	cmake-utils_src_compile
}
