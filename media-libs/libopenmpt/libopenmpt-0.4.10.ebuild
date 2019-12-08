# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-minimal

MY_P="libopenmpt-${PV}+release.autotools"
DESCRIPTION="Library to decode tracked music files (modules)"
HOMEPAGE="https://lib.openmpt.org/libopenmpt/"
SRC_URI="https://lib.openmpt.org/files/libopenmpt/src/${MY_P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="examples mp3 ogg static-libs test vorbis zlib"
RESTRICT="!test? ( test )"

RDEPEND="
	mp3? ( media-sound/mpg123[${MULTILIB_USEDEP}] )
	ogg? ( media-libs/libogg[${MULTILIB_USEDEP}] )
	vorbis? ( media-libs/libvorbis[${MULTILIB_USEDEP}] )
	zlib? ( sys-libs/zlib[${MULTILIB_USEDEP}] )
"

DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/${MY_P}"
ECONF_SOURCE="${S}"

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
		--without-sdl \
		--without-sndfile \
		--without-flac
}

multilib_src_install_all() {
	rm \
		"${ED}"/usr/*/*.la \
		"${ED}"/usr/share/doc/${P}/LICENSE || die

	if ! use examples; then
		rm -r "${ED}"/usr/share/doc/${P}/examples || die
	fi
}
