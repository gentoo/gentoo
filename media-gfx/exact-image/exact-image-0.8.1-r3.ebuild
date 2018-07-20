# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit eutils multilib python-single-r1 toolchain-funcs

DESCRIPTION="A fast, modern and generic image processing library"
HOMEPAGE="http://www.exactcode.de/site/open_source/exactimage/"
SRC_URI="http://dl.exactcode.de/oss/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="expat jpeg jpeg2k lua openexr php perl png python ruby swig tiff truetype X"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="x11-libs/agg[truetype]
	sys-libs/zlib
	expat? ( dev-libs/expat )
	jpeg2k? ( media-libs/jasper )
	jpeg? ( virtual/jpeg )
	lua? ( dev-lang/lua )
	openexr? ( media-libs/openexr )
	php? ( dev-lang/php )
	perl? ( dev-lang/perl )
	png? ( >=media-libs/libpng-1.2.43 )
	python? ( ${PYTHON_DEPS} )
	ruby? ( dev-lang/ruby )
	tiff? ( media-libs/tiff )
	truetype? ( >=media-libs/freetype-2 )
	X? (
		x11-libs/libXext
		x11-libs/libXt
		x11-libs/libICE
		x11-libs/libSM
	)"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	swig? ( dev-lang/swig )"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	eapply \
		"${FILESDIR}"/${PN}-0.7.5-libpng14.patch \
		"${FILESDIR}"/${P}-libpng15.patch \
		"${FILESDIR}"/${P}-gcc6.patch
	eapply_user

	# fix python hardcoded path wrt bug #327171
	sed -i -e "s:python2.5:${EPYTHON}:" \
		-e "s:\$(libdir):usr/$(get_libdir):" \
		"${S}"/api/python/Makefile || die

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
}

src_configure() {
	# evas -> enlightenment overlay
	# bardecode -> protected by custom license
	# libungif -> not supported anymore

	./configure \
		--prefix=/usr \
		--libdir=/usr/$(get_libdir) \
		$(use_with X x11) \
		$(use_with truetype freetype) \
		--without-evas \
		$(use_with jpeg libjpeg) \
		$(use_with tiff libtiff) \
		$(use_with png libpng) \
		--without-libungif \
		$(use_with jpeg2k jasper) \
		$(use_with openexr) \
		$(use_with expat) \
		--without-lcms \
		--without-bardecode \
		$(use_with lua) \
		$(use_with swig) \
		$(use_with perl) \
		$(use_with python) \
		$(use_with php) \
		$(use_with ruby) || die
}
