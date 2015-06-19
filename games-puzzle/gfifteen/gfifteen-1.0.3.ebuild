# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-puzzle/gfifteen/gfifteen-1.0.3.ebuild,v 1.4 2015/01/19 16:35:46 mr_bones_ Exp $

EAPI=5
inherit eutils gnome2-utils games

DESCRIPTION="graphical implementation of the sliding puzzle game fifteen"
HOMEPAGE="https://frigidcode.com/code/gfifteen/"
SRC_URI="https://frigidcode.com/code/gfifteen/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="x11-libs/gtk+:3"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	# make it compile against newer gtk+:3 (bug #536994)
	sed -i \
		-e 's/-DGTK_DISABLE_DEPRECATED=1 //' \
		Makefile.in || die
}

src_configure() {
	egamesconf --disable-assembly
}

src_install() {
	default
	doicon -s scalable ${PN}.svg
	domenu gfifteen.desktop
	prepgamesdirs
}

pkg_preinst() {
	gnome2_icon_savelist
	games_pkg_preinst
}

pkg_postinst() {
	gnome2_icon_cache_update
	games_pkg_postinst
}

pkg_postrm() {
	gnome2_icon_cache_update
}
