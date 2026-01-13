# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic meson

DESCRIPTION="Lightweight and versatile audio player"
HOMEPAGE="https://audacious-media-player.org/"
SRC_URI="
	https://distfiles.audacious-media-player.org/${P}.tar.bz2
	mirror://gentoo/gentoo_ice-xmms-0.2.tar.bz2
"
# BSD-2 albumart, alsa, asx, audpl, cd-menu-items, compressor, crossfade, cue, delete-files,
# ffaudio, gio, glspectrum, gtkui, jack, ladspa, mixer, mms, mpris2, openmpt, opus, pipewire,
# playlist-manager, qtaudio, qtui, resample, sdl, search-tool, silence-removal, song-info,
# sox-resampler, speedpitch, statusicon-qt, ui-common
# BSD psf, xsf
# GPL-2+ amidiplug, aosd, blur_scope, bs2b, filewriter, flac, hotkey, lirc, m3u, metronom,
# neon, pls, psf(peops), pulse, qtglspectrum, qthotkey, sid, sndfile, statusicon, tonegen,
# vorbis, vtx, xsf(desmume), xspf
# CC-BY-SA-4.0 Glare skin
# GPL-3 ampache, cdaudio, notify, playback-history-qt, scrobbler, skins-qt, skins, songchange,
# LGPL-2.1+ console, ladspa.h
# ISC bitcrusher, cairo-spectrum, crystalizer, lyrics, mpg123, qt-spectrum, streamtuner,
# voice-removal, vumeter
# MIT xsf(spu)
# public-domain modplug
LICENSE="BSD-2 BSD CC-BY-SA-4.0 GPL-2+ GPL-3 ISC LGPL-2.1+ MIT public-domain"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~riscv ~x86"
IUSE="
	aac +alsa ampache bs2b cdda cue ffmpeg flac fluidsynth gme gtk http jack
	lame libnotify libsamplerate lirc mms modplug +mp3 opengl openmpt opus
	pipewire pulseaudio qt6 qtmedia scrobbler sdl sid sndfile soxr streamtuner
	vorbis wavpack wayland X
"

REQUIRED_USE="
	ampache? ( http )
	streamtuner? ( http )
"

# The following plugins REQUIRE a GUI build of audacious, because non-GUI
# builds do NOT install the libaudgui library & headers.
# Plugins without a configure option:
#   albumart{,-qt}
#   blur-scope{,-qt}
#   delete-files
#   filebrowser-qt
#   ladspa
#   lyrics-{gtk,qt}
#   playback-history-qt
#   playlist-manager{,-qt}
#   search-tool{,-qt}
#   song-info-qt
#   spectrum-analyzer
#   statusicon{,-qt}
#   skins{,-qt}
# Plugins with a configure option:
#   aosd (X+gtk)
#   ampache (qt6)
#   glspectrum (X) (handles qtglspectrum if qt6)
#   gtkui
#   hotkey (X) (handles qthotkey if qt6)
#   notify
#   qtui
#   streamtuner (qt6)
#   vumeter{,-qt} (forced)
BDEPEND="
	>=dev-util/gdbus-codegen-2.80.5-r1
	virtual/pkgconfig
