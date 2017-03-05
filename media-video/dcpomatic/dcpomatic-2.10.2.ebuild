# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_3 python3_4 python3_5 )
PYTHON_REQ_USE="threads(+)"
inherit python-any-r1 waf-utils wxwidgets

DESCRIPTION="create Digital Cinema Packages (DCPs) from videos, images and sound files"
HOMEPAGE="http://dcpomatic.com/"
SRC_URI="http://${PN}.com/downloads/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+gtk"

RDEPEND="dev-cpp/cairomm
	dev-cpp/glibmm:2
	dev-cpp/libxmlpp:2.6
	dev-cpp/pangomm:1.4
	dev-libs/boost
	dev-libs/glib:2
	dev-libs/icu
	dev-libs/libcxml
	dev-libs/libzip
	dev-libs/openssl:0
	|| ( media-gfx/graphicsmagick media-gfx/imagemagick )
	media-libs/fontconfig:1.0
	>=media-libs/libdcp-1.4.1:1.0
	media-libs/libsamplerate
	media-libs/libsndfile
	>=media-libs/libsub-1.2.1:1.0
	>=media-video/ffmpeg-3:=
	net-libs/libssh
	net-misc/curl
	gtk? ( x11-libs/gtk+:2
		x11-libs/wxGTK:3.0 )"
DEPEND="${RDEPEND}
	dev-util/waf
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-2.8.0-wxGTK3.patch
	"${FILESDIR}"/${PN}-2.8.0-no-ldconfig.patch
	"${FILESDIR}"/${PN}-2.8.0-desktop.patch
	"${FILESDIR}"/${PN}-2.10.2-respect-cxxflags.patch
	)

src_prepare() {
	rm -v waf
	export WAF_BINARY=${EROOT}usr/bin/waf
	if [ -z "${PYTHONPATH}" ] ; then
		export PYTHONPATH="${S}"
	else
		export PYTHONPATH="${S}:${PYTHONPATH}"
	fi

	ewarn "Some tests failing due missing files/certs are disabled."
	sed \
		-e '/4k_test.cc/d' \
		-e '/audio_analysis_test.cc/d' \
		-e '/audio_decoder_test.cc/d' \
		-e '/audio_processor_test.cc/d' \
		-e '/black_fill_test.cc/d' \
		-e '/client_server_test.cc/d' \
		-e '/dcp_subtitle_test.cc/d' \
		-e '/ffmpeg_decoder_sequential_test.cc/d' \
		-e '/file_naming_test.cc/d' \
		-e '/import_dcp_test.cc/d' \
		-e '/interrupt_encoder_test.cc/d' \
		-e '/j2k_bandwidth_test.cc/d' \
		-e '/recover_test.cc/d' \
		-e '/reels_test.cc/d' \
		-e '/render_subtitles_test.cc/d' \
		-e '/repeat_frame_test.cc/d' \
		-e '/scaling_test.cc/d' \
		-e '/skip_frame_test.cc/d' \
		-e '/srt_subtitle_test.cc/d' \
		-e '/ssa_subtitle_test.cc/d' \
		-e '/vf_test.cc/d' \
		-e '/video_mxf_content_test.cc/d' \
        -e '/film_metadata_test.cc/d' \
		-i test/wscript || die

	default
}

src_configure() {
	waf-utils_src_configure $(usex gtk "" "--disable-gui")
}

src_test() {
	./run/tests || die
}
