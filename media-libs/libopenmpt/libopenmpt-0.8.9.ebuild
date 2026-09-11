# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit libtool multilib-minimal

MY_P="libopenmpt-${PV}+release.autotools"
DESCRIPTION="Library to decode tracked music files (modules)"
HOMEPAGE="https://lib.openmpt.org/libopenmpt/"
SRC_URI="https://lib.openmpt.org/files/libopenmpt/src/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="examples mp3 ogg static-libs test vorbis zlib"
RESTRICT="!test? ( test )"

RDEPEND="
	mp3? ( media-sound/mpg123[${MULTILIB_USEDEP}] )
	ogg? ( media-libs/libogg[${MULTILIB_USEDEP}] )
	vorbis? ( media-libs/libvorbis[${MULTILIB_USEDEP}] )
	zlib? ( virtual/zlib:=[${MULTILIB_USEDEP}] )
"

DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

ECONF_SOURCE="${S}"

src_prepare() {
	default
	elibtoolize
}

multilib_src_configure() {
	# A lot of these optional dependencies relate to openmpt123, which
	# we package separately, so we disable them here.
	econf \
		$(use_enable static-libs static) \
		--disable-openmpt123 \
		--disable-examples \
		$(use_enable test tests) \
		--disable-doxygen-doc \
		$(use_with zlib) \
		$(use_with mp3 mpg123) \
		$(use_with ogg) \
		$(use_with vorbis) \
		$(use_with vorbis vorbisfile) \
		--without-pulseaudio \
		--without-portaudio \
		--without-portaudiocpp \
		--without-sdl2 \
		--without-sndfile \
		--without-flac
}

multilib_src_install_all() {
	rm \
		"${ED}"/usr/*/*.la \
		"${ED}"/usr/share/doc/${PF}/LICENSE || die

	if ! use examples; then
		rm -r "${ED}"/usr/share/doc/${PF}/examples || die
	fi
}
