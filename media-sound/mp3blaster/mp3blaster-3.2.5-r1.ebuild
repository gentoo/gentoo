# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/mp3blaster/mp3blaster-3.2.5-r1.ebuild,v 1.10 2012/09/09 17:12:06 armin76 Exp $

EAPI=4
inherit eutils

DESCRIPTION="Text console based program for playing audio files"
HOMEPAGE="http://mp3blaster.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz
	mirror://debian/pool/main/m/${PN}/${PN}_${PV}-3.debian.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="lirc oss sdl sid vorbis"

RDEPEND=">=sys-libs/ncurses-5.7-r7
	lirc? ( app-misc/lirc )
	sdl? ( media-libs/libsdl )
	sid? ( =media-libs/libsidplay-1* )
	vorbis? ( >=media-libs/libvorbis-1 )"
DEPEND="${RDEPEND}
	x11-misc/imake
	oss? ( virtual/os-headers )"

REQUIRED_USE="|| ( oss sdl )"

DOCS="AUTHORS BUGS ChangeLog CREDITS FAQ NEWS README TODO"

src_prepare() {
	EPATCH_SOURCE=${WORKDIR}/debian/patches EPATCH_SUFFIX=patch EPATCH_FORCE=yes epatch
	# file collision with media-sound/splay
	sed -i -e 's:splay.1:splay_mp3blaster.1:' Makefile.in || die
	mv -vf splay{,_mp3blaster}.1 || die
}

src_configure() {
	# libpth and newthreads support are both broken
	econf \
		--disable-newthreads \
		--without-pth \
		--without-nas \
		$(use_with lirc) \
		$(use_with vorbis oggvorbis) \
		$(use_with sid sidplay) \
		--without-esd \
		$(use_with sdl) \
		$(use_with oss)
}

src_install() {
	default

	doman "${WORKDIR}"/debian/manpages/mp3tag.1

	# relocate everything except commands.txt because it's used by src/main.cc
	mv -vf "${ED}"usr/share/${PN}/{charmap,sample.*} "${ED}"usr/share/doc/${PF} || die

	# file collision with media-sound/splay
	mv -vf "${ED}"usr/bin/splay{,_mp3blaster} || die
}
