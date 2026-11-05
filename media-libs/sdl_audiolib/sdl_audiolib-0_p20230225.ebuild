# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

SDLAL_COMMIT=b2df2dfeddc692caa01fd1e1769f59b285912b87

DESCRIPTION="Audio decoding, resampling and mixing library for SDL"
HOMEPAGE="https://github.com/realnc/SDL_audiolib/"
SRC_URI="
	https://github.com/realnc/SDL_audiolib/archive/${SDLAL_COMMIT}.tar.gz
		-> ${P}.tar.gz
"
S=${WORKDIR}/${PN/sdl/SDL}-${SDLAL_COMMIT}

LICENSE="LGPL-3+ BSD-2 || ( MIT Unlicense )"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE="
	doc flac fluidsynth libsamplerate modplug mpg123 musepack openmpt
	opus sndfile soxr vorbis wildmidi
"

RDEPEND="
	dev-libs/libfmt:=
	media-libs/libsdl2[sound]
	flac? ( media-libs/flac:= )
	fluidsynth? ( media-sound/fluidsynth:= )
	libsamplerate? ( media-libs/libsamplerate )
	modplug? ( media-libs/libmodplug )
	mpg123? ( media-sound/mpg123-base )
	musepack? ( media-sound/musepack-tools )
	openmpt? ( media-libs/libopenmpt )
	opus? ( media-libs/opusfile[float] )
	sndfile? ( media-libs/libsndfile )
	soxr? ( media-libs/soxr )
	vorbis? ( media-libs/libvorbis )
	wildmidi? ( media-sound/wildmidi )
"
DEPEND="${RDEPEND}"
BDEPEND="
	doc? ( app-text/doxygen )
"

PATCHES=(
	"${FILESDIR}"/${PN}-0_p20230225-cmake4.patch
	"${FILESDIR}"/${PN}-0_p20230225-libfmt12.2.patch
)

src_configure() {
	local mycmakeargs=(
		-DUSE_DEC_ADLMIDI=no
		-DUSE_DEC_BASSMIDI=no
		-DUSE_DEC_FLAC=$(usex flac)
		-DUSE_DEC_FLUIDSYNTH=$(usex fluidsynth)
		-DUSE_DEC_LIBOPUSFILE=$(usex opus)
		-DUSE_DEC_LIBVORBIS=$(usex vorbis)
		-DUSE_DEC_MODPLUG=$(usex modplug)
		-DUSE_DEC_MPG123=$(usex mpg123)
		-DUSE_DEC_MUSEPACK=$(usex musepack)
		-DUSE_DEC_OPENMPT=$(usex openmpt)
		-DUSE_DEC_SNDFILE=$(usex sndfile)
		-DUSE_DEC_WILDMIDI=$(usex wildmidi)
		-DUSE_DEC_XMP=no
		-DUSE_RESAMP_SOXR=$(usex soxr)
		-DUSE_RESAMP_SRC=$(usex libsamplerate)
		-DWITH_SYSTEM_FMTLIB=yes
	)

	cmake_src_configure
}

src_compile() {
	cmake_src_compile

	use !doc || doxygen "${BUILD_DIR}"/Doxyfile || die
}

src_install() {
	cmake_src_install

	use doc && dodoc -r "${BUILD_DIR}"/doc/html
}
