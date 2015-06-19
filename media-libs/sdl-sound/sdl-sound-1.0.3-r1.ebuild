# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/sdl-sound/sdl-sound-1.0.3-r1.ebuild,v 1.8 2015/04/28 02:16:15 jmorgan Exp $

EAPI=5
inherit autotools eutils multilib-minimal

MY_P="${P/sdl-/SDL_}"
DESCRIPTION="A library that handles the decoding of sound file formats"
HOMEPAGE="http://icculus.org/SDL_sound/"
SRC_URI="http://icculus.org/SDL_sound/downloads/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ppc ppc64 sparc x86 ~x86-fbsd ~x64-macos"
IUSE="flac mikmod modplug mp3 mpeg physfs speex static-libs vorbis"

RDEPEND="
	abi_x86_32? (
		!app-emulation/emul-linux-x86-sdl[-abi_x86_32(-)]
		!<=app-emulation/emul-linux-x86-sdl-20140406
	)
	>=media-libs/libsdl-1.2.15-r4[${MULTILIB_USEDEP}]
	flac? ( >=media-libs/flac-1.2.1-r5[${MULTILIB_USEDEP}] )
	mikmod? ( >=media-libs/libmikmod-3.2.0[${MULTILIB_USEDEP}] )
	modplug? ( >=media-libs/libmodplug-0.8.8.4-r1[${MULTILIB_USEDEP}] )
	vorbis? ( >=media-libs/libvorbis-1.3.3-r1[${MULTILIB_USEDEP}] )
	speex? ( >=media-libs/speex-1.2_rc1-r1[${MULTILIB_USEDEP}] >=media-libs/libogg-1.3.0[${MULTILIB_USEDEP}] )
	physfs? ( >=dev-games/physfs-2.0.3-r1[${MULTILIB_USEDEP}] )
	mpeg? ( >=media-libs/smpeg-0.4.4-r10[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}"/${P}-{underlinking,automake-1.13}.patch
	mv configure.in configure.ac || die
	eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf \
		--disable-dependency-tracking \
		--enable-midi \
		$(use_enable mpeg smpeg) \
		$(use_enable mp3 mpglib) \
		$(use_enable flac) \
		$(use_enable speex) \
		$(use_enable static-libs static) \
		$(use_enable mikmod) \
		$(use_enable modplug) \
		$(use_enable physfs) \
		$(use_enable vorbis ogg)
}

multilib_src_install() {
	emake DESTDIR="${D}" install
}

multilib_src_install_all() {
	dodoc CHANGELOG CREDITS README TODO
	if ! use static-libs ; then
		find "${D}" -type f -name '*.la' -exec rm {} + \
			|| die "la removal failed"
	fi
}
