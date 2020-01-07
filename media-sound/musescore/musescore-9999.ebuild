# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_MAKEFILE_GENERATOR="emake"
CHECKREQS_DISK_BUILD=3500M
inherit git-r3 cmake xdg check-reqs

DESCRIPTION="WYSIWYG Music Score Typesetter"
HOMEPAGE="https://musescore.org/"
# MuseScore_General-0.1.3.tar.bz2 packaged from https://ftp.osuosl.org/pub/musescore/soundfont/MuseScore_General/
# It has to be repackaged because the files are not versioned, current version can be found in VERSION file there.
SRC_URI="https://dev.gentoo.org/~fordfrog/distfiles/MuseScore_General-0.1.8.tar.bz2"
EGIT_REPO_URI="https://github.com/${PN}/MuseScore.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="alsa debug jack mp3 portaudio portmidi pulseaudio vorbis webengine"
REQUIRED_USE="portmidi? ( portaudio )"

BDEPEND="
	dev-qt/linguist-tools:5
	virtual/pkgconfig
"
DEPEND="
	dev-qt/designer:5
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qthelp:5
	dev-qt/qtnetwork:5
	dev-qt/qtprintsupport:5
	dev-qt/qtquickcontrols2:5
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
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-3.0.1-man-pages.patch"
	"${FILESDIR}/5583.patch"
)

src_unpack() {
	git-r3_src_unpack
	unpack ${A}
}

src_prepare() {
	cmake_src_prepare

	# Move soundfonts to the correct directory
	mv "${WORKDIR}"/sound/* "${S}"/share/sound/ || die "Failed to move soundfont files"
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=ON
		-DDOWNLOAD_SOUNDFONT=OFF
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
		-DBUILD_WEBENGINE="$(usex webengine)"
	)
	cmake_src_configure
}

src_compile() {
	cd "${BUILD_DIR}" || die
	cmake_build -j1 lrelease manpages
	cmake_src_compile
}
