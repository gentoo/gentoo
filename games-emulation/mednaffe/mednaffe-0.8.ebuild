# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools flag-o-matic gnome2-utils games

DESCRIPTION="A front-end (GUI) for mednafen emulator"
HOMEPAGE="https://github.com/AmatCoder/mednaffe"
SRC_URI="https://github.com/AmatCoder/mednaffe/archive/v$PV.zip -> ${P}.zip"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

DEPEND="app-arch/unzip
	x11-libs/gtk+:3
	virtual/pkgconfig"
RDEPEND="x11-libs/gtk+:3
	games-emulation/mednafen[debugger]"

src_prepare() {
	append-cflags -Wl,-export-dynamic
	sed -i -e '/^CFLAGS=/d' configure.ac || die
	sed -i -e 's:$(datadir):/usr/share:' share/Makefile.am || die
	eautoreconf
}

src_configure() {
	egamesconf --enable-gtk3
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
