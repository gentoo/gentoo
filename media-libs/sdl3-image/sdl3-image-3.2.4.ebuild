# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib multibuild

DESCRIPTION="A simple library to load images of various formats as SDL surfaces."
HOMEPAGE="https://www.libsdl.org/projects/SDL_image/"
SRC_URI="https://github.com/libsdl-org/SDL_image/archive/refs/tags/release-${PV}/SDL3_image-${PV}.tar.gz"

S="${WORKDIR}/SDL_image-release-${PV}"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="avif gif jpeg jpegxl png samples static-libs stb test tiff webp"
RESTRICT="!test? ( test )"
REQUIRED_USE="
	stb? ( jpeg png )
	test? ( jpeg png )
"

RDEPEND="
	>=media-libs/libsdl3-3.0.0[${MULTILIB_USEDEP}]
	>=virtual/zlib-1.2.8-r1:=[${MULTILIB_USEDEP}]
	avif? ( >=media-libs/libavif-1.0.0:=[${MULTILIB_USEDEP}] )
	!stb? (
		png? ( >=media-libs/libpng-1.6.10:0=[${MULTILIB_USEDEP}] )
		jpeg? ( media-libs/libjpeg-turbo:=[${MULTILIB_USEDEP}] )
	)
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
		mycmakeargs+=( -DSDLIMAGE_SAMPLES=$(multilib_native_usex samples) )
	fi
	cmake_src_configure
}

src_configure() {
	myconfigure() {
		local mycmakeargs=(
			-DSDLIMAGE_DEPS_SHARED=ON # Force dynamic loading of dependencies
			-DSDLIMAGE_INSTALL_MAN=ON
			-DSDLIMAGE_STRICT=ON # Fail when a dependency could not be found
			-DSDLIMAGE_TESTS_INSTALL=OFF
			-DSDLIMAGE_TESTS=$(usex test)
			-DSDLIMAGE_VENDORED=OFF # Use system libraries instead of vendored ones; defualt but let's be explicit
			-DSDLIMAGE_BACKEND_STB=$(usex stb)	# jpeg and png file support via stb_image; vendored, despite above
												# likely less performant than using native libraries, less deps.
			# formats
			-DSDLIMAGE_AVIF=$(usex avif)
			-DSDLIMAGE_AVIF_SAVE=$(usex avif)
			-DSDLIMAGE_BMP=ON
			-DSDLIMAGE_GIF=$(usex gif)
			-DSDLIMAGE_JPG=$(usex jpeg)
			-DSDLIMAGE_JPG_SAVE=$(usex jpeg)
			-DSDLIMAGE_JXL=$(usex jpegxl)
			-DSDLIMAGE_LBM=ON
			-DSDLIMAGE_PCX=ON
			-DSDLIMAGE_PNG=$(usex png)
			-DSDLIMAGE_PNG_SAVE=$(usex png)
			-DSDLIMAGE_PNM=ON
			-DSDLIMAGE_QOI=ON
			-DSDLIMAGE_SVG=ON
			-DSDLIMAGE_TGA=ON
			-DSDLIMAGE_TIF=$(usex tiff)
			-DSDLIMAGE_WEBP=$(usex webp)
			-DSDLIMAGE_XCF=ON
			-DSDLIMAGE_XPM=ON
			-DSDLIMAGE_XV=ON
		)
		if [[ "${MULTIBUILD_VARIANT}" == "shared-libs" ]]; then
			mycmakeargs+=( -DBUILD_SHARED_LIBS=ON )
			local is_shared=1
		else
			mycmakeargs+=(
				-DBUILD_SHARED_LIBS=OFF
				-DSDLIMAGE_SAMPLES=OFF
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
	# These are only asserts that the formats are supported. They do not test
	# that the formats are actually working. It is advisable to run a game or
	# application that uses SDL_image to sanity check common formats.

	# https://github.com/libsdl-org/SDL_image/tree/main/test#asserting-format-support
	# Match same order as src_configure. The intent is to catch build system
	# bugs, so it may need updating sometimes for legitimate changes in
	# SDL_image support.
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
