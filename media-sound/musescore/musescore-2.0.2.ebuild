# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit cmake-utils flag-o-matic

DESCRIPTION="WYSIWYG Music Score Typesetter"
HOMEPAGE="http://musescore.org/"
SRC_URI="https://github.com/musescore/MuseScore/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="audiofile debug jack portaudio pulseaudio"

RDEPEND="
	>=dev-qt/qtconcurrent-5.3.0:5
	>=dev-qt/qtcore-5.3.0:5
	>=dev-qt/qtdeclarative-5.3.0:5
	>=dev-qt/qtgui-5.3.0:5
	>=dev-qt/qthelp-5.3.0:5
	>=dev-qt/qtsvg-5.3.0:5
	>=dev-qt/qtwebkit-5.3.0:5
	>=dev-qt/qtxmlpatterns-5.3.0:5
	>=media-libs/alsa-lib-1.0.0
	>=media-libs/freetype-2.5.2
	sys-libs/zlib
	audiofile? (
		media-libs/audiofile
		media-libs/libsndfile
	)
	portaudio? ( media-libs/portaudio )
	pulseaudio? ( media-sound/pulseaudio )
	"

DEPEND="${RDEPEND}
	>=dev-util/cmake-2.8.7
	dev-qt/linguist-tools:5
	media-sound/lame
	virtual/pkgconfig
	jack? ( >=media-sound/jack-audio-connection-kit-0.98.0 )
	"

S="${WORKDIR}/MuseScore-${PV}"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_has audiofile)
		$(cmake-utils_use_build jack)
		$(cmake-utils_use_use portaudio)
		$(cmake-utils_use_use pulseaudio)
	)
	CMAKE_BUILD_TYPE="$(usex debug DEBUG RELEASE)"
	cmake-utils_src_configure
}

src_compile() {
	cd "${BUILD_DIR}" || die
	cmake-utils_src_make -j1 lrelease manpages
	cmake-utils_src_compile
}

pkg_postinst() {
	einfo "Keep media-sound/lame installed for MP3 encoding support."
	einfo "Keep =media-sound/jack-audio-connection-kit-0.98.0 installed for JACK support."
}
