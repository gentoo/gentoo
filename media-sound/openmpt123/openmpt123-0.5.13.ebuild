# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib

MY_P="libopenmpt-${PV}+release.autotools"
DESCRIPTION="libopenmpt-based command line player for tracked music files (modules)"
HOMEPAGE="https://lib.openmpt.org/libopenmpt/"
SRC_URI="https://lib.openmpt.org/files/libopenmpt/src/${MY_P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="flac portaudio pulseaudio sdl sndfile"

RDEPEND="
	~media-libs/libopenmpt-${PV}
	flac? ( media-libs/flac )
	pulseaudio? ( media-sound/pulseaudio )
	sdl? ( >=media-libs/libsdl2-2.0.4 )
	sndfile? ( media-libs/libsndfile )
"

DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default

	# Normally libopenmpt is built alongside openmpt123. Avoid the
	# internal dependency and link it externally.
	rm -r libopenmpt/ || die
	sed -i \
		-e "s:libopenmpt/libopenmpt\.pc::g" \
		configure || die
	sed -i \
		-e "/_${PN}_DEPENDENCIES/s:libopenmpt\.la::g" \
		-e "/_${PN}_LDADD/s:libopenmpt\.la:-lopenmpt:g" \
		Makefile.in || die
}

src_configure() {
	# A lot of these optional dependencies relate to libopenmpt, which
	# we package separately, so we disable them here.
	econf \
		--disable-static \
		--enable-openmpt123 \
		--disable-examples \
		--disable-tests \
		--disable-doxygen-doc \
		--without-zlib \
		--without-mpg123 \
		--without-ogg \
		--without-vorbis \
		--without-vorbisfile \
		$(use_with pulseaudio) \
		$(use_with portaudio) \
		--without-portaudiocpp \
		$(use_with sdl sdl2) \
		$(use_with sndfile) \
		$(use_with flac)
}

src_compile() {
	emake "bin/${PN}$(get_exeext)"
}

src_install() {
	dobin "bin/${PN}$(get_exeext)"
}
