# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils

MY_P="${P/_/-}"
S="${WORKDIR}/${MY_P}"
DESCRIPTION="Audacious Player - Your music, your way, no exceptions"
HOMEPAGE="http://audacious-media-player.org/"
SRC_URI="!gtk3? ( http://distfiles.audacious-media-player.org/${MY_P}.tar.bz2 )
	 gtk3? ( http://distfiles.audacious-media-player.org/${MY_P}-gtk3.tar.bz2 )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ~hppa ppc ~ppc64 x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux"
IUSE="aac adplug alsa bs2b cdda cue ffmpeg flac fluidsynth gnome http gtk3 jack
lame libnotify libsamplerate lirc mms mp3 nls pulseaudio qt5 scrobbler sdl sid sndfile vorbis wavpack"
REQUIRED_USE="|| ( alsa flac lame jack pulseaudio qt5 sdl )"

RDEPEND="app-arch/unzip
	>=dev-libs/dbus-glib-0.60
	dev-libs/libxml2:2
	media-libs/libmodplug
	~media-sound/audacious-${PV}
	( || ( >=dev-libs/glib-2.32.2[utils] dev-util/gdbus-codegen ) )
	aac? ( >=media-libs/faad2-2.7 )
	adplug? ( >=dev-cpp/libbinio-1.4 )
	alsa? ( >=media-libs/alsa-lib-1.0.16 )
	bs2b? ( media-libs/libbs2b )
	cdda? ( >=media-libs/libcddb-1.2.1
		dev-libs/libcdio-paranoia )
	cue? ( media-libs/libcue )
	ffmpeg? ( >=virtual/ffmpeg-0.7.3 )
	flac? ( >=media-libs/libvorbis-1.0
		>=media-libs/flac-1.2.1-r1 )
	fluidsynth? ( media-sound/fluidsynth )
	http? ( >=net-libs/neon-0.26.4 )
	!gtk3? ( x11-libs/gtk+:2 )
	gtk3? ( x11-libs/gtk+:3 )
	qt5? ( dev-qt/qtcore:5
	      dev-qt/qtgui:5
	      dev-qt/qtmultimedia:5
	      dev-qt/qtwidgets:5 )
	jack? ( >=media-libs/bio2jack-0.4
		media-sound/jack-audio-connection-kit )
	lame? ( media-sound/lame )
	libnotify? ( x11-libs/libnotify )
	libsamplerate? ( media-libs/libsamplerate )
	lirc? ( app-misc/lirc )
	mms? ( >=media-libs/libmms-0.3 )
	mp3? ( >=media-sound/mpg123-1.12.1 )
	pulseaudio? ( >=media-sound/pulseaudio-0.9.3 )
	scrobbler? ( net-misc/curl )
	sdl? ( media-libs/libsdl[sound] )
	sid? ( >=media-libs/libsidplayfp-1.0.0 )
	sndfile? ( >=media-libs/libsndfile-1.0.17-r1 )
	vorbis? ( >=media-libs/libvorbis-1.2.0
		  >=media-libs/libogg-1.1.3 )
	wavpack? ( >=media-sound/wavpack-4.50.1-r1 )"

DEPEND="${RDEPEND}
	nls? ( dev-util/intltool )
	virtual/pkgconfig"

mp3_warning() {
	if ! use mp3 ; then
		ewarn "MP3 support is optional, you may want to enable the mp3 USE-flag"
	fi
}

src_unpack() {
	default
	if use gtk3 ; then
		mv "${MY_P}-gtk3" "${MY_P}"
	fi
}

src_prepare() {
	has_version "<dev-libs/glib-2.32" && \
		cd "${S}"/src/mpris2 && \
		gdbus-codegen --interface-prefix org.mpris. \
			--c-namespace Mpris --generate-c-code object-core mpris2.xml && \
		gdbus-codegen --interface-prefix org.mpris. \
			--c-namespace Mpris \
			--generate-c-code object-player mpris2-player.xml && \
		cd "${S}"
}

src_configure() {
	mp3_warning

	if use ffmpeg && has_version media-video/ffmpeg ; then
		ffmpeg="--with-ffmpeg=ffmpeg"
	elif use ffmpeg && has_version media-video/libav ; then
		ffmpeg="--with-ffmpeg=libav"
	else
		ffmpeg="--with-ffmpeg=none"
	fi

	econf \
		${ffmpeg} \
		--enable-modplug \
		--enable-statusicon \
		--disable-soxr \
		$(use_enable adplug) \
		$(use_enable aac) \
		$(use_enable alsa) \
		$(use_enable bs2b) \
		$(use_enable cdda cdaudio) \
		$(use_enable cue) \
		$(use_enable flac flacng) \
		$(use_enable fluidsynth amidiplug) \
		$(use_enable flac filewriter_flac) \
		$(use_enable http neon) \
		$(use_enable jack) \
		$(use_enable gnome gnomeshortcuts) \
		$(use_enable lame filewriter_mp3) \
		$(use_enable libnotify notify) \
		$(use_enable libsamplerate resample) \
		$(use_enable lirc) \
		$(use_enable mms) \
		$(use_enable mp3) \
		$(use_enable nls) \
		$(use_enable pulseaudio pulse) \
		$(use_enable qt5 qt) \
		$(use_enable scrobbler scrobbler2) \
		$(use_enable sdl sdlout) \
		$(use_enable sid) \
		$(use_enable sndfile) \
		$(use_enable vorbis) \
		$(use_enable wavpack)
}
