# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="SDL2_mixer-${PV}"
inherit cmake-multilib

DESCRIPTION="Simple Direct Media Layer Mixer Library"
HOMEPAGE="https://github.com/libsdl-org/SDL_mixer"
SRC_URI="https://www.libsdl.org/projects/SDL_mixer/release/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64"
IUSE="flac fluidsynth gme midi mod modplug mp3 opus playtools stb timidity tremor vorbis +wav wavpack xmp"
REQUIRED_USE="
	midi? ( || ( timidity fluidsynth ) )
	timidity? ( midi )
	fluidsynth? ( midi )

	vorbis? ( ?? ( stb tremor ) )
	stb? ( vorbis )
	tremor? ( vorbis )

	mod? ( || ( modplug xmp ) )
	modplug? ( mod )
	xmp? ( mod )
"

RDEPEND="
	media-libs/libsdl2[${MULTILIB_USEDEP}]
	flac? ( media-libs/flac:=[${MULTILIB_USEDEP}] )
	midi? (
		fluidsynth? ( media-sound/fluidsynth:=[${MULTILIB_USEDEP}] )
		timidity? ( media-sound/timidity++ )
	)
	mod? (
		modplug? ( media-libs/libmodplug[${MULTILIB_USEDEP}] )
		xmp? ( media-libs/libxmp )
	)
	mp3? ( media-sound/mpg123[${MULTILIB_USEDEP}] )
	opus? ( media-libs/opusfile )
	vorbis? (
		stb? ( dev-libs/stb )
		tremor? ( media-libs/tremor[${MULTILIB_USEDEP}] )
		!stb? ( !tremor? ( media-libs/libvorbis[${MULTILIB_USEDEP}] ) )
	)
	gme? ( media-libs/game-music-emu[${MULTILIB_USEDEP}] )
	wavpack? ( media-sound/wavpack[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}"

multilib_src_configure() {
	local mycmakeargs=(
		-DSDL2MIXER_CMD=yes
		-DSDL2MIXER_WAVE=$(usex wav)
		-DSDL2MIXER_MOD=$(usex mod)
		-DSDL2MIXER_MOD_MODPLUG=$(usex modplug)
		-DSDL2MIXER_MOD_XMP=$(usex xmp)
		-DSDL2MIXER_MIDI=$(usex midi)
		-DSDL2MIXER_MIDI_TIMIDITY=$(usex timidity)
		-DSDL2MIXER_MIDI_FLUIDSYNTH=$(usex fluidsynth)
		-DSDL2MIXER_VORBIS=$(usex vorbis $(usex stb STB $(usex tremor TREMOR VORBISFILE) ) no )
		-DSDL2MIXER_FLAC=$(usex flac)
		-DSDL2MIXER_FLAC_LIBFLAC=$(usex flac)
		-DSDL2MIXER_MP3=$(usex mp3)
		-DSDL2MIXER_MP3_MPG123=$(usex mp3)
		-DSDL2MIXER_OPUS=$(usex opus)
		-DSDL2MIXER_GME=$(usex gme)
		-DSDL2MIXER_WAVPACK=$(usex wavpack)
		-DSDL2MIXER_SAMPLES=$(usex playtools)
		-DSDL2MIXER_SAMPLES_INSTALL=$(usex playtools)
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
