# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils multilib-minimal

MY_P=SDL2_mixer-${PV}
DESCRIPTION="Simple Direct Media Layer Mixer Library"
HOMEPAGE="http://www.libsdl.org/projects/SDL_mixer/"
SRC_URI="http://www.libsdl.org/projects/SDL_mixer/release/${MY_P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="flac fluidsynth mad midi mikmod mod modplug mp3 playtools smpeg static-libs timidity tremor vorbis +wav"
REQUIRED_USE="
	midi? ( || ( timidity fluidsynth ) )
	timidity? ( midi )
	fluidsynth? ( midi )
	mp3? ( || ( smpeg mad ) )
	smpeg? ( mp3 )
	mad? ( mp3 )
	mod? ( || ( mikmod modplug ) )
	mikmod? ( mod )
	modplug? ( mod )
	tremor? ( vorbis )
	"

RDEPEND=">=media-libs/libsdl2-2.0.1-r1[${MULTILIB_USEDEP}]
	flac? ( >=media-libs/flac-1.2.1-r5[${MULTILIB_USEDEP}] )
	midi? (
		fluidsynth? ( >=media-sound/fluidsynth-1.1.6-r1[${MULTILIB_USEDEP}] )
		timidity? ( media-sound/timidity++ )
	)
	mp3? (
		mad? ( >=media-libs/libmad-0.15.1b-r8[${MULTILIB_USEDEP}] )
		smpeg? ( >=media-libs/smpeg2-2.0.0-r1[${MULTILIB_USEDEP}] )
	)
	mod? (
		modplug? ( >=media-libs/libmodplug-0.8.8.4-r1[${MULTILIB_USEDEP}] )
		mikmod? ( >=media-libs/libmikmod-3.3.6-r1[${MULTILIB_USEDEP}] )
	)
	vorbis? (
		tremor? ( >=media-libs/tremor-0_pre20130223[${MULTILIB_USEDEP}] )
		!tremor? (
			>=media-libs/libvorbis-1.3.3-r1[${MULTILIB_USEDEP}]
			>=media-libs/libogg-1.3.0[${MULTILIB_USEDEP}] )
	)"
DEPEND=${RDEPEND}

S=${WORKDIR}/${MY_P}

src_prepare() {
	# upstream patch to fix building with both smpeg and mad mp3 support (bug #570804)
	epatch "${FILESDIR}"/${P}-mp3.patch
	sed -i -e 's/configure.in/configure.ac/' Makefile.in || die
	mv configure.{in,ac} || die
	rm acinclude/l*.m4 || die
	AT_M4DIR=acinclude eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE=${S} \
	econf \
		$(use_enable static-libs static) \
		--disable-sdltest \
		--enable-music-cmd \
		$(use_enable wav music-wave) \
		$(use_enable mod music-mod) \
		$(use_enable modplug music-mod-modplug) \
		--disable-music-mod-modplug-shared \
		$(use_enable mikmod music-mod-mikmod) \
		--disable-music-mod-mikmod-shared \
		$(use_enable midi music-midi) \
		$(use_enable timidity music-midi-timidity) \
		$(use_enable fluidsynth music-midi-fluidsynth) \
		--disable-music-midi-fluidsynth-shared \
		$(use_enable vorbis music-ogg) \
		$(use_enable tremor music-ogg-tremor) \
		--disable-music-ogg-shared \
		$(use_enable flac music-flac) \
		--disable-music-flac-shared \
		$(use_enable mp3 music-mp3) \
		$(use_enable smpeg music-mp3-smpeg) \
		--disable-music-mp3-smpeg-shared \
		--disable-smpegtest \
		$(use_enable mad music-mp3-mad-gpl) \
		LIBMIKMOD_CONFIG=${EPREFIX}/usr/bin/${CHOST}-libmikmod-config
}

multilib_src_install() {
	emake DESTDIR="${D}" install
	if multilib_is_native_abi && use playtools; then
		emake DESTDIR="${D}" install-bin
	fi
}

multilib_src_install_all() {
	dodoc {CHANGES,README}.txt
	prune_libtool_files
}

pkg_postinst() {
	# bug 412035
	# https://bugs.gentoo.org/show_bug.cgi?id=412035
	if use midi ; then
		if use fluidsynth; then
			ewarn "FluidSynth support requires you to set the SDL_SOUNDFONTS"
			ewarn "environment variable to the location of a SoundFont file"
			ewarn "unless the game or application happens to do this for you."

			if use timidity; then
				ewarn "Failing to do so will result in Timidity being used instead."
			else
				ewarn "Failing to do so will result in silence."
			fi
		fi
	fi
}
