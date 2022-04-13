# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="audio decoding, resampling and mixing library"
HOMEPAGE="https://github.com/realnc/SDL_audiolib"
if [[ "${PV}" == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/realnc/SDL_audiolib.git"
else
	# No official releases from upstream yet
	SRC_URI="https://dev.gentoo.org/~polynomial-c/dist/${P}.tar.xz"
	KEYWORDS="~amd64 ~x86"
fi
LICENSE="LGPL-3"
SLOT="0"

IUSE="fluidsynth libsamplerate modplug mpg123 musepack openmpt opus sndfile soxr vorbis"

RDEPEND="
	media-libs/libsdl2
	fluidsynth? ( media-sound/fluidsynth )
	libsamplerate? ( media-libs/libsamplerate )
	modplug? ( media-libs/libmodplug )
	mpg123? ( media-sound/mpg123 )
	musepack? ( media-sound/musepack-tools )
	openmpt? ( media-libs/libopenmpt )
	opus? ( media-libs/opusfile )
	sndfile? ( media-libs/libsndfile )
	soxr? ( media-libs/soxr )
	vorbis? ( media-libs/libvorbis )
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
"

src_configure() {
	local mycmakeargs=(
		-DUSE_DEC_ADLMIDI=OFF
		-DUSE_DEC_BASSMIDI=OFF
		-DUSE_DEC_FLUIDSYNTH="$(usex fluidsynth)"
		-DUSE_DEC_MODPLUG="$(usex modplug)"
		-DUSE_DEC_MPG123="$(usex mpg123)"
		-DUSE_DEC_MUSEPACK="$(usex musepack)"
		-DUSE_DEC_OPENMPT="$(usex openmpt)"
		-DUSE_DEC_LIBOPUSFILE="$(usex opus)"
		-DUSE_DEC_SNDFILE="$(usex sndfile)"
		-DUSE_DEC_LIBVORBIS="$(usex vorbis)"
		-DUSE_DEC_WILDMIDI=OFF
		-DUSE_DEC_XMP=OFF
		-DUSE_RESAMP_SOXR="$(usex soxr)"
		-DUSE_RESAMP_SRC="$(usex libsamplerate)"
	)
	cmake_src_configure
}
