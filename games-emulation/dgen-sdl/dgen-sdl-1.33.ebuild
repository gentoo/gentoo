# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils games

DESCRIPTION="A Linux/SDL-Port of the famous DGen MegaDrive/Genesis-Emulator"
HOMEPAGE="http://dgen.sourceforge.net/"
SRC_URI="mirror://sourceforge/dgen/files/${P}.tar.gz"

LICENSE="dgen-sdl BSD BSD-2 free-noncomm LGPL-2.1+ GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="joystick opengl"

RDEPEND="media-libs/libsdl[joystick?,opengl?]
	app-arch/libarchive
	opengl? ( virtual/opengl )"
DEPEND="${RDEPEND}
	x86? ( dev-lang/nasm )"

src_prepare() {
	# fix building with USE=-joystick
	epatch "${FILESDIR}"/${P}-joystick.patch
}

src_configure() {
	egamesconf \
		$(use_enable x86 asm) \
		$(use_enable joystick) \
		$(use_enable opengl)
}

src_compile() {
	emake -C musa m68kops.h
	emake
}

src_install() {
	DOCS="AUTHORS ChangeLog README sample.dgenrc" default
	prepgamesdirs
}
