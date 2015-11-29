# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit cmake-utils eutils

DESCRIPTION="The DICOM Toolkit"
HOMEPAGE="http://dicom.offis.de/dcmtk.php.en"
SRC_URI="ftp://dicom.offis.de/pub/dicom/offis/software/dcmtk/dcmtk360/${P}.tar.gz"

LICENSE="OFFIS"
KEYWORDS="~amd64 ~arm ~x86"
SLOT="0"
IUSE="doc png ssl tcpd tiff +threads xml zlib"

RDEPEND="
	virtual/jpeg:0
	png? ( media-libs/libpng:* )
	ssl? ( dev-libs/openssl:0 )
	tcpd? ( sys-apps/tcp-wrappers )
	tiff? ( media-libs/tiff:0 )
	xml? ( dev-libs/libxml2:2 )
	zlib? ( sys-libs/zlib )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	media-gfx/graphviz"

src_prepare() {

	epatch \
		"${FILESDIR}"/01_fix_perl_script_path.patch \
		"${FILESDIR}"/02_dcmtk_3.6.0-1.patch \
		"${FILESDIR}"/04_nostrip.patch \
		"${FILESDIR}"/dcmtk_version_number.patch \
		"${FILESDIR}"/png_tiff.patch \
		"${FILESDIR}"/regression_stacksequenceisodd.patch \
		"${FILESDIR}"/${PN}-asneeded.patch \
		"${FILESDIR}"/${PN}-gcc472-error.patch

	sed -e "s:share/doc/dcmtk:&-${PV}:" \
		-e "s:DIR \"/:DIR \"/usr/:" \
		-e "s:usr/etc:etc:" \
		-e "s:/lib\":/$(get_libdir)\":" \
		-e "s:COPYRIGHT::" \
		-i CMakeLists.txt || die
	sed -e 's:${CMAKE_INSTALL_PREFIX}/::' \
		-i dcmwlm/data/CMakeLists.txt doxygen/CMakeLists.txt || die
	# Temporary workaround: docs are not built with CMake
	sed -i -e '/include/d' doxygen/Makefile.in || die

	# fix -D deprecation warnings
	sed -i -e "s|_BSD_SOURCE|_DEFAULT_SOURCE|g" \
		"${S}"/config/configure.in \
		"${S}"/CMakeLists.txt
}

src_configure() {
	mycmakeargs="${mycmakeargs}
		-DBUILD_SHARED_LIBS=ON
		-DCMAKE_INSTALL_PREFIX=/
		$(cmake-utils_use tiff DCMTK_WITH_TIFF)
		$(cmake-utils_use png DCMTK_WITH_PNG)
		$(cmake-utils_use xml DCMTK_WITH_XML)
		$(cmake-utils_use zlib DCMTK_WITH_ZLIB)
		$(cmake-utils_use ssl DCMTK_WITH_OPENSSL)
		$(cmake-utils_use doc DCMTK_WITH_DOXYGEN)
		$(cmake-utils_use threads DCMTK_WITH_THREADS)"

	cmake-utils_src_configure

	if use doc; then
		cd "${S}"/doxygen
		econf
	fi
}

src_compile() {
	cmake-utils_src_compile

	if use doc; then
		emake -C "${S}"/doxygen || die
	fi
}

src_install() {
	cmake-utils_src_install

	doman doxygen/manpages/man1/* || die

	if use doc; then
		dohtml -r "${S}"/doxygen/htmldocs/* || die
	fi
}
