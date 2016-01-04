# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils multilib-minimal

MY_P=SDL2_image-${PV}
DESCRIPTION="Image file loading library"
HOMEPAGE="http://www.libsdl.org/projects/SDL_image/"
SRC_URI="http://www.libsdl.org/projects/SDL_image/release/${MY_P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gif jpeg png static-libs tiff webp"

RDEPEND="
	>=media-libs/libsdl2-2.0.1-r1[${MULTILIB_USEDEP}]
	>=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}]
	png? ( >=media-libs/libpng-1.6.10:0[${MULTILIB_USEDEP}] )
	jpeg? ( >=virtual/jpeg-0-r2:0[${MULTILIB_USEDEP}] )
	tiff? ( >=media-libs/tiff-3.9.7-r1:0[${MULTILIB_USEDEP}] )
	webp? ( >=media-libs/libwebp-0.3.0[${MULTILIB_USEDEP}] )"
DEPEND=${RDEPEND}

S=${WORKDIR}/${MY_P}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf \
		$(use_enable static-libs static) \
		--disable-sdltest \
		--enable-bmp \
		$(use_enable gif) \
		$(use_enable jpeg jpg) \
		--disable-jpg-shared \
		--enable-lbm \
		--enable-pcx \
		$(use_enable png) \
		--disable-png-shared \
		--enable-pnm \
		--enable-tga \
		$(use_enable tiff tif) \
		--disable-tif-shared \
		--enable-xcf \
		--enable-xpm \
		--enable-xv \
		$(use_enable webp) \
		--disable-webp-shared
}

multilib_src_install() {
	emake DESTDIR="${D}" install
	multilib_is_native_abi && newbin .libs/showimage showimage2
}

multilib_src_install_all() {
	dodoc {CHANGES,README}.txt
	prune_libtool_files
}
