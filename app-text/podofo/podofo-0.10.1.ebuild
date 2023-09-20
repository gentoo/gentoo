# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="PoDoFo is a C++ library to work with the PDF file format"
HOMEPAGE="https://github.com/podofo/podofo"
# testsuite resources require separate download. Reported at https://github.com/podofo/podofo/issues/102
SRC_URI="https://github.com/podofo/podofo/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
	test? (
		https://github.com/podofo/podofo-resources/archive/4afe5c3fdb543a4347681b2e52252f1b10f12f24.tar.gz
			-> ${P}-test-resources.tar.gz
	)
"

LICENSE="LGPL-2+ tools? ( GPL-2+ )"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="fontconfig idn jpeg png tiff test +tools"
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
BDEPEND="virtual/pkgconfig"

src_prepare() {
	cmake_src_prepare
	if use test; then
		rmdir extern/resources || die
		mv "${WORKDIR}"/podofo-resources-4afe5c3fdb543a4347681b2e52252f1b10f12f24 extern/resources || die

		sed -i -e 's|TEST_CASE("testLoadEncrypedFilePdfParser")|void testLoadEncrypedFilePdfParser()|' \
			-e 's|TEST_CASE("testLoadEncrypedFilePdfMemDocument")|void testLoadEncrypedFilePdfMemDocument()|' \
			test/unit/EncryptTest.cpp || die
		sed -i -e 's|TEST_CASE("testCyclicTree")|void testCyclicTree()|' \
			-e 's|TEST_CASE("testEmptyKidsTree")|void testEmptyKidsTree()|' \
			-e 's|TEST_CASE("testNestedArrayTree")|void testNestedArrayTree()|' \
			-e 's|TEST_CASE("testCreateDelete")|void testCreateDelete()|' \
			test/unit/PageTreeTest.cpp || die
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
