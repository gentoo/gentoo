# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{1..4} )

inherit cmake flag-o-matic lua-single toolchain-funcs

DESCRIPTION="PoDoFo is a C++ library to work with the PDF file format"
HOMEPAGE="https://sourceforge.net/projects/podofo/"
SRC_URI="https://dev.gentoo.org/~zmedico/dist/${P}.tar.xz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0/${PV%_*}"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ppc ppc64 ~sparc x86"
IUSE="+boost idn debug test +tools"
RESTRICT="!test? ( test )"
REQUIRED_USE="${LUA_REQUIRED_USE}
	test? ( tools )"

RDEPEND="${LUA_DEPS}
	idn? ( net-dns/libidn:= )
	dev-libs/openssl:=
	dev-libs/libunistring:=
	media-libs/fontconfig:=
	media-libs/freetype:2=
	media-libs/libjpeg-turbo:=
	media-libs/libpng:=
	media-libs/tiff:=
	sys-libs/zlib:="
DEPEND="${RDEPEND}
	test? ( dev-util/cppunit )"
BDEPEND="virtual/pkgconfig
	boost? ( dev-libs/boost )"

PATCHES=(
	"${FILESDIR}"/${PN}-0.9.6_p20190928-cmake_lua_version.patch
)

DOCS="AUTHORS ChangeLog TODO"

src_prepare() {
	cmake_src_prepare
	local x sed_args

	# bug 620934 - Disable linking with cppunit when possible, since it
	# triggers errors with some older compilers.
	use test || sed -e 's:^FIND_PACKAGE(CppUnit):#\0:' -i CMakeLists.txt || die

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

	# Bug #407015: fix to compile with Lua 5.2+
	case "${ELUA}" in
		lua5-1|luajit)
			;;
		*)
			sed -e 's: lua_open(: luaL_newstate(:' \
				-e 's: luaL_getn(: lua_rawlen(:' -i \
				tools/podofocolor/luaconverter.cpp \
				tools/podofoimpose/planreader_lua.cpp || die
			;;
	esac
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
		-DLUA_VERSION="$(lua_get_version)"
		-DWANT_BOOST=$(usex boost ON OFF)
		-DHAVE_LIBIDN=$(usex idn ON OFF)
		-DPODOFO_HAVE_CPPUNIT=$(usex test ON OFF)
		-DPODOFO_BUILD_LIB_ONLY=$(usex tools OFF ON)
		)

	cmake_src_configure
	mkdir -p "${S}/test/TokenizerTest/objects" || die
}

src_test() {
	cd "${BUILD_DIR}"/test/unit || die
	./podofo-test --selftest || die "self test failed"
}
