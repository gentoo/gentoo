# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit games

DESCRIPTION="a multi system emulator for many console and handheld video game systems"
HOMEPAGE="http://www.xe-emulator.com/"
SRC_URI="amd64? ( http://www.xe-emulator.com/files/${PN}-x86-64-bin.${PV}.tar.bz2 )
	x86? ( http://www.xe-emulator.com/files/${PN}-x86-32-bin.${PV}.tar.bz2 )"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE=""
RESTRICT="mirror bindist strip"

RDEPEND="x11-libs/libXv
	x11-libs/libXinerama
	x11-libs/libXxf86vm
	sys-libs/zlib
	media-libs/alsa-lib
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

dir=${games_get_libdir}/${PN}

QA_PREBUILT="${dir:1}/modules/*
	${GAMES_BINDIR:1}/xe.bin"

src_unpack() {
	unpack ${A}
	mv -v * ${P} || die
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-gentoo.patch
}

src_install() {
	newgamesbin xe xe.bin
	newgamesbin "${FILESDIR}"/xe-${PV} xe
	sed -i \
		-e "s:GENTOODIR:$(games_get_libdir)/${PN}:" "${D}/${GAMES_BINDIR}/xe" \
		|| die "sed failed"
	insinto "$(games_get_libdir)"/${PN}
	doins -r modules/ rc/
	keepdir "$(games_get_libdir)"/${PN}/bios
	dodoc README.txt
	dohtml manual.html
	prepgamesdirs
}
