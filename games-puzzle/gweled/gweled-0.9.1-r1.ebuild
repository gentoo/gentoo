# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit flag-o-matic autotools games

DESCRIPTION="Bejeweled clone game"
HOMEPAGE="http://www.gweled.org/"
SRC_URI="https://launchpad.net/gweled/trunk/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="x11-libs/gtk+:2
	media-libs/libmikmod
	gnome-base/librsvg:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gentoo.patch
	eautoreconf
}

src_configure() {
	filter-flags -fomit-frame-pointer
	append-ldflags -Wl,--export-dynamic
	egamesconf \
		--disable-setgid
}

src_install() {
	default
	gamesowners -R "${D}/var/games/gweled"
	prepgamesdirs
}
