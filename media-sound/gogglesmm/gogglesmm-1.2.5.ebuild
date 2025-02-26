# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="Fast and light music player"
HOMEPAGE="https://gogglesmm.dev/"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="a52 +aac alsa +dbus dca +flac jack libsamplerate +mad nls +opengl +opus"
IUSE+=" +pulseaudio sndio stream tremor +vorbis"
REQUIRED_USE="?? ( tremor vorbis )"

RDEPEND="
	dev-db/sqlite:3
	dev-libs/expat
	media-libs/taglib:=
	>=x11-libs/fox-1.7.80:1.7
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	a52? ( media-libs/a52dec )
	aac? ( media-libs/faad2 )
	alsa? ( media-libs/alsa-lib )
	dbus? ( sys-apps/dbus )
	dca? ( media-libs/libdca )
	flac? ( media-libs/flac:= )
	jack? ( virtual/jack )
	libsamplerate? ( media-libs/libsamplerate )
	mad? ( media-libs/libmad )
	nls? ( virtual/libintl )
	opengl? (
		media-libs/libepoxy
		virtual/glu
	)
	opus? (
		media-libs/libogg
		media-libs/opus
	)
	pulseaudio? ( media-libs/libpulse )
	sndio? ( media-sound/sndio:= )
	stream? (
		dev-libs/libgcrypt:=
		sys-libs/zlib
	)
	tremor? (
		media-libs/libogg
		media-libs/tremor
	)
	vorbis? (
		media-libs/libogg
		media-libs/libvorbis
	)
"
DEPEND="${RDEPEND}
	x11-base/xorg-proto
"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	# https://github.com/gogglesmm/gogglesmm/pull/120
	"${FILESDIR}"/${PN}-1.2.5-libsamplerate.patch
)

src_configure() {
	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=ON
		-DBUILD_GAP_SHARED_LIB=ON
		-DWITH_A52="$(usex a52)"
		-DWITH_ALSA="$(usex alsa)"
		# disable bundled fox
		-DWITH_CFOX=OFF
		-DWITH_DBUS="$(usex dbus)"
		-DWITH_DCA="$(usex dca)"
		-DWITH_FAAD="$(usex aac)"
		-DWITH_FLAC="$(usex flac)"
		-DWITH_GCRYPT="$(usex stream)"
		-DWITH_GNUTLS=OFF
		-DWITH_JACK="$(usex jack)"
		-DWITH_LIBSAMPLERATE="$(usex libsamplerate)"
		-DWITH_MAD="$(usex mad)"
		-DWITH_NLS="$(usex nls)"
		# only relevant if associate with tremor, vorbis or opus
		-DWITH_OGG=ON
		-DWITH_OPENGL="$(usex opengl)"
		-DWITH_OPENSSL=OFF
		-DWITH_OPUS="$(usex opus)"
		-DWITH_PULSE="$(usex pulseaudio)"
		# X11 session by default as x11-libs/fox is X11 only
		-DWITH_SESSION=ON
		-DWITH_SNDIO="$(usex sndio)"
		-DWITH_TREMOR="$(usex tremor)"
		-DWITH_VORBIS="$(usex vorbis)"
		-DWITH_ZLIB="$(usex stream)"
	)
	cmake_src_configure
}
