# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools multilib eutils git-r3

DESCRIPTION="an Ultima 7 game engine that runs on modern operating systems"
HOMEPAGE="http://exult.sourceforge.net/"
EGIT_REPO_URI="https://github.com/exult/exult"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="+sdl2 timidity zlib"

DEPEND="
	>=media-libs/libpng-1.2.43-r2:0
	games-misc/exult-sound
	media-libs/libvorbis
	sdl2? ( media-libs/libsdl2[sound,video,X] )
	!sdl2? ( media-libs/libsdl[sound,video,X] )
	timidity? ( >=media-sound/timidity++-2 )
	zlib? ( sys-libs/zlib )
"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${P/_/}
DOCS=(
	AUTHORS ChangeLog FAQ NEWS README README.1ST
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--x-libraries="/usr/$(get_libdir)" \
		--disable-tools \
		--disable-opengl \
		--enable-mods \
		--with-desktopdir=/usr/share/applications \
		--with-icondir=/usr/share/pixmaps \
		--with-sdl=$(usex sdl2 sdl2 sdl12) \
		$(use_enable timidity timidity-midi) \
		$(use_enable zlib zip-support)
}

pkg_postinst() {
	elog "You *must* have the original Ultima7 The Black Gate and/or"
	elog "The Serpent Isle installed."
	elog "See documentation in /usr/share/doc/${PF} for information."
}
