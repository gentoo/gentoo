# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib multilib-minimal toolchain-funcs

MY_P="SDL2_image-${PV}"
DESCRIPTION="Image file loading library"
HOMEPAGE="https://www.libsdl.org/projects/SDL_image/"
SRC_URI="https://github.com/libsdl-org/SDL_image/releases/download/release-2.6.3/${MY_P}.tar.gz"
S="${WORKDIR}"/${MY_P}

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~loong ~ppc64 ~riscv ~x86"
IUSE="avif gif jpeg jpegxl png static-libs tiff webp"

RDEPEND="
	>=media-libs/libsdl2-2.0.9[${MULTILIB_USEDEP}]
	>=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}]
	avif? ( media-libs/libavif:=[${MULTILIB_USEDEP}] )
	png? ( >=media-libs/libpng-1.6.10:0[${MULTILIB_USEDEP}] )
	jpeg? ( media-libs/libjpeg-turbo:=[${MULTILIB_USEDEP}] )
	jpegxl? ( media-libs/libjxl:=[${MULTILIB_USEDEP}] )
	tiff? ( >=media-libs/tiff-3.9.7-r1:=[${MULTILIB_USEDEP}] )
	webp? ( >=media-libs/libwebp-0.3.0:=[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}"

multilib_src_configure() {
	local myeconfargs=(
		$(use_enable static-libs static)
		$(use_enable avif)
		--disable-avif-shared
		--disable-sdltest
		--disable-stb-image
		--enable-bmp
		$(use_enable gif)
		$(use_enable jpeg jpg)
		--disable-jpg-shared
		$(use_enable jpegxl jxl)
		--disable-jxl-shared
		--enable-lbm
		--enable-pcx
		$(use_enable png)
		--disable-png-shared
		--enable-pnm
		--enable-tga
		$(use_enable tiff tif)
		--disable-tif-shared
		--enable-qoi
		--enable-xcf
		--enable-xpm
		--enable-xv
		$(use_enable webp)
		--disable-webp-shared
	)
	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_compile() {
	emake OBJC="$(tc-getCC)"
}

multilib_src_install() {
	emake DESTDIR="${D}" install
	multilib_is_native_abi && newbin .libs/showimage$(get_exeext) showimage2$(get_exeext)
}

multilib_src_install_all() {
	dodoc {CHANGES,README}.txt
	find "${ED}" -type f -name "*.la" -delete || die
}
