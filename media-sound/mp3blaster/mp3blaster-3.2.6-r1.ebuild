# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Text console based program for playing audio files"
HOMEPAGE="http://www.mp3blaster.org/ http://mp3blaster.sourceforge.net/ https://github.com/stragulus/mp3blaster"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ppc ppc64 ~riscv sparc x86"
IUSE="lirc oss +sdl sid vorbis"
REQUIRED_USE="|| ( oss sdl )"

RDEPEND="
	sys-libs/ncurses:=
	lirc? ( app-misc/lirc )
	sdl? ( media-libs/libsdl )
	sid? ( media-libs/libsidplay:1 )
	vorbis? ( media-libs/libvorbis )"
DEPEND="
	${RDEPEND}
	oss? ( virtual/os-headers )"
BDEPEND="x11-misc/imake"

PATCHES=(
	"${FILESDIR}"/${PN}-3.2.5-fix-c++14.patch
	"${FILESDIR}"/${PN}-3.2.5-fix-build-system.patch
)

src_prepare() {
	default
	eautoreconf

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

	# relocate everything except commands.txt because it's used by src/main.cc
	mv -vf "${ED}"/usr/share/{${PN}/{charmap,sample.*},doc/${PF}} || die

	# file collision with media-sound/splay
	mv -vf "${ED}"/usr/bin/splay{,_mp3blaster} || die
}
