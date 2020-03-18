# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P=${PN}-src-${PV}
inherit toolchain-funcs

DESCRIPTION="A fork of Mupen64 Nintendo 64 emulator, core library"
HOMEPAGE="https://www.mupen64plus.org/"
SRC_URI="https://github.com/mupen64plus/${PN}/releases/download/${PV}/${MY_P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0/2-sdl2"
KEYWORDS="~amd64 ~x86"
IUSE="debugger gles2 lirc new-dynarec opencv +osd cpu_flags_x86_sse"

RDEPEND="media-libs/libpng:0=
	media-libs/libsdl2:0=[joystick,opengl,video]
	sys-libs/zlib:0=[minizip]
	gles2? ( media-libs/libsdl2:0[gles] )
	lirc? ( app-misc/lirc:0 )
	opencv? ( media-libs/opencv:= )
	osd? (
		media-fonts/dejavu
		media-libs/freetype:2=
		virtual/opengl:0=
		virtual/glu:0=
	)"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

REQUIRED_USE="gles2? ( !osd )"
S=${WORKDIR}/${MY_P}

PATCHES=( "${FILESDIR}"/${PN}-2.5.9-fix-gcc10-fno-common.patch )

src_prepare() {
	default

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
		LIBDIR=/usr/$(get_libdir)

		# disable unwanted magic
		LDCONFIG=:
		INSTALL_STRIP_FLAG=

		# Package-specific stuff

		# CROSS_COMPILE causes it to look for ${CHOST}-sdl2-config...
		SDL_CFLAGS="$($(tc-getPKG_CONFIG) --cflags sdl2)"
		SDL_LDLIBS="$($(tc-getPKG_CONFIG) --libs sdl2)"

		OSD=$(usex osd 1 0)
		NO_ASM=$(usex cpu_flags_x86_sse 0 1)
		LIRC=$(usex lirc 1 0)
		OPENCV=$(usex opencv 1 0)
		DEBUGGER=$(usex debugger 1 0)
		NEW_DYNAREC=$(usex new-dynarec 1 0)
		USE_GLES=$(usex gles2 1 0)
	)

	use amd64 && MAKEARGS+=( HOST_CPU=x86_64 )
	use x86 && MAKEARGS+=( HOST_CPU=i386 )

	emake "${MAKEARGS[@]}" all
}

src_install() {
	emake "${MAKEARGS[@]}" DESTDIR="${D}" install
	dodoc -r CREDITS README RELEASE doc/{emuwiki-api-doc,new_dynarec.mediawiki}

	# replace bundled font with a symlink
	# TODO: fix the code to not rely on it
	rm "${ED}/usr/share/mupen64plus/font.ttf" || die
	if use osd; then
		dosym ../fonts/dejavu/DejaVuSans.ttf /usr/share/mupen64plus/font.ttf
	fi
}
