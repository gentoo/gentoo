# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_COMMIT=68764f35899e133b402336843c046d75136eaf08
inherit cmake-multilib

DESCRIPTION="Simple Direct Media Layer Mixer Library"
HOMEPAGE="https://github.com/libsdl-org/SDL_mixer"
SRC_URI="https://codeload.github.com/libsdl-org/SDL_mixer/tar.gz/${MY_COMMIT} -> ${P}.tar.gz"

S="${WORKDIR}/SDL_mixer-${MY_COMMIT}"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64"
IUSE="drlibs flac fluidsynth gme midi mod modplug mp3 opus playtools"
IUSE+=" sndfile stb timidity tremor vorbis +wav wavpack xmp"
REQUIRED_USE="
	drlibs? ( || ( flac mp3 ) )
	midi? ( || ( timidity fluidsynth ) )
	timidity? ( midi )
	fluidsynth? ( midi )

	vorbis? ( ?? ( stb tremor ) )
	stb? ( vorbis )
	tremor? ( vorbis )
"

RDEPEND="
	media-libs/libsdl3[${MULTILIB_USEDEP}]
	!drlibs? (
		flac? ( media-libs/flac:=[${MULTILIB_USEDEP}] )
		mp3? ( media-sound/mpg123-base[${MULTILIB_USEDEP}] )
	)
	gme? ( media-libs/game-music-emu[${MULTILIB_USEDEP}] )
	midi? (
		fluidsynth? ( media-sound/fluidsynth:=[${MULTILIB_USEDEP}] )
		timidity? ( media-sound/timidity++ )
	)
	mod? ( media-libs/libxmp[${MULTILIB_USEDEP}] )

	opus? ( media-libs/opusfile[${MULTILIB_USEDEP}] )
	vorbis? (
		tremor? ( media-libs/tremor[${MULTILIB_USEDEP}] )
		!stb? ( !tremor? ( media-libs/libvorbis[${MULTILIB_USEDEP}] ) )
	)
	gme? ( media-libs/game-music-emu[${MULTILIB_USEDEP}] )
	wavpack? ( media-sound/wavpack[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}"

multilib_src_configure() {
	local mycmakeargs=(
		-DSDLMIXER_DEPS_SHARED=no # aka, no dlopen() (bug #950965)
		-DSDLMIXER_FLAC=$(usex flac)
		-DSDLMIXER_FLAC_LIBFLAC=$(usex flac $(usex drlibs no yes) no)
		-DSDLMIXER_FLAC_DRFLAC=$(usex drlibs)
		-DSDLMIXER_GME=$(usex gme)
		-DSDLMIXER_GME_SHARED=no
		-DSDLMIXER_INSTALL_MAN=yes
		-DSDLMIXER_MIDI=$(usex midi)
		-DSDLMIXER_MIDI_FLUIDSYNTH=$(usex fluidsynth)
		-DSDLMIXER_MIDI_FLUIDSYNTH_SHARED=no
		-DSDLMIXER_MIDI_TIMIDITY=$(usex timidity)
		-DSDLMIXER_MOD=$(usex mod)
		-DSDLMIXER_MOD_XMP=$(usex mod)
		-DSDLMIXER_MOD_XMP_LITE=no
		-DSDLMIXER_MOD_XMP_SHARED=no
		-DSDLMIXER_MP3=$(usex mp3)
		-DSDLMIXER_MP3_DRMP3=$(usex drlibs)
		-DSDLMIXER_MP3_MPG123=$(usex mp3 $(usex drlibs no yes) no)
		-DSDLMIXER_OPUS=$(usex opus)
		-DSDLMIXER_OPUS_SHARED=no
		-DSDLMIXER_SAMPLES=$(usex playtools)
		-DSDLMIXER_SAMPLES_INSTALL=$(usex playtools)
		-DSDLMIXER_SNDFILE=$(usex sndfile)
		-DSDLMIXER_SNDFILE_SHARED=no
		-DSDLMIXER_STRICT=yes # Fail when a dependency could not be found
		-DSDLMIXER_VENDORED=no # Use vendored third-party libraries
		-DSDLMIXER_VORBIS=$(usex vorbis $(usex stb STB $(usex tremor TREMOR VORBISFILE) ) no )
		-DSDLMIXER_WAVE=$(usex wav)
		-DSDLMIXER_WAVPACK=$(usex wavpack)
		-DSDLMIXER_WAVPACK_DSD=$(usex wavpack) # seems to be default-enabled in wavpack
	)

	cmake_src_configure
}

multilib_src_install_all() {
	dodoc {CHANGES,README}.txt
	rm -r "${ED}"/usr/share/licenses || die
}

pkg_postinst() {
	# bug #412035
	if use midi && use fluidsynth; then
		ewarn "FluidSynth support requires you to set the SDL_SOUNDFONTS"
		ewarn "environment variable to the location of a SoundFont file"
		ewarn "unless the game or application happens to do this for you."
		if use timidity; then
			ewarn "Failing to do so will result in Timidity being used instead."
		else
			ewarn "Failing to do so will result in silence."
		fi
	fi
}
