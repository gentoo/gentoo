# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit multilib cmake-multilib

DESCRIPTION="An open-source JPEG 2000 library"
HOMEPAGE="http://www.openjpeg.org"
SRC_URI="mirror://sourceforge/${PN}.mirror/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0/5" # based on SONAME
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="doc static-libs test"

RDEPEND="media-libs/lcms:2=
	media-libs/libpng:0=
	media-libs/tiff:0=
	sys-libs/zlib:="
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

DOCS=( AUTHORS CHANGES NEWS README THANKS )

RESTRICT="test" #409263

src_prepare() {
	cmake-utils_src_prepare
	# Stop installing LICENSE file, and install CHANGES from DOCS instead:
	sed -i -e '/INSTALL.*FILES.*DESTINATION.*OPENJPEG_INSTALL_DOC_DIR/d' CMakeLists.txt || die
}

multilib_src_configure() {
	local mycmakeargs=(
		-DOPENJPEG_INSTALL_LIB_DIR="$(get_libdir)"
		$(cmake-utils_use_build test TESTING)
		-DBUILD_DOC=$(multilib_native_usex doc ON OFF)
		-DBUILD_CODEC=$(multilib_is_native_abi && echo ON || echo OFF)
		)

	cmake-utils_src_configure

	if use static-libs; then
		mycmakeargs=(
			-DOPENJPEG_INSTALL_LIB_DIR="$(get_libdir)"
			$(cmake-utils_use_build test TESTING)
			-DBUILD_SHARED_LIBS=OFF
			-DBUILD_CODEC=OFF
			)
		BUILD_DIR=${BUILD_DIR}_static cmake-utils_src_configure
	fi
}

multilib_src_compile() {
	cmake-utils_src_compile

	if use static-libs; then
		BUILD_DIR=${BUILD_DIR}_static cmake-utils_src_compile
	fi
}

multilib_src_install() {
	if use static-libs; then
		BUILD_DIR=${BUILD_DIR}_static cmake-utils_src_install
	fi

	cmake-utils_src_install

	dosym openjpeg-1.5/openjpeg.h /usr/include/openjpeg.h
	dosym libopenjpeg1.pc /usr/$(get_libdir)/pkgconfig/libopenjpeg.pc

	if use doc && multilib_is_native_abi; then
		dodoc -r doc/html
	fi
}
