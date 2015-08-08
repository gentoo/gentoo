# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit games

MY_RLS="R1"
DESCRIPTION="A Atari Lynx emulator for Linux"
HOMEPAGE="http://sdlemu.ngemu.com/handysdl.php"
SRC_URI="http://sdlemu.ngemu.com/releases/Handy-SDL-${PV}${MY_RLS}.i386.linux-glibc22.tar.bz2"

# Closed source, but docs/Handy.html says that it "does not contain
# any copyrighted materials"
LICENSE="public-domain no-source-code"
SLOT="0"
KEYWORDS="-* ~x86"
RESTRICT="strip"
IUSE=""

RDEPEND="media-libs/libsdl
	sys-libs/zlib
	sys-libs/lib-compat"
DEPEND=${RDEPEND}

S=${WORKDIR}

QA_PREBUILT="${GAMES_PREFIX_OPT:1}/${PN}/handy"

src_install() {
	local dir=${GAMES_PREFIX_OPT}/${PN}
	exeinto "${dir}"
	newexe sdlhandy handy
	dohtml -r docs/*
	games_make_wrapper sdlhandy ./sdlhandy "${dir}" "${dir}"
	games_make_wrapper handy ./handy "${dir}" "${dir}"
	prepgamesdirs
}
