# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="PoDoFo is a C++ library to work with the PDF file format"
HOMEPAGE="https://github.com/podofo/podofo"
# The extern/resources submodule pinned by the 1.1.2 release.
PODOFO_TEST_RESOURCES_COMMIT=f3e6e289db3cb7fe0a1a21e65430f221fe598882
# Testsuite resources require a separate download: https://github.com/podofo/podofo/issues/102
SRC_URI="https://github.com/podofo/podofo/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
	test? (
		https://github.com/podofo/podofo-resources/archive/${PODOFO_TEST_RESOURCES_COMMIT}.tar.gz
			-> ${P}-test-resources.tar.gz
	)
"

LICENSE="|| ( LGPL-2+ MPL-2.0 ) Apache-2.0 BSD Boost-1.0 MIT tools? ( GPL-2+ )"
# PODOFO_SOVERSION in PoDoFoVersion.cmake.
SLOT="0/4"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="fontconfig jpeg png test tiff tools"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/libxml2:=
	dev-libs/openssl:=
	media-libs/freetype:2=
	virtual/zlib:=
	fontconfig? ( media-libs/fontconfig:= )
	jpeg? ( media-libs/libjpeg-turbo:= )
	png? ( media-libs/libpng:= )
	tiff? ( media-libs/tiff:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	test? ( fontconfig? ( media-fonts/liberation-fonts ) )
"

DOCS=( README.md NOTICE )

PATCHES=(
	"${FILESDIR}/${P}-fmt-uint128.patch"
	"${FILESDIR}/${P}-test-output.patch"
)

src_prepare() {
	if use test; then
		rmdir extern/resources || die
		mv "${WORKDIR}/podofo-resources-${PODOFO_TEST_RESOURCES_COMMIT}" extern/resources || die
	fi

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_Doxygen=ON
		-DPODOFO_BUILD_EXAMPLES=OFF
		-DPODOFO_BUILD_STATIC=OFF
		-DPODOFO_BUILD_TEST=$(usex test ON OFF)
		-DPODOFO_BUILD_UNSUPPORTED_TOOLS=$(usex tools ON OFF)
		-DPODOFO_WITH_FONTMANAGER=$(usex fontconfig ON OFF)
		-DPODOFO_WITH_LCMS2=OFF
		$(cmake_use_find_package jpeg JPEG)
		$(cmake_use_find_package png PNG)
		$(cmake_use_find_package tiff TIFF)
	)

	cmake_src_configure
}

src_test() {
	local CMAKE_SKIP_TESTS=(
		# TestSaveOnSigning loads ReferenceImage.png for the signature appearance.
		$(usev !png '^TestImage3$ ^TestSaveOnSigning$')
		$(usev !jpeg '^TestImage(2|4|5)$')
		$(usev !tiff '^TestImage(7|8)$')
	)

	if ! use fontconfig; then
		# These tests search for system fonts by name.
		CMAKE_SKIP_TESTS+=(
			'^TestLoadEncrypedFilePdfMemDocument$'
			'^TestLoadEncrypedFilePdfParser$'
			'^TestCreateDelete$'
			'^TestDrawTextMultipleTimes$'
			'^TestEmbedFont$'
		)
	fi

	cmake_src_test
}
