# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_MAKEFILE_GENERATOR="emake"
CHECKREQS_DISK_BUILD=3500M
inherit cmake xdg check-reqs

if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}/MuseScore.git"
else
	SRC_URI="https://github.com/musescore/MuseScore/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 x86"
	S="${WORKDIR}/MuseScore-${PV}"
fi

DESCRIPTION="WYSIWYG Music Score Typesetter"
HOMEPAGE="https://musescore.org/"
# MuseScore_General-*.tar.bz2 packaged from https://ftp.osuosl.org/pub/musescore/soundfont/MuseScore_General/
# It has to be repackaged because the files are not versioned, current version can be found in VERSION file there.
SRC_URI+=" https://dev.gentoo.org/~fordfrog/distfiles/MuseScore_General-0.2.0.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
IUSE="alsa debug jack mp3 osc omr portaudio portmidi pulseaudio +sf3 sfz webengine"
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
	dev-qt/qtopengl:5
	dev-qt/qtprintsupport:5
	dev-qt/qtquickcontrols2:5
	>=dev-qt/qtsingleapplication-2.6.1_p20171024[X]
	dev-qt/qtsvg:5
	dev-qt/qtxml:5
	dev-qt/qtxmlpatterns:5
	>=media-libs/freetype-2.5.2
	media-libs/libsndfile
	sys-libs/zlib:=
	alsa? ( >=media-libs/alsa-lib-1.0.0 )
	jack? ( virtual/jack )
	mp3? ( media-sound/lame )
	omr? ( app-text/poppler )
	portaudio? ( media-libs/portaudio )
	portmidi? ( media-libs/portmidi )
	pulseaudio? ( media-sound/pulseaudio )
	sf3? ( media-libs/libvorbis )
	webengine? ( dev-qt/qtwebengine:5[widgets] )
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-3.0.1-man-pages.patch"
	"${FILESDIR}/${PN}-3.6.1-rename-audioitem.patch"
)

src_unpack() {
	if [[ ${PV} == "9999" ]]; then
		git-r3_src_unpack
		unpack ${A}
	else
		default
	fi
}

src_prepare() {
	cmake_src_prepare

	# Move soundfonts to the correct directory
	mv "${WORKDIR}"/sound/* "${S}"/share/sound/ || die "Failed to move soundfont files"
}

src_configure() {
	local mycmakeargs=(
		-DAEOLUS=OFF # does not compile
		-DBUILD_ALSA="$(usex alsa)"
		-DBUILD_CRASH_REPORTER=OFF
		-DBUILD_JACK="$(usex jack)"
		-DBUILD_LAME="$(usex mp3)"
		-DBUILD_PCH=ON
		-DBUILD_PORTAUDIO="$(usex portaudio)"
		-DBUILD_PORTMIDI="$(usex portmidi)"
		-DBUILD_PULSEAUDIO="$(usex pulseaudio)"
		-DBUILD_SHARED_LIBS=ON
		-DBUILD_TELEMETRY_MODULE=ON
		-DBUILD_WEBENGINE="$(usex webengine)"
		-DCMAKE_SKIP_RPATH=ON
		-DDOWNLOAD_SOUNDFONT=OFF
		-DHAS_AUDIOFILE=ON
		-DOCR=OFF
		-DOMR="$(usex omr)"
		-DSOUNDFONT3=ON
		-DZERBERUS="$(usex sfz)"
		-DUSE_PATH_WITH_EXPLICIT_QT_VERSION=ON
		-DUSE_SYSTEM_FREETYPE=ON
		-DUSE_SYSTEM_POPPLER=ON
		-DUSE_SYSTEM_QTSINGLEAPPLICATION=ON
	)
	cmake_src_configure
}

src_compile() {
	cd "${BUILD_DIR}" || die
	cmake_build -j1 lrelease manpages
	cmake_src_compile
}
