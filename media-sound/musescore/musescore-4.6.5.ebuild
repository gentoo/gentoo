# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# https://bugs.gentoo.org/958256, bundled fluidsynth:
# src/framework/audio/thirdparty/fluidsynth/fluidsynth-2.3.3/src/gentables/CMakeLists.txt
# upstream files are >=3.16, KDDockWidgets is 3.12
CMAKE_QA_COMPAT_SKIP=yes
CHECKREQS_DISK_BUILD=3500M
inherit cmake flag-o-matic xdg check-reqs

if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/musescore/MuseScore.git"
else
	SRC_URI="
		https://github.com/musescore/MuseScore/archive/v${PV}.tar.gz -> ${P}.tar.gz
	"
	KEYWORDS="amd64 ~arm64 ~x86"
	S="${WORKDIR}/MuseScore-${PV}"
fi

DESCRIPTION="WYSIWYG Music Score Typesetter"
HOMEPAGE="https://musescore.org/"
# MuseScore_General-*.tar.bz2 packaged from https://ftp.osuosl.org/pub/musescore/soundfont/MuseScore_General/
# It has to be repackaged because the files are not versioned, current version can be found in VERSION file there.
SRC_URI+=" https://dev.gentoo.org/~fordfrog/distfiles/MuseScore_General-0.2.0.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
IUSE="jack pipewire test video websockets"
REQUIRED_USE="?? ( jack pipewire )"
RESTRICT="!test? ( test )"

BDEPEND="
	dev-qt/qttools:6[linguist]
	virtual/pkgconfig
"
RDEPEND="
	dev-libs/pugixml
	dev-qt/qtbase:6[concurrent,dbus,gui,network,opengl,widgets,xml,X]
	dev-qt/qt5compat:6[qml]
	dev-qt/qtdeclarative:6
	dev-qt/qtnetworkauth:6
	dev-qt/qtscxml:6
	dev-qt/qtsvg:6
	media-libs/alsa-lib
	media-libs/flac:=
	media-libs/freetype
	media-libs/harfbuzz:=
	media-libs/libopusenc
	media-libs/libsndfile
	media-libs/opus
	media-sound/lame
	virtual/zlib:=
	jack? ( virtual/jack )
	pipewire? ( media-video/pipewire:= )
	video? ( media-video/ffmpeg:= )
	websockets? ( dev-qt/qtwebsockets:6 )
"
DEPEND="${RDEPEND}
	dev-libs/utfcpp
	test? ( dev-cpp/gtest )
"

PATCHES=(
	# backported from master
	"${FILESDIR}/${PN}-4.5.2-ffmpeg8.patch"
	"${FILESDIR}/${PN}-4.6.3-rm_tinyxml.patch"
	"${FILESDIR}/${PN}-4.6.3-missing_includes.patch"
	"${FILESDIR}/${PN}-4.6.4-missing_includes.patch"
	# unbundle 3rd libs
	"${FILESDIR}/${PN}-4.6.3-unbundle-lame.patch"
	"${FILESDIR}/${PN}-4.6.3-unbundle-pugixml.patch"
	"${FILESDIR}/${PN}-4.7-unbundle-gtest.patch"
	"${FILESDIR}/${PN}-4.7-unbundle-utfcpp.patch"
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
	# see https://github.com/musescore/MuseScore/issues/11572
	# keep global/thirdparty/picojson, upstream is inactive
	# keep dockwindow/thirdparty/KDDockWidgets, using priv headers
	# keep audio/thirdparty/fluidsynth, using priv headers
	# keep audio/thirdparty/stb, one file, same as miniaudio
	local rm_deps=(
		audio/thirdparty/flac
		audio/thirdparty/lame
		audio/thirdparty/opus
		audio/thirdparty/opusenc
		draw/thirdparty/freetype
		global/thirdparty/pugixml
		global/thirdparty/tinyxml
		global/thirdparty/utfcpp
		testing/thirdparty/googletest
	)

	local bundle
	for bundle in "${rm_deps[@]}"; do
		rm -r src/framework/"${bundle}" || die
	done

	cmake_src_prepare

	# Move soundfonts to the correct directory
	mv -v "${WORKDIR}"/sound/* "${S}"/share/sound/ || die "Failed to move soundfont files"
}

src_configure() {
	# confuses rcc, bug #908808
	filter-lto

	local mycmakeargs=(
		-DCMAKE_POSITION_INDEPENDENT_CODE=ON # https://github.com/musescore/MuseScore/issues/28797
		-DCMAKE_BUILD_TYPE="release"
		-DCMAKE_CXX_FLAGS_RELEASE="${CXXFLAGS}"
		-DCMAKE_C_FLAGS_RELEASE="${CFLAGS}"
		-DCMAKE_SKIP_RPATH=TRUE
		-DGZIP_EXECUTABLE=OFF # avoid compressed manpages
		-DMUE_BUILD_IMPEXP_VIDEOEXPORT_MODULE="$(usex video)"
		-DMUE_COMPILE_USE_SYSTEM_FLAC=ON
		-DMUE_COMPILE_USE_SYSTEM_FREETYPE=ON
		-DMUE_COMPILE_USE_SYSTEM_OPUS=ON
		-DMUE_COMPILE_USE_SYSTEM_OPUSENC=ON
		-DMUE_COMPILE_USE_SYSTEM_HARFBUZZ=ON
		-DMUE_DOWNLOAD_SOUNDFONT=OFF
		-DMUSE_APP_BUILD_MODE="release"
		-DMUSE_COMPILE_USE_COMPILER_CACHE=OFF
		-DMUSE_COMPILE_USE_PCH=OFF
		-DMUSE_MODULE_AUDIO_JACK="$(usex jack)"
		-DMUSE_MODULE_DIAGNOSTICS_CRASHPAD_CLIENT=OFF
		-DMUSE_MODULE_NETWORK_WEBSOCKET="$(usex websockets)"
		-DMUSE_MODULE_UPDATE=OFF
		-DMUSE_PIPEWIRE_AUDIO_DRIVER="$(usex pipewire)"
		# tests
		-DMUSE_ENABLE_UNIT_TESTS="$(usex test)"
		-DMUE_BUILD_BRAILLE_TESTS="$(usex test)"
		-DMUE_BUILD_CONVERTER_TESTS="$(usex test)"
		-DMUE_BUILD_ENGRAVING_TESTS="$(usex test)"
		-DMUE_BUILD_IMPORTEXPORT_TESTS="$(usex test)"
		-DMUE_BUILD_NOTATION_TESTS="$(usex test)"
		-DMUE_BUILD_PLAYBACK_TESTS="$(usex test)"
		-DMUE_BUILD_PROJECT_TESTS="$(usex test)"
	)
	cmake_src_configure
}

src_test() {
	CMAKE_SKIP_TESTS=(
		# see https://github.com/musescore/MuseScore/issues/30434
		# Global_AllocatorTests* fail with gcc only, to investigate
		muse_global_tests
		# segfault
		muse_audio_tests
		# see bug #950450 too
		iex_musicxml_tests
		# fixed in master
		converter_tests
	)

	QT_QPA_PLATFORM=offscreen cmake_src_test
}

pkg_preinst() {
	xdg_pkg_preinst

	if ! has_version "media-sound/musescore" && ! use pipewire; then
		show_pipewire_warning=1
	fi
}

pkg_postinst() {
	xdg_pkg_postinst

	if [[ -n ${show_pipewire_warning} ]]; then
		ewarn "PipeWire support is disabled but it's the default audio driver anyway!"
		ewarn "Check your configuration."
	fi
}
