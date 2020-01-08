# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools multilib-minimal

MY_P="${P/sdl-/SDL_}"

DESCRIPTION="A library for handling the decoding of various sound file formats"
HOMEPAGE="https://icculus.org/SDL_sound/"
SRC_URI="https://icculus.org/${MY_PN}/downloads/${MY_P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ppc ppc64 sparc x86 ~x64-macos"
IUSE="flac mikmod modplug mp3 mpeg physfs speex static-libs vorbis"

RDEPEND="
	>=media-libs/libsdl-1.2.15-r4[${MULTILIB_USEDEP}]
	flac? ( >=media-libs/flac-1.2.1-r5[${MULTILIB_USEDEP}] )
	mikmod? ( >=media-libs/libmikmod-3.2.0[${MULTILIB_USEDEP}] )
	modplug? ( >=media-libs/libmodplug-0.8.8.4-r1[${MULTILIB_USEDEP}] )
	mpeg? ( >=media-libs/smpeg-0.4.4-r10[${MULTILIB_USEDEP}] )
	physfs? ( >=dev-games/physfs-3.0.1[${MULTILIB_USEDEP}] )
	speex? (
		>=media-libs/speex-1.2_rc1-r1[${MULTILIB_USEDEP}]
		>=media-libs/libogg-1.3.0[${MULTILIB_USEDEP}]
	)
	vorbis? ( >=media-libs/libvorbis-1.3.3-r1[${MULTILIB_USEDEP}] )
"

DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/"${P}"-automake-1.13.patch
	"${FILESDIR}"/"${P}"-physfs-3.0.1.patch
	"${FILESDIR}"/"${P}"-underlinking.patch
)

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default

	mv configure.in configure.ac || die
	eautoreconf
}

multilib_src_configure() {
	local myeconfargs=(
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
		$(use_enable mp3 mpglib)
		$(use_enable mpeg smpeg)
		$(use_enable physfs)
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
		find "${D}" -name '*.la' -delete || die
	fi
}
