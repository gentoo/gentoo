# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{1..4} luajit )

inherit lua-single toolchain-funcs

DESCRIPTION="A fast, modern and generic image processing library"
HOMEPAGE="https://exactcode.com/opensource/exactimage/"
SRC_URI="http://dl.exactcode.de/oss/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="expat jpeg lua openexr perl png ruby swig tiff truetype X"
REQUIRED_USE="lua? ( swig ) perl? ( swig ) ruby? ( swig )"
# Tests are broken; 'make check' fails and referenced testsuite dir not found
RESTRICT="test"

RDEPEND="
	x11-libs/agg[truetype]
	sys-libs/zlib
	expat? ( dev-libs/expat )
	jpeg? ( media-libs/libjpeg-turbo:= )
	lua? ( ${LUA_DEPS} )
	openexr? ( media-libs/openexr:= )
	perl? ( dev-lang/perl )
	png? ( >=media-libs/libpng-1.2.43 )
	ruby? ( dev-lang/ruby:* )
	tiff? ( media-libs/tiff:= )
	truetype? ( >=media-libs/freetype-2 )
	X? (
		x11-libs/libXext
		x11-libs/libXt
		x11-libs/libICE
		x11-libs/libSM
	)"
DEPEND="
	${RDEPEND}
	swig? ( dev-lang/swig )
"

BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-gcc6.patch
	"${FILESDIR}"/${P}-g++.patch
	"${FILESDIR}"/${P}-dcraw.patch
)

src_prepare() {
	default

	# Respect user CFLAGS/CXXFLAGS.
	sed -i \
		-e '/C\(XX\)\?FLAGS =/s/-O2//' \
		-e "\$aCFLAGS += ${CFLAGS}\nCXXFLAGS += ${CXXFLAGS}" \
		Makefile || die

	# Show commands.  Use qualified CC/CXX.
	sed -i \
		-e '/^Q =/d' \
		-e '/^\t@echo /d' \
		-e "\$aCC:=$(tc-getCC)\nCXX:=$(tc-getCXX)" \
		build/bottom.make || die

	# The copied string fits exactly.  Use memcpy to reflect that a null
	# terminator is not needed.
	sed -i \
		-e 's/strcpy(\([^,]*\)\(,["a-zA-Z -]*\))/memcpy(\1\2, sizeof(\1))/' \
		codecs/tga.cc || die

	# openexr vers 3
	sed -i \
		-e 's:Int64:uint64_t:g' \
		codecs/openexr.cc || die
}

src_configure() {
	# evas -> enlightenment overlay
	# bardecode -> protected by custom license
	# libungif -> not supported anymore
	# python -> allegedly not python3, but python2 only

	./configure \
		--prefix=/usr \
		--libdir=/usr/$(get_libdir) \
		$(use_with X x11) \
		$(use_with truetype freetype) \
		--without-evas \
		$(use_with jpeg libjpeg) \
		$(use_with tiff libtiff) \
		$(use_with png libpng) \
		--without-libgif \
		--without-jasper \
		$(use_with openexr) \
		$(use_with expat) \
		--without-lcms \
		--without-bardecode \
		$(use_with lua) \
		$(use_with swig) \
		$(use_with perl) \
		--without-python \
		--without-php \
		$(use_with ruby) || die
}
