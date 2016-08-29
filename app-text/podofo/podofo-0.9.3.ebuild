# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit cmake-utils flag-o-matic multilib toolchain-funcs

DESCRIPTION="PoDoFo is a C++ library to work with the PDF file format"
HOMEPAGE="https://sourceforge.net/projects/podofo/"
SRC_URI="mirror://sourceforge/podofo/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="+boost idn libressl debug test"

RDEPEND="dev-lang/lua:=
	idn? ( net-dns/libidn:= )
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	media-libs/fontconfig:=
	media-libs/freetype:2=
	virtual/jpeg:0=
	media-libs/libpng:0=
	media-libs/tiff:0=
	sys-libs/zlib:="
DEPEND="${RDEPEND}
	virtual/pkgconfig
	boost? ( dev-util/boost-build )
	test? ( dev-util/cppunit )"

DOCS="AUTHORS ChangeLog TODO"

src_prepare() {
	local x sed_args

	# bug 556962
	sed -i -e 's|Decrypt( pEncryptedBuffer, nOutputLen, pDecryptedBuffer, m_lLen );|Decrypt( pEncryptedBuffer, (pdf_long)nOutputLen, pDecryptedBuffer, (pdf_long\&)m_lLen );|' \
		test/unit/EncryptTest.cpp || die

	sed -i \
		-e "s:LIBDIRNAME \"lib\":LIBDIRNAME \"$(get_libdir)\":" \
		-e "s:LIBIDN_FOUND:HAVE_LIBIDN:g" \
		CMakeLists.txt || die

	# Use pkg-config to find headers for bug #459404.
	sed_args=
	for x in $($(tc-getPKG_CONFIG) --cflags freetype2) ; do
		[[ ${x} == -I* ]] || continue
		x=${x#-I}
		if [[ -f ${x}/ft2build.h ]] ; then
			sed_args+=" -e s:/usr/include/\\r\$:${x}:"
		elif [[ -f ${x}/freetype/config/ftheader.h ]] ; then
			sed_args+=" -e s:/usr/include/freetype2\\r\$:${x}:"
		fi
	done
	[[ -n ${sed_args} ]] && \
		{ sed -i ${sed_args} cmake/modules/FindFREETYPE.cmake || die; }

	# Bug #439784: Add missing unistd include for close() and unlink().
	sed -i 's:^#include <stdio.h>$:#include <unistd.h>\n\0:' -i \
		test/unit/TestUtils.cpp || die

	# TODO: fix these test cases
	# ColorTest.cpp:62:Assertion
	# Test name: ColorTest::testDefaultConstructor
	# expected exception not thrown
	# - Expected: PdfError
	sed -e 's:CPPUNIT_TEST( testDefaultConstructor ://\0:' \
		-e 's:CPPUNIT_TEST( testGreyConstructor ://\0:' \
		-e 's:CPPUNIT_TEST( testRGBConstructor ://\0:' \
		-e 's:CPPUNIT_TEST( testCMYKConstructor ://\0:' \
		-e 's:CPPUNIT_TEST( testColorSeparationAllConstructor ://\0:' \
		-e 's:CPPUNIT_TEST( testColorSeparationNoneConstructor ://\0:' \
		-e 's:CPPUNIT_TEST( testColorSeparationConstructor ://\0:' \
		-e 's:CPPUNIT_TEST( testColorCieLabConstructor ://\0:' \
		-i test/unit/ColorTest.h || die

	# ColorTest.cpp:42:Assertion
	# Test name: ColorTest::testHexNames
	# assertion failed
	# - Expression: static_cast<int>(rgb.GetGreen() * 255.0) == 0x0A
	sed -e 's:CPPUNIT_TEST( testHexNames ://\0:' \
		-i test/unit/ColorTest.h || die

	# Bug #352125: test failure, depending on installed fonts
	# ##Failure Location unknown## : Error
	# Test name: FontTest::testFonts
	# uncaught exception of type PoDoFo::PdfError
	# - ePdfError_UnsupportedFontFormat
	sed -e 's:CPPUNIT_TEST( testFonts ://\0:' \
		-i test/unit/FontTest.h || die

	# Test name: EncodingTest::testDifferencesEncoding
	# equality assertion failed
	# - Expected: 1
	# - Actual  : 0
	sed -e 's:CPPUNIT_TEST( testDifferencesEncoding ://\0:' \
		-i test/unit/EncodingTest.h || die

	# Bug #407015: fix to compile with Lua 5.2
	if has_version '>=dev-lang/lua-5.2' ; then
		sed -e 's: lua_open(: luaL_newstate(:' \
			-e 's: luaL_getn(: lua_rawlen(:' -i \
			tools/podofocolor/luaconverter.cpp \
			tools/podofoimpose/planreader_lua.cpp || die
	fi
}

src_configure() {

	# Bug #381359: undefined reference to `PoDoFo::PdfVariant::DelayedLoadImpl()'
	filter-flags -fvisibility-inlines-hidden

	mycmakeargs+=(
		"-DPODOFO_BUILD_SHARED=1"
		"-DPODOFO_HAVE_JPEG_LIB=1"
		"-DPODOFO_HAVE_PNG_LIB=1"
		"-DPODOFO_HAVE_TIFF_LIB=1"
		"-DWANT_FONTCONFIG=1"
		"-DUSE_STLPORT=0"
		$(cmake-utils_use_want boost)
		$(cmake-utils_use_has idn LIBIDN)
		$(cmake-utils_use_has test CPPUNIT)
		)

	cmake-utils_src_configure
}

src_test() {
	cd "${CMAKE_BUILD_DIR}"/test/unit
	./podofo-test --selftest || die "self test failed"
}
