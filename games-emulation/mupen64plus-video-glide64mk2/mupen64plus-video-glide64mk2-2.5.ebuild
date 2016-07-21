# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MY_P=${PN}-src-${PV}
inherit eutils multilib toolchain-funcs

DESCRIPTION="A fork of Mupen64 Nintendo 64 emulator, glide64mk2 video plugin"
HOMEPAGE="http://www.mupen64plus.org/"
SRC_URI="https://github.com/mupen64plus/${PN}/releases/download/${PV}/${MY_P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gles2 hires cpu_flags_x86_sse"

RDEPEND=">=games-emulation/mupen64plus-core-2.5:0=[gles2=]
	media-libs/libpng:0=
	media-libs/libsdl2:0=
	media-libs/libtxc_dxtn
	sys-libs/zlib:0=
	virtual/opengl:0=
	hires? ( dev-libs/boost:0= )"
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
		LIBDIR=/usr/$(get_libdir)

		# disable unwanted magic
		LDCONFIG=:
		INSTALL_STRIP_FLAG=

		# Package-specific stuff

		# CROSS_COMPILE causes it to look for ${CHOST}-sdl2-config...
		SDL_CFLAGS="$($(tc-getPKG_CONFIG) --cflags sdl2)"
		SDL_LDLIBS="$($(tc-getPKG_CONFIG) --libs sdl2)"

		NOSSE=$(usex cpu_flags_x86_sse 0 1)
		HIRES=$(usex hires 1 0)
		USE_FRAMESKIPPER=1
		USE_GLES=$(usex gles2 1 0)
		# use external lib
		TXCDXTN=1
	)

	use amd64 && MAKEARGS+=( HOST_CPU=x86_64 )
	use x86 && MAKEARGS+=( HOST_CPU=i386 )

	emake "${MAKEARGS[@]}" all
}

src_install() {
	emake "${MAKEARGS[@]}" DESTDIR="${D}" install
	einstalldocs
}
