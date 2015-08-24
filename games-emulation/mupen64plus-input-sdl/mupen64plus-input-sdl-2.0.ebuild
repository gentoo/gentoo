# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MY_P=${PN}-src-${PV}
inherit eutils toolchain-funcs games

DESCRIPTION="A fork of Mupen64 Nintendo 64 emulator, SDL input plugin"
HOMEPAGE="https://code.google.com/p/mupen64plus/"
SRC_URI="https://github.com/mupen64plus/${PN}/releases/download/${PV}/${MY_P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="games-emulation/mupen64plus-core:0=
	media-libs/libsdl:0=[joystick]"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch_user

	# avoid implicitly appending CPU flags
	sed -i -e 's:-mmmx::g' -e 's:-msse::g' projects/unix/Makefile || die
}

src_compile() {
	MAKEARGS=(
		# Note: please keep this in sync in all of mupen64plus-* packages

		-C projects/unix

		# this basically means: GNU userspace
		UNAME=Linux

		# verbose output
		V=1

		CROSS_COMPILE="${CHOST}-"
		CC="$(tc-getCC)"
		CXX="$(tc-getCXX)"
		PKG_CONFIG="$(tc-getPKG_CONFIG)"
		# usual CFLAGS, CXXFLAGS and LDFLAGS are respected
		# so we can leave OPTFLAGS empty
		OPTFLAGS=

		# paths, some of them are used at compile time
		PREFIX=/usr
		LIBDIR="$(games_get_libdir)"
		PLUGINDIR="$(games_get_libdir)"/mupen64plus
		SHAREDIR="${GAMES_DATADIR}"/mupen64plus

		# disable unwanted magic
		LDCONFIG=:
		INSTALL_STRIP_FLAG=

		# Package-specific stuff

		# CROSS_COMPILE causes it to look for ${CHOST}-sdl-config...
		SDL_CFLAGS="$($(tc-getPKG_CONFIG) --cflags sdl)"
		SDL_LDLIBS="$($(tc-getPKG_CONFIG) --libs sdl)"
	)

	use amd64 && MAKEARGS+=( HOST_CPU=x86_64 )
	use x86 && MAKEARGS+=( HOST_CPU=i386 )

	emake "${MAKEARGS[@]}" all
}

src_install() {
	emake "${MAKEARGS[@]}" DESTDIR="${D}" install
	einstalldocs
	prepgamesdirs
}
