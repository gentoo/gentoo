# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Check stable-1.0 branch for possible backports/new snapshots

inherit autotools multilib-minimal

SDL_SOUND_COMMIT="2076a4f555f95ed28dead5e28ee8e57cc74e425f"

MY_PN=${PN/sdl-/SDL_}
DESCRIPTION="Simple Direct Media Layer Mixer Library"
HOMEPAGE="https://github.com/icculus/SDL_sound"
SRC_URI="https://github.com/icculus/SDL_sound/archive/${SDL_SOUND_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${MY_PN}-${SDL_SOUND_COMMIT}

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ppc ppc64 sparc x86 ~x64-macos"
IUSE="flac mikmod modplug mp3 speex static-libs vorbis"

RDEPEND="
	>=media-libs/libsdl-1.2.15-r4[${MULTILIB_USEDEP}]
	flac? ( >=media-libs/flac-1.2.1-r5:=[${MULTILIB_USEDEP}] )
	mikmod? ( >=media-libs/libmikmod-3.2.0[${MULTILIB_USEDEP}] )
	modplug? ( >=media-libs/libmodplug-0.8.8.4-r1[${MULTILIB_USEDEP}] )
	mp3? ( media-sound/mpg123[${MULTILIB_USEDEP}] )
	speex? (
		>=media-libs/speex-1.2_rc1-r1[${MULTILIB_USEDEP}]
		>=media-libs/libogg-1.3.0[${MULTILIB_USEDEP}]
	)
	vorbis? ( >=media-libs/libvorbis-1.3.3-r1[${MULTILIB_USEDEP}] )
"

DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-1.0.3_p20220525-underlinking.patch
)

src_prepare() {
	default

	# Drop this once sdl-sound-1.0.3_p20220525-underlinking.patch merged
	eautoreconf
}

multilib_src_configure() {
	local myeconfargs=(
		# TODO: make this optional or switch unconditionally?
		--disable-sdl2
		--enable-aiff
		--enable-au
		--enable-midi
		--enable-raw
		--enable-shn
		--enable-voc
		--enable-wav
		$(use_enable flac)
		$(use_enable mikmod)
		$(use_enable modplug)
		$(use_enable mp3 mpg123)
		$(use_enable speex)
		$(use_enable static-libs static)
		$(use_enable vorbis ogg)
	)

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install() {
	emake DESTDIR="${D}" install
}

multilib_src_install_all() {
	einstalldocs

	if ! use static-libs ; then
		find "${ED}" -name '*.la' -delete || die
	fi
}