"
DEPEND="
	app-arch/unzip
	dev-libs/glib:2
	dev-libs/libxml2:2=
	~media-sound/audacious-${PV}[gtk=,qt6=]
	virtual/zlib:=
	aac? ( media-libs/faad2 )
	alsa? ( >=media-libs/alsa-lib-1.0.16 )
	bs2b? ( >=media-libs/libbs2b-3.0.0 )
	cdda? (
		>=dev-libs/libcdio-0.70:=
		dev-libs/libcdio-paranoia:=
		>=media-libs/libcddb-1.2.1
	)
	cue? ( media-libs/libcue:= )
	ffmpeg? ( >=media-video/ffmpeg-2.8.1:= )
	flac? ( >=media-libs/flac-1.2.1-r1:= )
	fluidsynth? ( >=media-sound/fluidsynth-1.0.6:= )
	gtk? (
		>=dev-libs/json-glib-1.0
		x11-libs/cairo
		>=x11-libs/gdk-pixbuf-2.26:2
		>=x11-libs/gtk+-3.22:3[wayland?,X?]
		x11-libs/pango
		libnotify? ( >=x11-libs/libnotify-0.7 )
		X? (
			x11-libs/libX11
			x11-libs/libXcomposite
			x11-libs/libXrender
			opengl? ( media-libs/libglvnd[X] )
		)
	)
	http? ( >=net-libs/neon-0.27:= )
	jack? ( virtual/jack )
	lame? ( media-sound/lame )
	libsamplerate? ( media-libs/libsamplerate )
	lirc? ( app-misc/lirc )
	mms? ( >=media-libs/libmms-0.3 )
	modplug? ( media-libs/libmodplug )
	mp3? ( >=media-sound/mpg123-base-1.12 )
	openmpt? ( >=media-libs/libopenmpt-0.2 )
	opus? ( >=media-libs/opusfile-0.4 )
	pipewire? ( >=media-video/pipewire-0.3.33:= )
	pulseaudio? ( >=media-libs/libpulse-0.9.5 )
	qt6? (
		dev-qt/qtbase:6[gui,widgets]
		ampache? ( >=media-libs/ampache_browser-1.0.7-r1 )
		libnotify? (
			>=x11-libs/gdk-pixbuf-2.26:2
			>=x11-libs/libnotify-0.7
		)
		opengl? ( dev-qt/qtbase:6[-gles2-only,opengl] )
		qtmedia? ( dev-qt/qtmultimedia:6 )
		streamtuner? ( dev-qt/qtbase:6[network] )
		X? (
			dev-qt/qtbase:6[X]
			x11-libs/libX11
		)
	)
	scrobbler? ( >=net-misc/curl-7.9.7 )
	sdl? ( >=media-libs/libsdl3-3.2.0 )
	sid? ( >=media-libs/libsidplayfp-2.0:= )
	sndfile? ( >=media-libs/libsndfile-1.0.17-r1 )
	soxr? ( media-libs/soxr )
	vorbis? (
		>=media-libs/libogg-1.1.3
		>=media-libs/libvorbis-1.2.0
	)
	wavpack? ( >=media-sound/wavpack-4.50.1-r1 )
"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	# avoid automagic for glspectrum
	if ! use X; then
		sed -i -e "s/dependency('x11',.*)/disabler()/" meson.build || die
	fi
}

src_configure() {
	# defang automagic dependencies
	use X || append-cppflags -DGENTOO_GTK_HIDE_X11
	use wayland || append-cppflags -DGENTOO_GTK_HIDE_WAYLAND

	local emesonargs=(
		# GUI toolkits
		$(meson_use gtk)
		-Dgtk2=false
		$(meson_use qt6 qt)
		-Dqt5=false

		# container plugins
		$(meson_use cue)

		# transport plugins
		$(meson_use mms)
		$(meson_use http neon)

		# input plugins
		$(meson_use aac)
		-Dadplug=false
		$(meson_use fluidsynth amidiplug)
		$(meson_use cdda cdaudio)
		$(meson_use gme console)
		$(meson_use ffmpeg ffaudio)
		$(meson_use flac)
		$(meson_use modplug)
		$(meson_use mp3 mpg123)
		$(meson_use openmpt)
		$(meson_use opus)
		$(meson_use sid)
		$(meson_use sndfile)
		$(meson_use vorbis)
		$(meson_use wavpack)

		# output plugins
		$(meson_use alsa)
		-Dcoreaudio=false
		# filewriter
		$(meson_use flac filewriter-flac)
		$(meson_use lame filewriter-mp3)
		$(meson_use vorbis filewriter-ogg)
		$(meson_use jack)
		-Doss=false
		$(meson_use pipewire)
		$(meson_use pulseaudio pulse)
		$(meson_use qtmedia qtaudio)
		$(meson_use sdl sdlout)
		-Dsndio=false

		# general plugins
		$(meson_use ampache)
		$(meson_use X aosd)
		$(meson_use X hotkey)
		$(meson_use lirc)
		-Dmac-media-keys=false
		-Dmpris2=true
		$(meson_use libnotify notify)
		$(meson_use scrobbler scrobbler2)
		-Dsongchange=true
		$(meson_use streamtuner)

		# effect plugins
		$(meson_use bs2b)
		$(meson_use libsamplerate resample)
		$(meson_use libsamplerate speedpitch)
		$(meson_use soxr)

		# visualization plugins
		$(meson_use opengl gl-spectrum)
		-Dvumeter=true
	)

	meson_src_configure
}

src_install() {
	meson_src_install

	# the skin Winamp2.9 is copyrighted, so revert upstream' commit 367e7a3
	# see comments at https://www.gnome-look.org/p/1008229 and bug #965338
	# part of skins-data which depends on gui
	if use gtk || use qt6; then
		rm -r "${ED}"/usr/share/audacious/Skins/Winamp2.9 || die
	fi

	# Gentoo_ice Winamp skin installation; bug #109772
	# The Winamp interface is not supported on Wayland.
	if use X; then
		insinto /usr/share/audacious/Skins/gentoo_ice
		doins -r "${WORKDIR}"/gentoo_ice/.
		docinto gentoo_ice
		dodoc "${WORKDIR}"/README
	fi
}
