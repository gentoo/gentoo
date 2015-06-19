# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-engines/exult/exult-9999.ebuild,v 1.1 2015/01/09 01:52:57 mr_bones_ Exp $

EAPI=5
ESVN_REPO_URI="https://svn.code.sf.net/p/exult/code/exult/trunk/"
inherit autotools multilib eutils subversion games

DESCRIPTION="an Ultima 7 game engine that runs on modern operating systems"
HOMEPAGE="http://exult.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="timidity zlib"

DEPEND=">=media-libs/libpng-1.2.43-r2:0
	games-misc/exult-sound
	media-libs/libsdl[sound,video,X]
	timidity? ( >=media-sound/timidity++-2 )
	zlib? ( sys-libs/zlib )"
RDEPEND=${DEPEND}

S=${WORKDIR}/${P/_/}

src_unpack() {
	subversion_src_unpack
}

src_prepare() {
	subversion_src_prepare
	eautoreconf
}

src_configure() {
	egamesconf \
		--x-libraries="/usr/$(get_libdir)" \
		--disable-tools \
		--disable-opengl \
		--enable-mods \
		--with-desktopdir=/usr/share/applications \
		--with-icondir=/usr/share/pixmaps \
		$(use_enable timidity timidity-midi) \
		$(use_enable zlib zip-support)
}

src_install() {
	DOCS="AUTHORS ChangeLog NEWS FAQ README README.1ST" \
		default
	# no need for this directory for just playing the game
	#rm -rf "${D}${GAMES_DATADIR}/${PN}/estudio"
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	elog "You *must* have the original Ultima7 The Black Gate and/or"
	elog "The Serpent Isle installed."
	elog "See documentation in /usr/share/doc/${PF} for information."
}
