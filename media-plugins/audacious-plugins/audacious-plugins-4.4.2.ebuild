# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Lightweight and versatile audio player"
HOMEPAGE="https://audacious-media-player.org/"
SRC_URI="https://distfiles.audacious-media-player.org/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~riscv x86"
IUSE="
	aac +alsa ampache bs2b cdda cue ffmpeg flac fluidsynth gme gtk http jack
	lame libnotify libsamplerate lirc mms modplug mp3 opengl openmpt opus
	pipewire pulseaudio qt6 scrobbler sdl sid sndfile soxr speedpitch
	streamtuner vorbis wavpack X
"

REQUIRED_USE="
	ampache? ( http )
	streamtuner? ( http )
"

# The following plugins REQUIRE a GUI build of audacious, because non-GUI
# builds do NOT install the libaudgui library & headers.
# Plugins without a configure option:
#   alarm
#   albumart
#   delete-files
#   ladspa
#   playlist-manager
#   search-tool
#   skins
#   vtx
# Plugins with a configure option:
#   glspectrum
#   gtkui
#   hotkey
#   notify
#   statusicon
BDEPEND="
	dev-util/gdbus-codegen
	virtual/pkgconfig
"
DEPEND="
	app-arch/unzip
	dev-libs/glib:2
	dev-libs/libxml2:2
	~media-sound/audacious-${PV}[gtk=,qt6=]
	sys-libs/zlib
	>=x11-libs/gdk-pixbuf-2.26:2
	aac? ( >=media-libs/faad2-2.7 )
	alsa? ( >=media-libs/alsa-lib-1.0.16 )
	ampache? ( =media-libs/ampache_browser-1*:= )
	bs2b? ( >=media-libs/libbs2b-3.0.0 )
	cdda? (
		>=dev-libs/libcdio-0.70:=
		dev-libs/libcdio-paranoia:=
		>=media-libs/libcddb-1.2.1
	)
	cue? ( media-libs/libcue:= )
	ffmpeg? ( >=media-video/ffmpeg-0.7.3:= )
	flac? (
		>=media-libs/flac-1.2.1-r1:=
		>=media-libs/libvorbis-1.0
	)
	fluidsynth? ( >=media-sound/fluidsynth-1.0.6:= )
	gtk? (
		>=dev-libs/json-glib-1.0
		x11-libs/cairo
		>=x11-libs/gtk+-3.22:3
		x11-libs/pango
		X? (
			opengl? ( virtual/opengl )
			x11-libs/libX11
			x11-libs/libXcomposite
			x11-libs/libXrender
		)
	)
	http? ( >=net-libs/neon-0.27 )
	jack? (
		>=media-libs/bio2jack-0.4
		virtual/jack
	)
	lame? ( media-sound/lame )
	libnotify? ( >=x11-libs/libnotify-0.7 )
	libsamplerate? ( media-libs/libsamplerate:= )
	lirc? ( app-misc/lirc )
	mms? ( >=media-libs/libmms-0.3 )
	modplug? ( media-libs/libmodplug )
	mp3? ( media-sound/mpg123-base )
	openmpt? ( >=media-libs/libopenmpt-0.2 )
	opus? ( >=media-libs/opusfile-0.4 )
	pipewire? ( >=media-video/pipewire-0.3.26:= )
	pulseaudio? ( >=media-libs/libpulse-0.9.5 )
	qt6? (
		dev-qt/qtbase:6[gui,opengl?,widgets]
		dev-qt/qtmultimedia:6
		X? (
			dev-qt/qtbase:6=[X]
			x11-libs/libX11
		)
	)
	scrobbler? ( >=net-misc/curl-7.9.7 )
	sdl? ( >=media-libs/libsdl2-2.0[sound] )
	sid? ( >=media-libs/libsidplayfp-2.0 )
	sndfile? ( >=media-libs/libsndfile-1.0.17-r1 )
	soxr? ( media-libs/soxr )
	speedpitch? ( media-libs/libsamplerate:= )
	streamtuner? ( dev-qt/qtbase:6[network] )
	vorbis? (
		>=media-libs/libogg-1.1.3
		>=media-libs/libvorbis-1.2.0
	)
	wavpack? ( >=media-sound/wavpack-4.50.1-r1 )
"
RDEPEND="${DEPEND}"

pkg_setup() {
	use mp3 || ewarn "MP3 support is optional, you may want to enable the mp3 USE-flag"
}

src_prepare() {
	default
	if ! use X; then
		sed -i -e "s/dependency('x11',.*)/disabler()/" meson.build || die
	fi
}

src_configure() {
	local emesonargs=(
		# GUI toolkits
		$(meson_use gtk)
		-Dgtk2=false
		$(meson_use qt6 qt)
		-Dqt5=false

		# container plugins
		$(meson_use cue cue)

		# transport plugins
		$(meson_use mms mms)
		$(meson_use http neon)

		# input plugins
		$(meson_use aac aac)
		-Dadplug=false
		$(meson_use fluidsynth amidiplug)
		$(meson_use cdda cdaudio)
		$(meson_use gme console)
		$(meson_use ffmpeg ffaudio)
		$(meson_use flac flac)
		$(meson_use modplug modplug)
		$(meson_use mp3 mpg123)
		$(meson_use openmpt openmpt)
		$(meson_use opus opus)
		$(meson_use sid sid)
		$(meson_use sndfile sndfile)
		$(meson_use vorbis vorbis)
		$(meson_use wavpack wavpack)

		# output plugins
		$(meson_use alsa alsa)
		-Dcoreaudio=false
		# filewriter
		$(meson_use flac filewriter-flac)
		$(meson_use lame filewriter-mp3)
		$(meson_use vorbis filewriter-ogg)
		$(meson_use jack jack)
		-Doss=false
		$(meson_use pipewire pipewire)
		$(meson_use pulseaudio pulse)
		$(meson_use qt6 qtaudio)
		$(meson_use sdl sdlout)
		-Dsndio=false

		# general plugins
		$(meson_use ampache ampache)
		$(meson_use X aosd)
		$(meson_use X hotkey)
		$(meson_use lirc lirc)
		-Dmac-media-keys=false
		-Dmpris2=true
		$(meson_use libnotify notify)
		$(meson_use scrobbler scrobbler2)
		-Dsongchange=true
		$(meson_use streamtuner streamtuner)

		# effect plugins
		$(meson_use bs2b bs2b)
		$(meson_use libsamplerate resample)
		$(meson_use soxr soxr)
		$(meson_use speedpitch speedpitch)

		# visualization plugins
		$(meson_use opengl gl-spectrum)
		-Dvumeter=true
	)

	meson_src_configure
}
