# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit multilib-minimal

MY_P="${P/sdl-/SDL_}"
MY_COMMIT="5d792dde2f764daf15dc48521774a3354330db69"
DESCRIPTION="Image file loading library"
HOMEPAGE="https://www.libsdl.org/projects/SDL_image/release-1.2.html"
SRC_URI="https://github.com/libsdl-org/SDL_image/archive/${MY_COMMIT}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-solaris"
IUSE="gif jpeg png static-libs tiff webp"

RDEPEND="
	sys-libs/zlib[${MULTILIB_USEDEP}]
	>=media-libs/libsdl-1.2.15-r4[${MULTILIB_USEDEP}]
	png? ( media-libs/libpng:0[${MULTILIB_USEDEP}] )
	jpeg? ( virtual/jpeg:0[${MULTILIB_USEDEP}] )
	tiff? ( media-libs/tiff:0[${MULTILIB_USEDEP}] )
	webp? ( media-libs/libwebp:=[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}"

S=${WORKDIR}/SDL_image-${MY_COMMIT}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf \
		--disable-jpg-shared \
		--disable-png-shared \
		--disable-tif-shared \
		--disable-webp-shared \
		$(use_enable static-libs static) \
		$(use_enable gif) \
		$(use_enable jpeg jpg) \
		$(use_enable tiff tif) \
		$(use_enable png) \
		$(use_enable webp) \
		--enable-bmp \
		--enable-lbm \
		--enable-pcx \
		--enable-pnm \
		--enable-tga \
		--enable-xcf \
		--enable-xpm \
		--enable-xv
}

multilib_src_install() {
	emake DESTDIR="${D}" install
	dobin .libs/showimage
}

multilib_src_install_all() {
	dodoc CHANGES README
	use static-libs || find "${ED}" -type f -name "*.la" -delete || die
}
