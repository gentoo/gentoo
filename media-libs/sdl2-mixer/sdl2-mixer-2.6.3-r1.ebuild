# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="SDL2_mixer-${PV}"
inherit multilib-minimal

DESCRIPTION="Simple Direct Media Layer Mixer Library"
HOMEPAGE="https://github.com/libsdl-org/SDL_mixer"
SRC_URI="https://www.libsdl.org/projects/SDL_mixer/release/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 ~loong ppc ppc64 ~riscv sparc x86"
IUSE="flac fluidsynth midi mod mp3 opus playtools static-libs timidity tremor vorbis +wav"
REQUIRED_USE="
	midi? ( || ( timidity fluidsynth ) )
	timidity? ( midi )
	fluidsynth? ( midi )
	tremor? ( vorbis )
"

RDEPEND="
	>=media-libs/libsdl2-2.0.7[${MULTILIB_USEDEP}]
	flac? ( >=media-libs/flac-1.2.1-r5:=[${MULTILIB_USEDEP}] )
	midi? (
		fluidsynth? ( >=media-sound/fluidsynth-1.1.6-r1:=[${MULTILIB_USEDEP}] )
		timidity? ( media-sound/timidity++ )
	)
	mod? ( >=media-libs/libmodplug-0.8.8.4-r1[${MULTILIB_USEDEP}] )
	mp3? ( media-sound/mpg123[${MULTILIB_USEDEP}] )
	opus? ( >=media-libs/opusfile-0.2 )
	vorbis? (
		tremor? ( >=media-libs/tremor-0_pre20130223[${MULTILIB_USEDEP}] )
		!tremor? ( >=media-libs/libvorbis-1.3.3-r1[${MULTILIB_USEDEP}] )
	)
"
DEPEND="${RDEPEND}"

src_prepare() {
	default

	multilib_copy_sources
}

multilib_src_configure() {
	local myeconfargs=(
		$(use_enable static-libs static)
		--disable-sdltest
		--enable-music-cmd
		$(use_enable wav music-wave)
		$(use_enable mod music-mod)
		$(use_enable mod music-mod-modplug)
		--disable-music-mod-modplug-shared
		$(use_enable midi music-midi)
		$(use_enable timidity music-midi-timidity)
		$(use_enable fluidsynth music-midi-fluidsynth)
		--disable-music-midi-fluidsynth-shared
		$(use_enable vorbis music-ogg)
		--disable-music-ogg-stb
		$(usex vorbis \
			$(use_enable !tremor music-ogg-vorbis) \
			--disable-music-ogg-vorbis)
		--disable-music-ogg-vorbis-shared
		$(use_enable tremor music-ogg-tremor)
		--disable-music-ogg-tremor-shared
		$(use_enable flac music-flac)
		$(use_enable flac music-flac-libflac)
		--disable-music-flac-libflac-shared
		$(use_enable mp3 music-mp3)
		$(use_enable mp3 music-mp3-mpg123)
		--disable-music-mp3-mpg123-shared
		$(use_enable opus music-opus)
		--disable-music-opus-shared
	)

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install() {
	emake DESTDIR="${D}" install
	if multilib_is_native_abi && use playtools ; then
		emake DESTDIR="${D}" install-bin
	fi
}

multilib_src_install_all() {
	dodoc {CHANGES,README}.txt
	find "${D}" -name '*.la' -delete || die
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
