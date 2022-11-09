# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{1..4} luajit )

inherit autotools desktop lua-single xdg

DESCRIPTION="Music player for a wide range of formats designed for gapless playback"
HOMEPAGE="https://aqualung.jeremyevans.net/ https://github.com/jeremyevans/aqualung"
SRC_URI="https://github.com/jeremyevans/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="alsa cdda cddb debug flac ffmpeg ifp jack ladspa lame libsamplerate
	lua mac modplug mp3 musepack oss podcast pulseaudio sndfile speex systray
	vorbis wavpack"

REQUIRED_USE="lua? ( ${LUA_REQUIRED_USE} )"

BDEPEND="
	virtual/pkgconfig
	sys-devel/gettext
"
RDEPEND="
	app-arch/bzip2
	dev-libs/libxml2
	sys-libs/zlib
	x11-libs/gtk+:2
	alsa? ( media-libs/alsa-lib )
	cdda? ( dev-libs/libcdio-paranoia )
	cddb? ( media-libs/libcddb )
	ffmpeg? ( media-video/ffmpeg:= )
	flac? ( media-libs/flac:= )
	ifp? ( media-libs/libifp )
	jack? ( virtual/jack )
	ladspa? ( media-libs/liblrdf )
	lame? ( media-sound/lame )
	libsamplerate? ( media-libs/libsamplerate )
	lua? ( ${LUA_DEPS} )
	mac? ( media-sound/mac )
	modplug? ( media-libs/libmodplug )
	mp3? ( media-libs/libmad )
	musepack? ( >=media-sound/musepack-tools-444 )
	pulseaudio? ( media-sound/pulseaudio )
	sndfile? ( media-libs/libsndfile )
	speex? ( media-libs/speex media-libs/liboggz media-libs/libogg )
	vorbis? ( media-libs/libvorbis media-libs/libogg )
	wavpack? ( media-sound/wavpack )
"
DEPEND="
	${RDEPEND}
"

PATCHES=(
	"${FILESDIR}/${P}-configure-lua-version.patch"
	"${FILESDIR}/${P}-ifp.patch"
	"${FILESDIR}/${P}-var-collision.patch"
)

pkg_setup() {
	use lua && lua-single_pkg_setup
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--disable-rpath \
		--enable-loop \
		--enable-nls \
		--enable-transcoding \
		$(use_enable debug) \
		$(use_enable podcast) \
		$(use_enable systray) \
		$(use_enable jack jack-mgmt) \
		$(use_with alsa) \
		$(use_with cdda) \
		$(use_with cddb) \
		$(use_with ffmpeg lavc) \
		$(use_with flac) \
		$(use_with ifp) \
		$(use_with jack) \
		$(use_with ladspa) \
		$(use_with lame) \
		$(use_with libsamplerate src) \
		$(use_with lua) \
		$(use_with mac) \
		$(use_with modplug mod) \
		$(use_with mp3 mpeg) \
		$(use_with musepack mpc) \
		$(use_with oss) \
		$(use_with pulseaudio pulse) \
		$(use_with sndfile) \
		$(use_with speex) \
		$(use_with vorbis vorbis) \
		$(use_with vorbis vorbisenc) \
		$(use_with wavpack)
}

src_install() {
	default

	newicon src/img/icon_64.png aqualung.png
	make_desktop_entry aqualung Aqualung
}
