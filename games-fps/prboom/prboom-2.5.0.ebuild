# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/prboom/prboom-2.5.0.ebuild,v 1.11 2015/01/31 06:45:53 tupone Exp $

EAPI=5
inherit eutils toolchain-funcs games

DESCRIPTION="Port of ID's doom to SDL and OpenGL"
HOMEPAGE="http://prboom.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz
	mirror://gentoo/${PN}.png"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm ~ppc x86"
IUSE=""

DEPEND="media-libs/libsdl[joystick,video]
	media-libs/sdl-mixer
	media-libs/sdl-net
	!<games-fps/lsdldoom-1.5
	virtual/opengl
	virtual/glu"
RDEPEND="${DEPEND}"

src_prepare() {
	ebegin "Detecting NVidia GL/prboom bug"
	$(tc-getCC) "${FILESDIR}"/${P}-nvidia-test.c 2> /dev/null
	local ret=$?
	eend ${ret} "NVidia GL/prboom bug found ;("
	[ ${ret} -eq 0 ] || epatch "${FILESDIR}"/${P}-nvidia.patch
	epatch "${FILESDIR}"/${P}-libpng14.patch
	sed -i \
		-e '/^gamesdir/ s/\/games/\/bin/' \
		src/Makefile.in \
		|| die "sed failed"
	sed -i \
		-e 's/: install-docDATA/:/' \
		-e '/^SUBDIRS/ s/doc//' \
		Makefile.in \
		|| die "sed failed"
	sed -i \
		-e 's:-ffast-math $CFLAGS_OPT::' \
		configure \
		|| die "sed configure failed"
}

src_configure() {
	# leave --disable-cpu-opt in otherwise the configure script
	# will append -march=i686 and crap ... let the user's CFLAGS
	# handle this ...
	egamesconf \
		--enable-gl \
		--disable-i386-asm \
		--disable-cpu-opt \
		--with-waddir="${GAMES_DATADIR}/doom-data"
}

src_install() {
	default
	emake DESTDIR="${D}" install
	doman doc/*.{5,6}
	dodoc doc/README.* doc/*.txt
	doicon "${DISTDIR}"/${PN}.png
	make_desktop_entry ${PN} "PrBoom"
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	elog "To play the original Doom levels, place doom.wad and/or doom2.wad"
	elog "into ${GAMES_DATADIR}/doom-data"
	elog "Then run ${PN} accordingly."
	elog
	elog "doom1.wad is the shareware demo wad consisting of 1 episode,"
	elog "and doom.wad is the full Doom 1 set of 3 episodes"
	elog "(or 4 in the Ultimate Doom wad)."
	elog
	elog "You can even emerge doom-data and/or freedoom to play for free."
}
