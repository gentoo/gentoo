# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils games

DESCRIPTION="Gameboy emulator with multiple renderers"
HOMEPAGE="https://code.google.com/p/gnuboy/"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="X sdl"

RDEPEND="sdl? ( media-libs/libsdl )
	!X? ( media-libs/libsdl )
	X? ( x11-libs/libXext )"
DEPEND="${RDEPEND}
	X? ( x11-proto/xextproto
		x11-proto/xproto )"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-exec-stack.patch \
		"${FILESDIR}"/${P}-linux-headers.patch \
		"${FILESDIR}"/${P}-include.patch

	eautoreconf
}

src_configure() {
	local myconf

	if ! use X ; then
		myconf="--with-sdl"
	fi

	egamesconf \
		$(use_with X x) \
		$(use_with sdl) \
		$(use_enable x86 asm) \
		${myconf} \
		--disable-arch \
		--disable-optimize
}

src_install() {
	for f in sdlgnuboy xgnuboy
	do
		if [[ -f ${f} ]] ; then
			dogamesbin ${f}
		fi
	done
	dodoc README docs/{CHANGES,CONFIG,CREDITS,FAQ,HACKING,WHATSNEW}
	prepgamesdirs
}
