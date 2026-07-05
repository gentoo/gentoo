# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="Audio/MIDI multi-track sequencer written in C++ with the Qt framework"
HOMEPAGE="https://qtractor.org"
SRC_URI="https://downloads.sourceforge.net/project/qtractor/qtractor/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cpu_flags_x86_sse debug dssi ladspa libsamplerate mad osc rubberband vorbis zlib"
REQUIRED_USE="dssi? ( ladspa )"

DEPEND="
	dev-qt/qtbase:6[gui,network,widgets,xml,X]
	dev-qt/qtsvg:6
	media-libs/alsa-lib
	media-libs/libsndfile
	media-libs/lilv
	media-libs/lv2
	virtual/jack
	x11-libs/libxcb:=
	dssi? ( media-libs/dssi )
	ladspa? ( media-libs/ladspa-sdk )
	libsamplerate? ( media-libs/libsamplerate )
	mad? ( media-libs/libmad )
	osc? ( media-libs/liblo )
	rubberband? ( >=media-libs/rubberband-3.0.0:= )
	vorbis? (
		media-libs/libogg
		media-libs/libvorbis
	)
	zlib? ( virtual/zlib:= )
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-qt/qttools:6[linguist]
	virtual/pkgconfig
"

src_configure() {
	local mycmakeargs=(
		-DCONFIG_DSSI=$(usex dssi 1 0)
		-DCONFIG_LADSPA=$(usex ladspa 1 0)
		-DCONFIG_LIBLO=$(usex osc 1 0)
		-DCONFIG_LIBMAD=$(usex mad 1 0)
		-DCONFIG_LIBRUBBERBAND=$(usex rubberband 1 0)
		-DCONFIG_LIBRUBBERBAND_R3=$(usex rubberband 1 0)
		-DCONFIG_LIBSAMPLERATE=$(usex libsamplerate 1 0)
		-DCONFIG_LIBVORBIS=$(usex vorbis 1 0)
		-DCONFIG_LIBZ=$(usex zlib 1 0)
		-DCONFIG_LV2_UI_GTK2=0
		-DCONFIG_LV2_UI_GTKMM2=0
		-DCONFIG_NSM=0
		-DCONFIG_SSE=$(usex cpu_flags_x86_sse 1 0)
		-DCONFIG_STACKTRACE=$(usex debug 1 0)
	)
	# Following options are left to the default
	#
	# default ON:
	# CONFIG_GRADIENT
	# CONFIG_JACK_LATENCY
	# CONFIG_JACK_METADATA
	# CONFIG_JACK_SESSION
	# CONFIG_LIBLILV
	# CONFIG_LV2
	# CONFIG_LV2_ATOM
	# CONFIG_LV2_BUF_SIZE
	# CONFIG_LV2_CVPORT
	# CONFIG_LV2_EXTERNAL_UI
	# CONFIG_LV2_MIDNAM
	# CONFIG_LV2_OPTIONS
	# CONFIG_LV2_PARAMETERS
	# CONFIG_LV2_PATCH
	# CONFIG_LV2_PORT_CHANGE_REQUEST
	# CONFIG_LV2_PORT_EVENT
	# CONFIG_LV2_PRESETS
	# CONFIG_LV2_PROGRAMS
	# CONFIG_LV2_STATE
	# CONFIG_LV2_STATE_FILES
	# CONFIG_LV2_STATE_FREE_PATH
	# CONFIG_LV2_TIME
	# CONFIG_LV2_TIME_POSITION
	# CONFIG_LV2_UI
	# CONFIG_LV2_UI_IDLE
	# CONFIG_LV2_UI_REQ_VALUE
	# CONFIG_LV2_UI_SHOW
	# CONFIG_LV2_UI_TOUCH
	# CONFIG_LV2_WORKER
	# CONFIG_LV2_UI_X11
	# CONFIG_MINIBPM
	# CONFIG_OSC
	# CONFIG_QT6
	# CONFIG_VESTIGE
	# CONFIG_VST2
	# CONFIG_VST3_XCB
	# CONFIG_VST3
	#
	# default OFF:
	# CONFIG_LIBAUBIO # replaced by minibpm
	# CONFIG_LIBSUIL # deprecated with qt6
	# CONFIG_LV2_EVENT # deprecated
	# CONFIG_LV2_STATE_MAKE_PATH # deprecated
	# CONFIG_WAYLAND # not recommended for now
	# CONFIG_XUNIQUE

	cmake_src_configure
}
