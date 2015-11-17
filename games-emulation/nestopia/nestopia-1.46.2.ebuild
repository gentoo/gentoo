# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils gnome2-utils games

MY_P=${P/ue/}
DESCRIPTION="A portable Nintendo Entertainment System emulator written in C++"
HOMEPAGE="http://0ldsk00l.ca/nestopia/"
SRC_URI="mirror://sourceforge/nestopiaue/${PV%.*}/${MY_P}.tgz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc"

RDEPEND="x11-libs/gtk+:3
	media-libs/libao
	media-libs/libsdl2[sound,joystick,video]
	app-arch/libarchive
	sys-libs/zlib
	virtual/opengl
	virtual/glu"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}

src_prepare() {
	sed -i \
		-e '/^CC /d' \
		-e '/^CXX /d' \
		-e '/^LDFLAGS /d' \
		-e '/^LIBS =/ s/=/+=/' \
		-e '/^CFLAGS / s/=/+=/' \
		-e "/^PREFIX / s:=.*:=${GAMES_PREFIX}:" \
		-e "/^BINDIR / s:=.*:=${GAMES_BINDIR}:" \
		-e "/^DATADIR / s:=.*:=${GAMES_DATADIR}/${PN}:" \
		Makefile || die
	epatch "${FILESDIR}"/${P}-format.patch
}

src_install() {
	local res

	dogamesbin ${PN}

	insinto "${GAMES_DATADIR}/${PN}"
	doins -r NstDatabase.xml source/unix/icons

	domenu source/unix/icons/nestopia.desktop
	for res in 32 48 64 128
	do
		newicon -s ${res} source/unix/icons/nestopia${res}.png nestopia.png
	done
	doicon -s scalable source/unix/icons/nestopia.svg

	dodoc AUTHORS README.* changelog.txt
	use doc && dohtml -r readme.html doc/*.html doc/details

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
