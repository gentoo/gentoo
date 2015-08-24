# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MY_P=${PN}-src-${PV}
inherit eutils toolchain-funcs games

DESCRIPTION="A fork of Mupen64 Nintendo 64 emulator, core library"
HOMEPAGE="https://code.google.com/p/mupen64plus/"
SRC_URI="https://github.com/mupen64plus/${PN}/releases/download/${PV}/${MY_P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0/2"
KEYWORDS="~amd64 ~x86"
IUSE="lirc new-dynarec +osd cpu_flags_x86_sse"

RDEPEND="media-libs/libpng:0=
	media-libs/libsdl:0=[joystick,opengl,video]
	sys-libs/zlib:0=[minizip]
	lirc? ( app-misc/lirc:0 )
	osd? (
		media-fonts/ttf-bitstream-vera
		media-libs/freetype:2=
		virtual/opengl:0=
		virtual/glu:0=
	)
	!<games-emulation/mupen64plus-2.0"
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
		SHAREDIR="${GAMES_DATADIR}"/mupen64plus

		# disable unwanted magic
		LDCONFIG=:
		INSTALL_STRIP_FLAG=

		# Package-specific stuff

		# CROSS_COMPILE causes it to look for ${CHOST}-sdl-config...
		SDL_CFLAGS="$($(tc-getPKG_CONFIG) --cflags sdl)"
		SDL_LDLIBS="$($(tc-getPKG_CONFIG) --libs sdl)"

		OSD=$(usex osd 1 0)
		NO_ASM=$(usex cpu_flags_x86_sse 0 1)
		LIRC=$(usex lirc 1 0)
		# (it does not build)
		# DEBUGGER=$(usex debug 1 0)
		NEW_DYNAREC=$(usex new-dynarec 1 0)
	)

	use amd64 && MAKEARGS+=( HOST_CPU=x86_64 )
	use x86 && MAKEARGS+=( HOST_CPU=i386 )

	emake "${MAKEARGS[@]}" all
}

src_install() {
	emake "${MAKEARGS[@]}" DESTDIR="${D}" install
	einstalldocs
	dodoc -r doc/{emuwiki-api-doc,new_dynarec.txt}

	# replace bundled font with a symlink
	# TODO: fix the code to not rely on it
	local font_path=${GAMES_DATADIR}/mupen64plus/font.ttf
	rm "${D%/}/${font_path}" || die
	if use osd; then
		dosym /usr/share/fonts/ttf-bitstream-vera/Vera.ttf "${font_path}"
	fi
	prepgamesdirs
}
