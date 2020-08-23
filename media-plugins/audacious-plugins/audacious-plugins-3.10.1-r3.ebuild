# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="${P/_/-}"

if [[ ${PV} == *9999 ]]; then
	inherit autotools git-r3
	EGIT_REPO_URI="https://github.com/audacious-media-player/audacious-plugins.git"
else
	SRC_URI="https://distfiles.audacious-media-player.org/${MY_P}.tar.bz2"
	KEYWORDS="amd64 x86"
fi
DESCRIPTION="Lightweight and versatile audio player"
HOMEPAGE="https://audacious-media-player.org/"

LICENSE="GPL-2"
SLOT="0"
IUSE="aac +alsa bs2b cdda cue ffmpeg flac fluidsynth http gme jack lame libnotify libsamplerate
	lirc mms modplug mp3 nls opengl pulseaudio scrobbler sdl sid sndfile soxr speedpitch vorbis wavpack"
REQUIRED_USE="|| ( alsa jack pulseaudio sdl )"

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
	nls? ( dev-util/intltool )
"
DEPEND="
	app-arch/unzip
	dev-libs/dbus-glib
	dev-libs/glib
	dev-libs/libxml2:2
	~media-sound/audacious-${PV}[-qt5(-)]
	x11-libs/gtk+:2
	x11-libs/libXcomposite
	x11-libs/libXrender
	aac? ( >=media-libs/faad2-2.7 )
	alsa? ( >=media-libs/alsa-lib-1.0.16 )
	bs2b? ( media-libs/libbs2b )
	cdda? (
		dev-libs/libcdio:=
		dev-libs/libcdio-paranoia:=
		>=media-libs/libcddb-1.2.1
	)
	cue? ( media-libs/libcue:= )
	ffmpeg? ( >=media-video/ffmpeg-0.7.3 )
	flac? (
		>=media-libs/flac-1.2.1-r1
		>=media-libs/libvorbis-1.0
	)
	fluidsynth? ( media-sound/fluidsynth:= )
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
		>=media-libs/libogg-1.1.3
		>=media-libs/libvorbis-1.2.0
	)
	wavpack? ( >=media-sound/wavpack-4.50.1-r1 )
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default
	if ! use nls; then
		sed -e "/SUBDIRS/s/ po//" -i Makefile || die # bug #512698
	fi
	[[ ${PV} == *9999 ]] && eautoreconf
}

src_configure() {
	use mp3 || ewarn "MP3 support is optional, you may want to enable the mp3 USE-flag"

	local myeconfargs=(
		--enable-mpris2
		--enable-songchange
		--enable-aosd
		--enable-gtk
		--enable-hotkey
		--disable-adplug # not packaged
		--disable-ampache # needs Qt5
		--disable-coreaudio
		--disable-oss4
		--disable-qt
		--disable-qtaudio
		--disable-sndio
		$(use_enable aac)
		$(use_enable alsa)
		$(use_enable bs2b)
		$(use_enable cdda cdaudio)
		$(use_enable cue)
		$(use_enable flac)
		$(use_enable flac filewriter)
		$(use_enable fluidsynth amidiplug)
		$(use_enable gme console)
		$(use_enable http neon)
		$(use_enable jack)
		$(use_enable lame filewriter_mp3)
		$(use_enable libnotify notify)
		$(use_enable libsamplerate resample)
		$(use_enable lirc)
		$(use_enable mms)
		$(use_enable modplug)
		$(use_enable mp3 mpg123)
		$(use_enable nls)
		$(use_enable pulseaudio pulse)
		$(use_enable scrobbler scrobbler2)
		$(use_enable sdl sdlout)
		$(use_enable sid)
		$(use_enable sndfile)
		$(use_enable soxr)
		$(use_enable speedpitch)
		$(use_enable vorbis)
		$(use_enable wavpack)
		$(use_with ffmpeg ffmpeg ffmpeg)
	)

	econf "${myeconfargs[@]}"
}
