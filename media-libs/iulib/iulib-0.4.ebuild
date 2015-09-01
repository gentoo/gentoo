# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit eutils toolchain-funcs multilib scons-utils

DESCRIPTION="easy-to-use image and video I/O functions"
HOMEPAGE="https://github.com/tmbdev/iulib"
SRC_URI="https://iulib.googlecode.com/files/${P}.tgz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="sdl"

RDEPEND="sys-libs/zlib
	media-libs/libpng
	virtual/jpeg
	media-libs/tiff
	sdl? (
		media-libs/libsdl
		media-libs/sdl-gfx
	)"
DEPEND="${RDEPEND}
	dev-util/scons"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.4-scons-build-env.patch
	sed -i \
		-e "/^have_sdl = 1/s:1:$(usex sdl 1 0):" \
		-e '/tiff/s:inflate:TIFFOpen:' \
		-e '/progs.Append(LIBS=libiulib)/s:Append:Prepend:' \
		-e "/^libdir/s:/lib:/$(get_libdir):" \
		SConstruct || die #297326 #308955 #310439
	sed -i '/SDL.SDL_image.h/d' utils/dgraphics.cc || die #310443
	tc-export AR CC CXX RANLIB
}

src_configure() {
	# Avoid configure as we build/install with scons
	:
}

src_compile() {
	escons prefix=/usr
}

src_install() {
	escons prefix="${D}"/usr install
	dodoc CHANGES README TODO
}
