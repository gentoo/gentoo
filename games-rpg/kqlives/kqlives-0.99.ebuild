# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils games

MY_P=${P/lives}

DESCRIPTION="A console-style role playing game"
HOMEPAGE="http://kqlives.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="cheats nls"

RDEPEND=">=x11-libs/gtk+-2.8:2
	>=gnome-base/libglade-2.4
	media-libs/allegro:0
	media-libs/aldumb
	dev-lang/lua
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

S=${WORKDIR}/${MY_P}

src_configure() {
	egamesconf \
		$(use_enable nls) \
		$(use_enable cheats)
}

src_install() {
	default

	local x
	for x in diff draw draw2 dump; do
		mv -vf "${D}${GAMES_BINDIR}"/map${x} "${D}${GAMES_BINDIR}"/kq-map${x}
	done

	doicon "${FILESDIR}"/${PN}.xpm
	make_desktop_entry kq KqLives ${PN}

	prepgamesdirs
}
