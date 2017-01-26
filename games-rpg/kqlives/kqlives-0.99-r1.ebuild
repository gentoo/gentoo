# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils

MY_P=${P/lives}

DESCRIPTION="A console-style role playing game"
HOMEPAGE="http://kqlives.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cheats nls"

RDEPEND="
	dev-lang/lua:0
	>=gnome-base/libglade-2.4
	media-libs/aldumb
	media-libs/allegro:0
	>=x11-libs/gtk+-2.8:2
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

S=${WORKDIR}/${MY_P}

src_configure() {
	econf \
		$(use_enable cheats) \
		$(use_enable nls)
}

src_install() {
	default

	local x
	for x in diff draw draw2 dump; do
		mv -vf "${D}/etc"/map${x} "${D}/etc"/kq-map${x}
	done

	doicon "${FILESDIR}"/${PN}.xpm
	make_desktop_entry kq KqLives ${PN}
}
