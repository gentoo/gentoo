# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils games

DESCRIPTION="Reversi game for GNOME, supporting the Go/Game Text Protocol"
HOMEPAGE="http://rhino.sourceforge.net/"
SRC_URI="mirror://sourceforge/rhino/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="gnome gtp nls"

RDEPEND="gnome? ( =gnome-base/libgnomeui-2* )
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

src_prepare() {
	sed -i '/^(\|locale\|help\|omf\|icon\|)/s:@datadir@:/usr/share:' \
		Makefile.in || die
}

src_configure() {
	if use gnome || use gtp; then
		egamesconf \
			--localedir=/usr/share/locale \
			$(use_enable gnome) \
			$(use_enable gtp) \
			$(use_enable nls)
	else
		egamesconf \
			--localedir=/usr/share/locale \
			--enable-gtp \
			--disable-gnome \
			$(use_enable nls)
	fi
}

src_install() {
	default
	use gnome && make_desktop_entry ${PN} GRhino
	prepgamesdirs
}
