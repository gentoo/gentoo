# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils gnome2-utils games

DESCRIPTION="Stella Atari 2600 VCS Emulator"
HOMEPAGE="http://stella.sourceforge.net/"
SRC_URI="mirror://sourceforge/stella/${P}-src.tar.xz"

LICENSE="GPL-2+ BSD"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="joystick"

DEPEND="media-libs/libsdl2[joystick?,opengl,video]
	media-libs/libpng:0
	sys-libs/zlib"
RDEPEND=${DEPEND}

src_prepare() {
	sed -i \
		-e '/INSTALL/s/-s //' \
		-e '/STRIP/d' \
		-e "/icons/d" \
		-e '/INSTALL.*DOCDIR/d' \
		-e '/INSTALL.*\/applications/d' \
		-e '/CXXFLAGS+=/s/-fomit-frame-pointer//' \
		Makefile || die
}

src_configure() {
	# not an autoconf script
	./configure \
		--prefix="/usr" \
		--bindir="${GAMES_BINDIR}" \
		--docdir="/usr/share/doc/${PF}" \
		--datadir="${GAMES_DATADIR}" \
		$(use_enable joystick) \
		|| die
}

src_install() {
	local i

	DOCS="Announce.txt Changes.txt Copyright.txt README-SDL.txt Readme.txt Todo.txt" \
		default

	for i in 16 22 24 32 48 64 128 ; do
		newicon -s ${i} src/common/stella-${i}x${i}.png stella.png
	done
	domenu src/unix/stella.desktop
	dohtml -r docs/*
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
