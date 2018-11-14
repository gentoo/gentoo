# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils git-r3 xdg-utils

DESCRIPTION="WYSIWYG Music Score Typesetter"
HOMEPAGE="https://musescore.org/"
EGIT_REPO_URI="https://github.com/${PN}/MuseScore.git"
SRC_URI="https://dev.gentoo.org/~mgorny/dist/${P}-fix-buildsystem.patch.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="alsa debug jack mp3 portaudio portmidi pulseaudio vorbis webengine"
REQUIRED_USE="portmidi? ( portaudio )"

RDEPEND="
	dev-qt/designer:5
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qthelp:5
	dev-qt/qtnetwork:5
	dev-qt/qtprintsupport:5
	>=dev-qt/qtsingleapplication-2.6.1_p20171024
	dev-qt/qtsvg:5
	dev-qt/qtxml:5
	dev-qt/qtxmlpatterns:5
	>=media-libs/freetype-2.5.2
	media-libs/libsndfile
	sys-libs/zlib:=
	alsa? ( >=media-libs/alsa-lib-1.0.0 )
	jack? ( virtual/jack )
	mp3? ( media-sound/lame )
	portaudio? ( media-libs/portaudio )
	portmidi? ( media-libs/portmidi )
	pulseaudio? ( media-sound/pulseaudio )
	vorbis? ( media-libs/libvorbis )
	webengine? ( dev-qt/qtwebengine:5[widgets] )
"
DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5
	virtual/pkgconfig
"

PATCHES=(
	"${WORKDIR}/${P}-fix-buildsystem.patch"
)

src_unpack() {
	git-r3_src_unpack
	default_src_unpack
}

src_configure() {
	local mycmakeargs=(
		-DUSE_SYSTEM_QTSINGLEAPPLICATION=ON
		-DUSE_PATH_WITH_EXPLICIT_QT_VERSION=ON
		-DUSE_SYSTEM_FREETYPE=ON
		-DBUILD_ALSA="$(usex alsa)"
		-DBUILD_JACK="$(usex jack)"
		-DBUILD_LAME="$(usex mp3)"
		-DBUILD_PORTAUDIO="$(usex portaudio)"
		-DBUILD_PORTMIDI="$(usex portmidi)"
		-DBUILD_PULSEAUDIO="$(usex pulseaudio)"
		-DSOUNDFONT3="$(usex vorbis)"
		-DBUILD_WEBEBENGINE="$(usex webengine)"
	)
	cmake-utils_src_configure
}

src_compile() {
	cd "${BUILD_DIR}" || die
	cmake-utils_src_make -j1 lrelease manpages
	cmake-utils_src_compile
}

pkg_postinst() {
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}
