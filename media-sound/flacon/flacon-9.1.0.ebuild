# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Tests require lots of disk space
CHECKREQS_DISK_BUILD=10G
inherit check-reqs cmake optfeature virtualx xdg-utils

DESCRIPTION="Extracts audio tracks from an audio CD image to separate tracks"
HOMEPAGE="https://flacon.github.io/"
SRC_URI="https://github.com/flacon/flacon/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="test"

BDEPEND="
	dev-qt/linguist-tools:5
	virtual/pkgconfig
"
RDEPEND="
	app-i18n/uchardet
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	media-libs/taglib
"
DEPEND="${RDEPEND}
	dev-qt/qtconcurrent:5
	test? (
		dev-qt/qttest:5
		media-libs/flac
		media-sound/mac
		media-sound/shntool
		media-sound/ttaenc
		media-sound/wavpack
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-9.0.0-no-man-compress.patch
)

RESTRICT="!test? ( test )"

pkg_pretend() {
	use test && check-reqs_pkg_pretend
}

pkg_setup() {
	use test && check-reqs_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTS="$(usex test)"
	)
	cmake_src_configure
}

src_test() {
	virtx "${BUILD_DIR}/tests/${PN}_test" || die
}

pkg_postinst() {
	optfeature_header "${PN} optionally supports formats listed below."
	optfeature 'FLAC input and output support' media-libs/flac
	optfeature 'WavPack input and output support' media-sound/wavpack
	optfeature 'APE input support' media-sound/mac
	optfeature 'ALAC output support' media-sound/alac_decoder
	optfeature 'TTA input support' media-sound/ttaenc
	optfeature 'AAC output support' media-libs/faac
	optfeature 'MP3 output support' media-sound/lame
	optfeature 'Vorbis output support' media-sound/vorbis-tools
	optfeature 'MP3 Replay Gain support' media-sound/mp3gain
	optfeature 'Vorbis Replay Gain support' media-sound/vorbisgain

	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}
