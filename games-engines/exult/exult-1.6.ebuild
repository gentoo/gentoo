# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="an Ultima 7 game engine that runs on modern operating systems"
HOMEPAGE="http://exult.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/${PN}/exult-all-versions/${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="alsa fluidsynth opengl +sdl2 timidity tools"

DEPEND="
	games-misc/exult-sound
	>=media-libs/libpng-1.6:0=
	media-libs/libvorbis
	sys-libs/zlib
	alsa? ( media-libs/alsa-lib )
	fluidsynth? ( media-sound/fluidsynth )
	opengl? ( virtual/opengl )
	sdl2? ( media-libs/libsdl2[sound,video,X] )
	!sdl2? ( media-libs/libsdl[sound,video,X] )
	timidity? ( >=media-sound/timidity++-2 )
"
RDEPEND="${DEPEND}"

DOCS=(
	AUTHORS ChangeLog FAQ NEWS README README.1ST
)

src_configure() {
	econf \
		--enable-mods \
		--enable-zip-support \
		--with-desktopdir=/usr/share/applications \
		--with-icondir=/usr/share/pixmaps \
		--with-sdl=$(usex sdl2 sdl2 sdl12) \
		$(use_enable alsa) \
		$(use_enable fluidsynth) \
		$(use_enable opengl) \
		$(use_enable timidity timidity-midi) \
		$(use_enable tools)
}

pkg_postinst() {
	elog "You *must* have the original Ultima7 The Black Gate and/or"
	elog "The Serpent Isle installed."
	elog "See documentation in /usr/share/doc/${PF} for information."
}
