# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils toolchain-funcs games

DESCRIPTION="Rogue-like D&D curses game similar to nethack (BUT BETTER)"
HOMEPAGE="http://remarque.org/~grabiner/moria.html"
SRC_URI="ftp://ftp.greyhelm.com/pub/Games/Moria/source/um${PV}.tar.Z
	http://www.funet.fi/pub/unix/games/moria/source/um${PV}.tar.Z
	http://www.piratehaven.org/~beej/moria/mirror/Games/Moria/source/um${PV}.tar.Z
	http://alge.anart.no/ftp/pub/games/RPG/moria/um${PV}.tar.Z
	ftp://kane.evendata.net/pub/${PN}-extras.tar.bz2"

LICENSE="Moria"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=sys-libs/ncurses-5"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/umoria

src_prepare() {
	local f

	epatch \
		"${FILESDIR}"/${PV}-gentoo-paths.patch \
		"${FILESDIR}"/${PV}-glibc.patch \
		"${FILESDIR}"/${PV}-fbsd.patch \
		"${FILESDIR}"/${PV}-hours.patch \
		"${FILESDIR}"/${PV}-warnings.patch

	for f in source/* unix/* ; do
		ln -s ${f} $(basename ${f})
	done

	sed -i \
		-e "s:David Grabiner:root:" \
		-e "s:GENTOO_DATADIR:${GAMES_DATADIR}/${PN}:" \
		-e "s:GENTOO_STATEDIR:${GAMES_STATEDIR}:" \
		config.h || die
	{
		echo "#include <stdlib.h>"
		echo "#include <stdio.h>"
	} >> config.h || die
	sed -i \
		-e "/^STATEDIR =/s:=.*:=\$(DESTDIR)${GAMES_STATEDIR}:" \
		-e "/^BINDIR = /s:=.*:=\$(DESTDIR)${GAMES_BINDIR}:" \
		-e "/^LIBDIR = /s:=.*:=\$(DESTDIR)${GAMES_DATADIR}/${PN}:" \
		-e "/^CFLAGS = /s:=.*:=${CFLAGS}:" \
		-e "/^OWNER = /s:=.*:=${GAMES_USER}:" \
		-e "/^GROUP = /s:=.*:=${GAMES_GROUP}:" \
		-e "/^CC = /s:=.*:=$(tc-getCC):" \
		-e '/^LFLAGS = /s:=.*:= $(LDFLAGS):' \
		Makefile || die
	mv doc/moria.6 "${S}" || die
}

src_install() {
	dodir "${GAMES_BINDIR}" "${GAMES_DATADIR}/${PN}" "${GAMES_STATEDIR}"
	emake DESTDIR="${D}" install

	doman moria.6
	dodoc README doc/* "${WORKDIR}"/${PN}-extras/*

	prepgamesdirs
}
