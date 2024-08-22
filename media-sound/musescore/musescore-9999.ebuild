# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CHECKREQS_DISK_BUILD=3500M
VIRTUALX_REQUIRED="test"
inherit cmake flag-o-matic qmake-utils xdg check-reqs virtualx

if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/musescore/MuseScore.git"
else
	SRC_URI="
		https://github.com/musescore/MuseScore/archive/v${PV}.tar.gz -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~arm64 ~x86"
	S="${WORKDIR}/MuseScore-${PV}"
fi

DESCRIPTION="WYSIWYG Music Score Typesetter"
HOMEPAGE="https://musescore.org/"
# MuseScore_General-*.tar.bz2 packaged from https://ftp.osuosl.org/pub/musescore/soundfont/MuseScore_General/
# It has to be repackaged because the files are not versioned, current version can be found in VERSION file there.
SRC_URI+=" https://dev.gentoo.org/~fordfrog/distfiles/MuseScore_General-0.2.0.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
IUSE="jack test video"
RESTRICT="!test? ( test )"

BDEPEND="
	dev-qt/qttools:6[linguist]
	virtual/pkgconfig
"
RDEPEND="
	dev-libs/tinyxml2:=
	dev-qt/qtbase[concurrent,dbus,gui,network,opengl,widgets,xml]
	dev-qt/qtdeclarative:6
	dev-qt/qtnetworkauth:6
	dev-qt/qtscxml:6
	dev-qt/qtsvg:6
	dev-qt/qttools:6[assistant]
	>=media-libs/alsa-lib-1.0.0
	media-libs/flac:=
	>=media-libs/freetype-2.5.2
	media-libs/libopusenc
	media-libs/libsndfile
	media-libs/opus
	media-sound/lame
	sys-libs/zlib:=
	jack? ( virtual/jack )
	video? ( media-video/ffmpeg )
"
DEPEND="
	${RDEPEND}
"

PATCHES=(
	"${FILESDIR}/${PN}-4.4.0-uncompressed-man-pages.patch"
	"${FILESDIR}/${PN}-4.4.0-unbundle-deps.patch"
	"${FILESDIR}/${PN}-4.4.0-unbundle-harfbuzz.patch"
	"${FILESDIR}/${PN}-4.2.0-dynamic_cast-crash.patch"
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
	mv -v "${WORKDIR}"/sound/* "${S}"/share/sound/ || die "Failed to move soundfont files"
}

src_configure() {
	# confuses rcc, bug #908808
	filter-lto

	# bug #766111
	export PATH="$(qt5_get_bindir):${PATH}"

	local mycmakeargs=(
		-DCMAKE_BUILD_TYPE="release"
		-DCMAKE_CXX_FLAGS_RELEASE="${CXXFLAGS}"
		-DCMAKE_C_FLAGS_RELEASE="${CFLAGS}"
		-DCMAKE_INSTALL_PREFIX=/usr
		-DCMAKE_SKIP_RPATH=TRUE
		-DMUE_BUILD_VIDEOEXPORT_MODULE="$(usex video)"
		-DMUE_COMPILE_USE_CCACHE=OFF
		-DMUE_COMPILE_USE_SYSTEM_FLAC=ON
		-DMUE_COMPILE_USE_SYSTEM_FREETYPE=ON
		-DMUE_COMPILE_USE_SYSTEM_OPUSENC=ON
		-DMUE_COMPILE_USE_SYSTEM_TINYXML=ON
		-DMUE_DOWNLOAD_SOUNDFONT=OFF
		-DMUSE_APP_BUILD_MODE="release"
		-DMUSE_MODULE_AUDIO_JACK="$(usex jack)"
		-DMUSE_MODULE_DIAGNOSTICS_CRASHPAD_CLIENT=OFF
		# tests
		-DMUE_BUILD_BRAILLE_TESTS="$(usex test)"
		-DMUE_BUILD_ENGRAVING_TESTS="$(usex test)"
		-DMUE_BUILD_IMPORTEXPORT_TESTS="$(usex test)"
		-DMUE_BUILD_NOTATION_TESTS="$(usex test)"
		-DMUE_BUILD_PLAYBACK_TESTS="$(usex test)"
		-DMUE_BUILD_PROJECT_TESTS="$(usex test)"
	)
	cmake_src_configure
}

src_compile() {
	cd "${BUILD_DIR}" || die
	cmake_build
	cmake_src_compile
}

src_test() {
	virtx cmake_src_test
}

src_install() {
	cmake_src_install

	# Hack to not install bundled libraries
	rm -rf "${ED}/usr/include" "${ED}/usr/$(get_libdir)" || die
}
