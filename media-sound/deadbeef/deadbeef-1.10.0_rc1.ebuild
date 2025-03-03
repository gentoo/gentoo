# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools xdg flag-o-matic toolchain-funcs plocale

MY_PV=${PV/_/-}
SHORT_PV=$(ver_cut 1-2)
DESCRIPTION="DeaDBeeF is a modular audio player similar to foobar2000"
HOMEPAGE="https://deadbeef.sourceforge.io/"
SRC_URI="https://sourceforge.net/projects/${PN}/files/travis/linux/${SHORT_PV}/deadbeef-${MY_PV}.tar.bz2/download
	-> ${P}.tar.bz2"
S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="
	GPL-2
	LGPL-2.1
	MIT
	wavpack? ( BSD )
"
SLOT="0"
if [[ ${PV} != *beta* && ${PV} != *rc* ]]; then
	KEYWORDS="~amd64 ~riscv ~x86"
fi
IUSE="aac alsa cdda converter cover dts ffmpeg flac +hotkeys lastfm libretro libsamplerate mp3 musepack nls notify +nullout opus oss pulseaudio pipewire sc68 shellexec +supereq vorbis wavpack zip"

REQUIRED_USE="
	|| ( alsa oss pulseaudio pipewire nullout )
"

DEPEND="
	>=app-accessibility/at-spi2-core-2.46.0
	dev-libs/glib:2
	dev-libs/jansson:=
	dev-libs/libdispatch
	media-libs/harfbuzz:=
	net-misc/curl
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/pango
	aac? ( media-libs/faad2 )
	alsa? ( media-libs/alsa-lib )
	cdda? (
		dev-libs/libcdio:=
		media-libs/libcddb
		media-sound/cdparanoia
	)
	cover? ( media-libs/imlib2[jpeg,png] )
	dts? ( media-libs/libdca )
	ffmpeg? ( media-video/ffmpeg:= )
	flac? (
		media-libs/flac:=
		media-libs/libogg
	)
	libsamplerate? ( media-libs/libsamplerate )
	mp3? ( media-sound/mpg123-base )
	musepack? ( media-sound/musepack-tools )
	nls? ( virtual/libintl )
	notify? ( sys-apps/dbus )
	opus? ( media-libs/opusfile )
	pulseaudio? ( media-libs/libpulse )
	pipewire? ( media-video/pipewire:= )
	vorbis? ( media-libs/libvorbis )
	wavpack? ( media-sound/wavpack )
	zip? ( sys-libs/zlib )
"

RDEPEND="${DEPEND}"
BDEPEND="
	dev-util/intltool
	llvm-core/clang
	>=sys-devel/gettext-0.21
	llvm-core/llvm
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.10.0_beta1-drop-Werror.patch
	"${FILESDIR}"/${PN}-1.9.6-update-gettext.patch
)

src_prepare() {
	default

	drop_from_linguas() {
		sed "/${1}/d" -i "${S}/po/LINGUAS" || die
	}

	drop_and_stub() {
		einfo drop_and_stub "${1}"
		rm -r "${1}" || die
		mkdir "${1}" || die
		cat > "${1}/Makefile.in" <<-EOF || die
			all: nothing
			install: nothing
			nothing:
		EOF
	}

	plocale_for_each_disabled_locale drop_from_linguas || die

	eautopoint --force
	eautoreconf

	# Get rid of bundled gettext. (Avoid build failures with musl)
	drop_and_stub "${S}/intl"

	# Plugins that are undesired for whatever reason, candidates for unbundling and such.
	for i in adplug alac dumb ffap mms gme mono2stereo psf shn sid soundtouch wma; do
		drop_and_stub "${S}/plugins/${i}"
	done
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

		"--disable-adplug"
		"--disable-alac"
		"--disable-coreaudio"
		"--disable-dumb"
		"--disable-ffap"
		"--disable-gme"
		"--disable-gtk2"
		"--disable-libmad"
		"--disable-mms"
		"--disable-mono2stereo"
		"--disable-psf"
		"--disable-shn"
		"--disable-sid"
		"--disable-sndfile"
		"--disable-soundtouch"
		"--disable-tta"
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
		"$(use_enable pipewire)"
		"$(use_enable sc68)"
		"$(use_enable shellexec)"
		"$(use_enable shellexec shellexecui)"
		"$(use_enable lastfm lfm)"
		"$(use_enable libretro)"
		"$(use_enable libsamplerate src)"
		"$(use_enable wavpack)"
		"$(use_enable zip vfs-zip)"

		"--enable-gtk3"
		"--enable-m3u"
		"--enable-medialib"
		"--enable-pltbrowser"
		"--enable-rgscanner"
		"--enable-shared"
		"--enable-vfs-curl"
	)

	econf "${myconf[@]}"
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die

	# if compressed, help doesn't work
	docompress -x /usr/share/doc/${PF}
}
