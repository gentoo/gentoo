# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="PoDoFo is a C++ library to work with the PDF file format"
HOMEPAGE="https://github.com/podofo/podofo"
# testsuite resources require separate download. Reported at https://github.com/podofo/podofo/issues/102
SRC_URI="https://github.com/podofo/podofo/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/podofo/podofo/commit/5f4df41c552cb2357ff6fefdbe277b072a4c1c4a.patch -> ${P}-libxml2-2.12.patch
	test? (
		https://github.com/podofo/podofo-resources/archive/4afe5c3fdb543a4347681b2e52252f1b10f12f24.tar.gz
			-> podofo-0.10.1-test-resources.tar.gz
	)
"

LICENSE="LGPL-2+ tools? ( GPL-2+ )"
SLOT="0/2"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE="idn jpeg tiff png fontconfig test tools"
RESTRICT="!test? ( test )"

RDEPEND="
	idn? ( net-dns/libidn:= )
	dev-libs/openssl:=
	fontconfig? ( media-libs/fontconfig:= )
	media-libs/freetype:2=
	jpeg? ( media-libs/libjpeg-turbo:= )
	png? ( media-libs/libpng:= )
	dev-libs/libxml2
	tiff? ( media-libs/tiff:= )
	sys-libs/zlib:="
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	test? ( fontconfig? ( media-fonts/liberation-fonts ) )
"

PATCHES=("${DISTDIR}/${P}-libxml2-2.12.patch")

src_prepare() {
	cmake_src_prepare
	if use test; then
		rmdir extern/resources || die
		mv "${WORKDIR}"/podofo-resources-4afe5c3fdb543a4347681b2e52252f1b10f12f24 extern/resources || die
	fi
}

src_configure() {
	local mycmakeargs=(
		-DPODOFO_BUILD_TEST=$(usex test ON OFF)
		-DPODOFO_BUILD_TOOLS=$(usex tools ON OFF)
		$(cmake_use_find_package idn Libidn)
		$(cmake_use_find_package jpeg JPEG)
		$(cmake_use_find_package tiff TIFF)
		$(cmake_use_find_package png PNG)
		$(cmake_use_find_package fontconfig Fontconfig)
	)

	cmake_src_configure
}

src_test() {
	local CMAKE_SKIP_TESTS=(
		$(usev !png 'TestImage3')
		$(usev !jpeg 'TestImage2 TestImage4 TestImage5')
		# relies on finding arial font
		$(usev !fontconfig 'testLoadEncrypedFilePdfMemDocument testLoadEncrypedFilePdfParser testCyclicTree testNestedArrayTree testEmptyKidsTree testNestedArrayTree testCreateDelete')
	)

	cmake_src_test
}
