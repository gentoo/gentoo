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
KEYWORDS="~amd64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="
	aac +alsa ampache bs2b cdda cue ffmpeg flac fluidsynth gme gtk http jack
	lame libnotify libsamplerate lirc mms modplug +mp3 mpris opengl openmpt opus
	pipewire pulseaudio qt6 qtmedia scrobbler sdl sid sndfile soxr streamtuner
	vorbis wavpack wayland X
"

REQUIRED_USE="
	ampache? ( http )
	streamtuner? ( http )
"

# Most plugins support GTK/Qt and X/wayland alternatives.
# These plugins require a specific GUI:
#   aosd (X+gtk)
#   ampache (qt6)
#   ladspa (gtk)
#   skins/Winamp (X)
BDEPEND="
	virtual/pkgconfig
	mpris? ( >=dev-util/gdbus-codegen-2.80.5-r1 )
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
		>=dev-libs/libcdio-0.90:=
		dev-libs/libcdio-paranoia:=
		>=media-libs/libcddb-1.2.1
	)
	cue? ( media-libs/libcue:= )
	ffmpeg? ( >=media-video/ffmpeg-4.2.3:= )
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
	openmpt? ( >=media-libs/libopenmpt-0.3 )
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

_have_gui() {
	if use gtk || use qt6; then
		echo true
		return 0
	else
		echo false
		return 1
	fi
}

src_configure() {
	# defang automagic dependencies
	use X || append-cppflags -DGENTOO_GTK_HIDE_X11
	use wayland || append-cppflags -DGENTOO_GTK_HIDE_WAYLAND

	local emesonargs=(
		# GUI toolkits
		$(meson_use gtk gtk)
		$(meson_use gtk gtkui)
		-Dgtk2=false
		$(meson_use qt6 qt)
		$(meson_use qt6 qtui)
		-Dqt5=false
		-Dskins=$(usex X $(_have_gui) false) # Winamp

		# container plugins
		$(meson_use cue)

		# transport plugins
		$(meson_use mms)
		$(meson_use http neon)
		# default true:
		# gio

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
		-Dvtx=$(_have_gui)
		$(meson_use wavpack)
		# default true:
		# metronom
		# psf (zlib)
		# tonegen
		# xsf (zlib)

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
		-Dalbumart=$(_have_gui)
		$(meson_use ampache)
		-Daosd=$(usex X $(usex gtk true false) false)
		-Ddelete-files=$(_have_gui)
		-Dfilebrowser=$(_have_gui)
		$(meson_use X hotkey)
		$(meson_use lirc)
		-Dlyrics=$(_have_gui)
		$(meson_use mpris mpris2)
		$(meson_use libnotify notify)
		-Dmac-now-playing=false
		-Dplayback-history=$(_have_gui)
		-Dplaylist-manager=$(_have_gui)
		$(meson_use scrobbler scrobbler2)
		-Dsearchtool=$(_have_gui)
		$(meson_use qt6 songinfo)
		-Dstatusicon=$(_have_gui)
		$(meson_use streamtuner)
		# default true:
		# songchange (glib)

		# playlist plugins
		# default true:
		# asx
		# asx3 (libxml2)
		# m3u
		# pls
		# xspf (glib, libxml2)

		# effect plugins
		$(meson_use bs2b)
		$(meson_use gtk ladspa)
		$(meson_use libsamplerate resample)
		$(meson_use libsamplerate speedpitch)
		$(meson_use soxr)
		# default true:
		# background-music
		# bitcrusher
		# compressor
		# crossfade
		# crystalizer
		# echo
		# mixer
		# silence-removal
		# stereo
		# voice-removal

		# visualization plugins
		-Dblurscope=$(_have_gui)
		$(meson_use opengl gl-spectrum)
		-Dspectrum-analyzer=$(_have_gui)
		-Dvumeter=$(_have_gui)
	)

	meson_src_configure
}

src_install() {
	meson_src_install

	if _have_gui && use X; then
		# the skin Winamp2.9 is copyrighted, so revert upstream' commit 367e7a3
		# see comments at https://www.gnome-look.org/p/1008229 and bug #965338
		# part of skins-data which depends on X-gui
		rm -r "${ED}"/usr/share/audacious/Skins/Winamp2.9 || die

		# Gentoo_ice Winamp skin installation; bug #109772
		# The Winamp interface is not supported on Wayland.
		insinto /usr/share/audacious/Skins/gentoo_ice
		doins -r "${WORKDIR}"/gentoo_ice/.
		docinto gentoo_ice
		dodoc "${WORKDIR}"/README
	fi
}

pkg_postinst() {
	if ! use X && _have_gui; then
		einfo "The Winamp interface is not usable yet on Wayland."
	fi
}
