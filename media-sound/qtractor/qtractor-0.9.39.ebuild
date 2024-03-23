# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="Audio/MIDI multi-track sequencer written in C++ with the Qt framework"
HOMEPAGE="https://qtractor.sourceforge.io https://github.com/rncbc/qtractor"
SRC_URI="mirror://sourceforge/qtractor/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE="aubio cpu_flags_x86_sse debug dssi ladspa libsamplerate mad osc rubberband vorbis zlib"
REQUIRED_USE="dssi? ( ladspa )"

BDEPEND="
	dev-qt/linguist-tools:5
	virtual/pkgconfig
"
DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	dev-qt/qtx11extras:5
	media-libs/alsa-lib
	media-libs/libsndfile
	media-libs/lilv
	media-libs/lv2
	media-libs/suil
	virtual/jack
	x11-libs/libxcb:=
	aubio? ( media-libs/aubio:= )
	dssi? ( media-libs/dssi )
	ladspa? ( media-libs/ladspa-sdk )
	libsamplerate? ( media-libs/libsamplerate )
	mad? ( media-libs/libmad )
	osc? ( media-libs/liblo )
	rubberband? ( media-libs/rubberband )
	vorbis? (
		media-libs/libogg
		media-libs/libvorbis
	)
	zlib? ( sys-libs/zlib )
"
RDEPEND="${DEPEND}"

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCONFIG_DSSI=$(usex dssi 1 0)
		-DCONFIG_GRADIENT=1
		-DCONFIG_JACK_LATENCY=1
		-DCONFIG_JACK_METADATA=1
		-DCONFIG_JACK_SESSION=1
		-DCONFIG_LADSPA=$(usex ladspa 1 0)
		-DCONFIG_LIBAUBIO=$(usex aubio 1 0)
		-DCONFIG_LIBLILV=1
		-DCONFIG_LIBLO=$(usex osc 1 0)
		-DCONFIG_LIBMAD=$(usex mad 1 0)
		-DCONFIG_LIBRUBBERBAND=$(usex rubberband 1 0)
		-DCONFIG_LIBSAMPLERATE=$(usex libsamplerate 1 0)
		-DCONFIG_LIBVORBIS=$(usex vorbis 1 0)
		-DCONFIG_LIBZ=$(usex zlib 1 0)
		-DCONFIG_LV2=1
		-DCONFIG_LV2_UI_GTK2=0
		-DCONFIG_NSM=0
		-DCONFIG_QT6=0
		-DCONFIG_SSE=$(usex cpu_flags_x86_sse 1 0)
		-DCONFIG_STACKTRACE=$(usex debug 1 0)
		-DCONFIG_VESTIGE=1
		-DCONFIG_VST2=1
		-DCONFIG_VST3=0
		-DCONFIG_XUNIQUE=0
	)
	# Following options are left to the default
	# CONFIG_LV2_ATOM
	# CONFIG_LV2_BUF_SIZE
	# CONFIG_LV2_CVPORT
	# CONFIG_LV2_EVENT
	# CONFIG_LV2_EXTERNAL_UI
	# CONFIG_LV2_MIDNAM
	# CONFIG_LV2_OPTIONS
	# CONFIG_LV2_PARAMETERS
	# CONFIG_LV2_PATCH
	# CONFIG_LV2_PORT_EVENT
	# CONFIG_LV2_PRESETS
	# CONFIG_LV2_PROGRAMS
	# CONFIG_LV2_STATE
	# CONFIG_LV2_STATE_FILES
	# CONFIG_LV2_STATE_MAKE_PATH
	# CONFIG_LV2_TIME
	# CONFIG_LV2_TIME_POSITION
	# CONFIG_LV2_UI
	# CONFIG_LV2_UI_IDLE
	# CONFIG_LV2_UI_REQ_VALUE
	# CONFIG_LV2_UI_SHOW
	# CONFIG_LV2_UI_TOUCH
	# CONFIG_LV2_WORKER
	# CONFIG_LV2_UI_X11
	cmake_src_configure
}
