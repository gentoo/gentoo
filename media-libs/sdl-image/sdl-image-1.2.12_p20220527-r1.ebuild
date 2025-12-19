# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# We may want to grab backports from the SDL-1.2 branch upstream or
# or take new snapshots every so often as no SDL 1 / 1.2.x releases
# will be made anymore.

inherit autotools toolchain-funcs multilib-minimal

SDL_IMAGE_COMMIT="633dc522f5114f6d473c910dace62e8ca27a1f7d"

MY_PN=${PN/sdl-/SDL_}
DESCRIPTION="Image file loading library"
HOMEPAGE="https://github.com/libsdl-org/SDL_image"
SRC_URI="https://github.com/libsdl-org/SDL_image/archive/${SDL_IMAGE_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${MY_PN}-${SDL_IMAGE_COMMIT}

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~sparc x86"
IUSE="gif jpeg png static-libs tiff webp"

RDEPEND="
	>=media-libs/libsdl-1.2.15-r4[${MULTILIB_USEDEP}]
	virtual/zlib:=[${MULTILIB_USEDEP}]
	png? ( media-libs/libpng[${MULTILIB_USEDEP}] )
	jpeg? ( media-libs/libjpeg-turbo:=[${MULTILIB_USEDEP}] )
	tiff? ( media-libs/tiff:=[${MULTILIB_USEDEP}] )
	webp? ( media-libs/libwebp:=[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	eautoreconf
}

multilib_src_configure() {
	local myeconfargs=(
		--disable-jpg-shared
		--disable-png-shared
		--disable-tif-shared
		--disable-webp-shared
		$(use_enable static-libs static)
		$(use_enable gif)
		$(use_enable jpeg jpg)
		$(use_enable tiff tif)
		$(use_enable png)
		$(use_enable webp)
		--enable-bmp
		--enable-lbm
		--enable-pcx
		--enable-pnm
		--enable-tga
		--enable-xcf
		--enable-xpm
		--enable-xv
	)

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_compile() {
	emake OBJC="$(tc-getCC)"
}

multilib_src_install() {
	emake DESTDIR="${D}" install
	dobin .libs/showimage
}

multilib_src_install_all() {
	dodoc CHANGES README
	use static-libs || find "${ED}" -type f -name "*.la" -delete || die
}
