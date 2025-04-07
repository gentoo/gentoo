# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib multibuild

MY_P="SDL2_image-${PV}"
DESCRIPTION="Image file loading library"
HOMEPAGE="https://www.libsdl.org/projects/SDL_image/"
SRC_URI="https://github.com/libsdl-org/SDL_image/releases/download/release-${PV}/${MY_P}.tar.gz"
S="${WORKDIR}"/${MY_P}

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm arm64 ~hppa ~loong ppc64 ~riscv ~sparc ~x86"
IUSE="avif gif jpeg jpegxl png samples static-libs test tiff webp"
RESTRICT="!test? ( test )"
REQUIRED_USE="test? ( jpeg png )"

RDEPEND="
	>=media-libs/libsdl2-2.0.9[${MULTILIB_USEDEP}]
	>=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}]
	avif? ( >=media-libs/libavif-1.0.0:=[${MULTILIB_USEDEP}] )
	png? ( >=media-libs/libpng-1.6.10:0=[${MULTILIB_USEDEP}] )
	jpeg? ( media-libs/libjpeg-turbo:=[${MULTILIB_USEDEP}] )
	jpegxl? ( media-libs/libjxl:=[${MULTILIB_USEDEP}] )
	tiff? ( >=media-libs/tiff-3.9.7-r1:=[${MULTILIB_USEDEP}] )
	webp? ( >=media-libs/libwebp-0.3.0:=[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}"

pkg_setup() {
	MULTIBUILD_VARIANTS=( shared-libs $(usev static-libs) )
}

src_prepare() {
	cmake_src_prepare

	# 1. Install non standard license installation
	# 2/3. Add suffixes to sample programs
	sed -i \
		-e '/install(FILES "LICENSE.txt"/,/\s)$/d' \
		-e 's/\(\W\)showanim\(\W\)/\1showanim2\2/' \
		-e 's/\(\W\)showimage\(\W\)/\1showimage2\2/' \
		CMakeLists.txt || die
}

multilib_src_configure() {
	# hack because because of layered multibuilds
	if [[ -n ${is_shared} ]]; then
		mycmakeargs+=( -DSDL2IMAGE_SAMPLES=$(multilib_native_usex samples) )
	fi
	cmake_src_configure
}

src_configure() {
	myconfigure() {
		local mycmakeargs=(
			-DSDL2IMAGE_AVIF=$(usex avif)
			-DSDL2IMAGE_BMP=ON
			-DSDL2IMAGE_GIF=$(usex gif)
			-DSDL2IMAGE_JPG=$(usex jpeg)
			-DSDL2IMAGE_JXL=$(usex jpegxl)
			-DSDL2IMAGE_LBM=ON
			-DSDL2IMAGE_PCX=ON
			-DSDL2IMAGE_PNG=$(usex png)
			-DSDL2IMAGE_PNM=ON
			-DSDL2IMAGE_QOI=ON
			-DSDL2IMAGE_SVG=ON
			-DSDL2IMAGE_TGA=ON
			-DSDL2IMAGE_TIF=$(usex tiff)
			-DSDL2IMAGE_WEBP=$(usex webp)
			-DSDL2IMAGE_XCF=ON
			-DSDL2IMAGE_XPM=ON
			-DSDL2IMAGE_XV=ON

			# change?
			-DSDL2IMAGE_BACKEND_STB=OFF
			-DSDL2IMAGE_DEPS_SHARED=OFF
			-DSDL2IMAGE_SAMPLES_INSTALL=ON
			-DSDL2IMAGE_TESTS=$(usex test)
			-DSDL2IMAGE_TESTS_INSTALL=OFF
			-DSDL2IMAGE_VENDORED=OFF
		)
		if [[ "${MULTIBUILD_VARIANT}" == "shared-libs" ]]; then
			mycmakeargs+=( -DBUILD_SHARED_LIBS=ON )
			local is_shared=1
		else
			mycmakeargs+=(
				-DBUILD_SHARED_LIBS=OFF
				-DSDL2IMAGE_SAMPLES=OFF
			)
		fi

		cmake-multilib_src_configure
	}
	multibuild_foreach_variant myconfigure
}

src_compile() {
	multibuild_foreach_variant cmake-multilib_src_compile
}

src_test() {
	# https://github.com/libsdl-org/SDL_image/tree/main/test#asserting-format-support
	# Match same order as src_configure. The intent is to catch build system
	# bugs, so it may need updating sometimes for legitimate changes in
	# sdl2-image support.
	local -x SDL_IMAGE_TEST_REQUIRE_{LOAD,SAVE}_AVIF=$(usex avif 1 0)
	local -x SDL_IMAGE_TEST_REQUIRE_LOAD_BMP=1
	local -x SDL_IMAGE_TEST_REQUIRE_LOAD_GIF=$(usex gif 1 0)
	local -x SDL_IMAGE_TEST_REQUIRE_{LOAD,SAVE}_JPG=$(usex jpeg 1 0)
	local -x SDL_IMAGE_TEST_REQUIRE_{LOAD,SAVE}_JXL=$(usex jpegxl 1 0)
	local -x SDL_IMAGE_TEST_REQUIRE_{LOAD,SAVE}_LBM=1
	local -x SDL_IMAGE_TEST_REQUIRE_LOAD_PCX=1
	local -x SDL_IMAGE_TEST_REQUIRE_{LOAD,SAVE}_PNG=$(usex png 1 0)
	local -x SDL_IMAGE_TEST_REQUIRE_LOAD_QOI=1
	local -x SDL_IMAGE_TEST_REQUIRE_LOAD_SVG=1
	local -x SDL_IMAGE_TEST_REQUIRE_LOAD_TGA=1
	local -x SDL_IMAGE_TEST_REQUIRE_LOAD_TIF=$(usex tiff 1 0)
	local -x SDL_IMAGE_TEST_REQUIRE_LOAD_WEBP=$(usex webp 1 0)
	local -x SDL_IMAGE_TEST_REQUIRE_LOAD_XCF=1
	local -x SDL_IMAGE_TEST_REQUIRE_LOAD_XPM=1
	local -x SDL_IMAGE_TEST_REQUIRE_LOAD_XV=1

	multibuild_foreach_variant cmake-multilib_src_test
}

src_install() {
	multibuild_foreach_variant cmake-multilib_src_install
}
