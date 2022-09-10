# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/realnc/SDL_audiolib.git"
else
	SDLAUDIO_COMMIT="b66a66fedf8f65cacc5ce2ff8ed8d10649c6de31"
	SRC_URI="https://github.com/realnc/SDL_audiolib/archive/${SDLAUDIO_COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN/sdl/SDL}-${SDLAUDIO_COMMIT}"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Audio decoding, resampling and mixing library for SDL"
HOMEPAGE="https://github.com/realnc/SDL_audiolib/"

LICENSE="LGPL-3+ BSD-2 || ( MIT Unlicense )"
SLOT="0"
IUSE="doc flac fluidsynth libsamplerate modplug mpg123 musepack openmpt opus sndfile soxr vorbis wildmidi"

RDEPEND="
	dev-libs/libfmt:=
	media-libs/libsdl2[sound]
	flac? ( media-libs/flac:= )
	fluidsynth? ( media-sound/fluidsynth:= )
	libsamplerate? ( media-libs/libsamplerate )
	modplug? ( media-libs/libmodplug )
	mpg123? ( media-sound/mpg123 )
	musepack? ( media-sound/musepack-tools )
	openmpt? ( media-libs/libopenmpt )
	opus? ( media-libs/opusfile )
	sndfile? ( media-libs/libsndfile )
	soxr? ( media-libs/soxr )
	vorbis? ( media-libs/libvorbis )
	wildmidi? ( media-sound/wildmidi )"
DEPEND="${RDEPEND}"
BDEPEND="doc? ( app-doc/doxygen )"

src_configure() {
	local mycmakeargs=(
		-DUSE_DEC_ADLMIDI=OFF
		-DUSE_DEC_BASSMIDI=OFF
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
		-DUSE_DEC_XMP=OFF
		-DUSE_RESAMP_SOXR=$(usex soxr)
		-DUSE_RESAMP_SRC=$(usex libsamplerate)
		-DWITH_SYSTEM_FMTLIB=ON
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
