# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_P="${P/_/-}"

DESCRIPTION="Lightweight and versatile audio player"
HOMEPAGE="https://audacious-media-player.org/"

if [[ ${PV} == *9999 ]]; then
	inherit autotools git-r3
	EGIT_REPO_URI="https://github.com/audacious-media-player/audacious-plugins.git"
else
	SRC_URI="https://distfiles.audacious-media-player.org/${MY_P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="aac +adplug alsa ampache aosd bs2b cdda cue ffmpeg flac fluidsynth http gme jack lame libav libnotify
	libnotify libsamplerate lirc mms modplug mp3 nls pulseaudio scrobbler sdl sid sndfile soxr speedpitch vorbis wavpack"
REQUIRED_USE="
	|| ( alsa jack pulseaudio sdl )
	ampache? ( http )"

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
RDEPEND="
	app-arch/unzip
	dev-libs/dbus-glib
	dev-libs/glib
	dev-libs/libxml2:2
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtmultimedia:5
	dev-qt/qtwidgets:5
	media-libs/adplug
	~media-sound/audacious-${PV}
	aac? ( >=media-libs/faad2-2.7 )
	alsa? ( >=media-libs/alsa-lib-1.0.16 )
	ampache? ( =media-libs/ampache_browser-1* )
	aosd? (
		x11-libs/libXrender
		x11-libs/libXcomposite
	)
	bs2b? ( media-libs/libbs2b )
	cdda? (
		>=media-libs/libcddb-1.2.1
		dev-libs/libcdio:=
		dev-libs/libcdio-paranoia
	)
	cue? ( media-libs/libcue )
	ffmpeg? ( >=virtual/ffmpeg-0.7.3 )
	flac? (
		>=media-libs/libvorbis-1.0
		>=media-libs/flac-1.2.1-r1
	)
	fluidsynth? ( media-sound/fluidsynth )
	http? ( >=net-libs/neon-0.26.4 )
	jack? (
		>=media-libs/bio2jack-0.4
		virtual/jack
	)
	lame? ( media-sound/lame )
	libnotify? ( x11-libs/libnotify )
	libsamplerate? ( media-libs/libsamplerate:= )
	lirc? ( app-misc/lirc )
	mms? ( >=media-libs/libmms-0.3 )
	modplug? ( media-libs/libmodplug )
	mp3? ( >=media-sound/mpg123-1.12.1 )
	pulseaudio? ( >=media-sound/pulseaudio-0.9.3 )
	scrobbler? ( net-misc/curl )
	sdl? ( media-libs/libsdl2[sound] )
	sid? ( >=media-libs/libsidplayfp-1.0.0 )
	sndfile? ( >=media-libs/libsndfile-1.0.17-r1 )
	soxr? ( media-libs/soxr )
	speedpitch? ( media-libs/libsamplerate:= )
	vorbis? (
		>=media-libs/libvorbis-1.2.0
		>=media-libs/libogg-1.1.3
	)
	wavpack? ( >=media-sound/wavpack-4.50.1-r1 )"

DEPEND="${RDEPEND}
	dev-util/gdbus-codegen
	virtual/pkgconfig
	nls? ( dev-util/intltool )"

PATCHES=( "${FILESDIR}/${P}-fix-slow-search.patch" )

S="${WORKDIR}/${MY_P}"

src_configure() {
	if ! use mp3 ; then
		ewarn "MP3 support is optional, you may want to enable the mp3 USE-flag"
	fi

	econf \
		--enable-mpris2 \
		--enable-qt \
		--enable-qtaudio \
		--enable-songchange \
		--disable-coreaudio \
		--disable-gtk \
		--disable-hotkey \
		--disable-notify \
		--disable-oss4 \
		--disable-qtglspectrum \
		--disable-sndio \
		$(use_enable aac) \
		$(use_enable alsa) \
		$(use_enable ampache) \
		$(use_enable aosd) \
		$(use_enable bs2b) \
		$(use_enable cdda cdaudio) \
		$(use_enable cue) \
		$(use_enable flac) \
		$(use_enable fluidsynth amidiplug) \
		$(use_enable flac filewriter) \
		$(use_enable gme console) \
		$(use_enable http neon) \
		$(use_enable jack) \
		$(use_enable lame filewriter_mp3) \
		$(use_enable libnotify notify) \
		$(use_enable libsamplerate resample) \
		$(use_enable lirc) \
		$(use_enable mms) \
		$(use_enable modplug) \
		$(use_enable mp3 mpg123) \
		$(use_enable nls) \
		$(use_enable pulseaudio pulse) \
		$(use_enable scrobbler scrobbler2) \
		$(use_enable sdl sdlout) \
		$(use_enable sid) \
		$(use_enable sndfile) \
		$(use_enable soxr) \
		$(use_enable speedpitch) \
		$(use_enable vorbis) \
		$(use_enable wavpack) \
		$(use_with ffmpeg ffmpeg $(usex libav libav ffmpeg))
}
