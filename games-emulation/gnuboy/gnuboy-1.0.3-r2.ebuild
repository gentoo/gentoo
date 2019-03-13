# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools

DESCRIPTION="Gameboy emulator with multiple renderers"
HOMEPAGE="https://sourceforge.net/projects/gnuboy/"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="X sdl"

RDEPEND="
	sdl? ( media-libs/libsdl )
	!X? ( media-libs/libsdl )
	X? ( x11-libs/libXext )
"
DEPEND="${RDEPEND}
	X? ( x11-base/xorg-proto )
"

src_prepare() {
	default
	eapply \
		"${FILESDIR}"/${P}-exec-stack.patch \
		"${FILESDIR}"/${P}-linux-headers.patch \
		"${FILESDIR}"/${P}-include.patch

	mv configure.in configure.ac || die
	eautoreconf
}

src_configure() {
	local myconf

	if ! use X ; then
		myconf="--with-sdl"
	fi

	econf \
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
			dobin ${f}
		fi
	done
	dodoc README docs/{CHANGES,CONFIG,CREDITS,FAQ,HACKING,WHATSNEW}
}
