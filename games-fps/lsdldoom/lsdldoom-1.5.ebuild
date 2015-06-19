# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/lsdldoom/lsdldoom-1.5.ebuild,v 1.4 2013/02/25 02:43:31 vapier Exp $

EAPI=2
inherit eutils games

DESCRIPTION="Port of ID's doom to SDL"
HOMEPAGE="http://jesshaas.com/lsdldoom/"
SRC_URI="http://jesshaas.com/lsdldoom/src/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="arm ppc x86"
IUSE="+net +shareware freedoom"

DEPEND="media-libs/libsdl[video]
	media-libs/sdl-mixer
	net? ( media-libs/sdl-net )"
RDEPEND="${DEPEND}
	shareware? ( games-fps/doom-data )
	freedoom? ( games-fps/freedoom )"

PATCHES=( "${FILESDIR}"/${P}-paths.patch )

src_configure() {
	# cpu-opt -> just adds -mcpu crap to CFLAGS
	egamesconf \
		--disable-dependency-tracking \
		--disable-cpu-opt \
		$(use_enable net net-game)
}

src_install() {
	emake DESTDIR="${D}" install || die
	prepalldocs
	dodoc ChangeLog
	prepgamesdirs
}
