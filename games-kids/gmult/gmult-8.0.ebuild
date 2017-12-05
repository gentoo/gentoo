# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils gnome2-utils flag-o-matic games

DESCRIPTION="Multiplication Puzzle emulates the multiplication game found in Emacs"
HOMEPAGE="http://www.mterry.name/gmult/"
SRC_URI="https://launchpad.net/gmult/trunk/${PV}/+download/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-libs/glib:2
	x11-libs/gtk+:3
	virtual/libintl"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig"

src_configure() {
	append-libs -lm
	econf \
		--bindir="${GAMES_BINDIR}"
}

src_install() {
	default
	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	games_pkg_postinst
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
