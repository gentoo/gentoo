# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools xdg flag-o-matic toolchain-funcs plocale

DESCRIPTION="DeaDBeeF is a modular audio player similar to foobar2000"
HOMEPAGE="https://deadbeef.sourceforge.io/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="
	GPL-2
	LGPL-2.1
	wavpack? ( BSD )
"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"
IUSE="aac alsa cdda converter cover dts ffmpeg flac +hotkeys lastfm libsamplerate mp3 musepack nls notify +nullout opus oss pulseaudio sc68 shellexec +supereq threads vorbis wavpack"

REQUIRED_USE="
	|| ( alsa oss pulseaudio nullout )
"

DEPEND="
	x11-libs/gtk+:3
	net-misc/curl:=
	dev-libs/jansson:=
	aac? ( media-libs/faad2 )
	alsa? ( media-libs/alsa-lib )
	cdda? (
		dev-libs/libcdio:=
		media-libs/libcddb
		dev-libs/libcdio-paranoia:=
	)
	cover? (
		media-libs/imlib2[jpeg,png]
	)
	dts? ( media-libs/libdca )
	ffmpeg? ( media-video/ffmpeg )
	flac? (
		media-libs/flac:=
		media-libs/libogg
	)
	libsamplerate? ( media-libs/libsamplerate )
	mp3? ( media-sound/mpg123 )
	musepack? ( media-sound/musepack-tools )
	nls? ( virtual/libintl )
	notify? (
		sys-apps/dbus
	)
	opus? ( media-libs/opusfile )
	pulseaudio? ( media-sound/pulseaudio )
	vorbis? ( media-libs/libvorbis )
	wavpack? ( media-sound/wavpack )
	dev-libs/libdispatch
"

RDEPEND="${DEPEND}"
BDEPEND="
	dev-util/intltool
	sys-devel/gettext
	sys-devel/clang
	sys-devel/llvm
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/deadbeef-use-ffmpeg-plugin-for-ape-by-default.patch"
	"${FILESDIR}/deadbeef-musl.patch" # 870187
)

src_prepare() {
	default

	drop_from_linguas() {
		sed "/${1}/d" -i "${S}/po/LINGUAS" || die
	}

	drop_and_stub() {
		rm -rf "${1}"
		mkdir "${1}"
		cat > "${1}/Makefile.in" <<-EOF
			all: nothing
			install: nothing
			nothing:
		EOF
	}

	plocale_for_each_disabled_locale drop_from_linguas || die

	eautopoint --force
	eautoreconf

	# Get rid of bundled gettext.
	drop_and_stub "${S}/intl"

	# Plugins that are undesired for whatever reason, candidates for unbundling and such.
	for i in adplug alac dumb ffap mms gme mono2stereo psf shn sid soundtouch wma; do
		drop_and_stub "${S}/plugins/${i}"
	done

	rm -rf "${S}/plugins/rg_scanner/ebur128"
}

src_configure () {
	if ! tc-is-clang; then
		AR=llvm-ar
		CC=${CHOST}-clang
		CXX=${CHOST}-clang++
		NM=llvm-nm
		RANLIB=llvm-ranlib

		strip-unsupported-flags
	fi

	export HOST_CC="$(tc-getBUILD_CC)"
	export HOST_CXX="$(tc-getBUILD_CXX)"
	tc-export CC CXX LD AR NM OBJDUMP RANLIB PKG_CONFIG

	local myconf=(
		"--disable-staticlink"
		"--disable-portable"
		"--disable-rpath"

		"--disable-libmad"
		"--disable-gtk2"
		"--disable-adplug"
		"--disable-coreaudio"
		"--disable-dumb"
		"--disable-alac"
		"--disable-ffap"
		"--disable-gme"
		"--disable-mms"
		"--disable-mono2stereo"
		"--disable-psf"
		"--disable-rgscanner"
		"--disable-shn"
		"--disable-sid"
		"--disable-sndfile"
		"--disable-soundtouch"
		"--disable-tta"
		"--disable-vfs-zip"
		"--disable-vtx"
		"--disable-wildmidi"
		"--disable-wma"

		"$(use_enable alsa)"
		"$(use_enable oss)"
		"$(use_enable pulseaudio pulse)"
		"$(use_enable mp3)"
		"$(use_enable mp3 libmpg123)"
		"$(use_enable nls)"
		"$(use_enable vorbis)"
		"$(use_enable threads)"
		"$(use_enable flac)"
		"$(use_enable supereq)"
		"$(use_enable cdda)"
		"$(use_enable cdda cdda-paranoia)"
		"$(use_enable aac)"
		"$(use_enable cover artwork)"
		"$(use_enable cover artwork-network)"
		"$(use_enable dts dca)"
		"$(use_enable ffmpeg)"
		"$(use_enable converter)"
		"$(use_enable musepack)"
		"$(use_enable notify)"
		"$(use_enable nullout)"
		"$(use_enable opus)"
		"$(use_enable pulseaudio pulse)"
		"$(use_enable sc68)"
		"$(use_enable shellexec)"
		"$(use_enable shellexec shellexecui)"
		"$(use_enable lastfm lfm)"
		"$(use_enable libsamplerate src)"
		"$(use_enable wavpack)"

		"--enable-gtk3"
		"--enable-vfs-curl"
		"--enable-shared"
		"--enable-m3u"
		"--enable-pltbrowser"
	)

	econf "${myconf[@]}"
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}
