# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="The DICOM Toolkit"
HOMEPAGE="https://dicom.offis.de/dcmtk.php.en"
SRC_URI="https://dicom.offis.de/download/dcmtk/release/${P}.tar.gz"

LICENSE="OFFIS"
KEYWORDS="~amd64 ~arm ~ppc64 ~x86"
SLOT="0"
IUSE="doc png ssl tcpd tiff +threads xml zlib"

RDEPEND="
	dev-libs/icu:=
	virtual/jpeg:0
	png? ( media-libs/libpng:* )
	ssl? ( dev-libs/openssl:0= )
	tcpd? ( sys-apps/tcp-wrappers )
	tiff? ( media-libs/tiff:0 )
	xml? ( dev-libs/libxml2:2 )
	zlib? ( sys-libs/zlib )
"
DEPEND="${RDEPEND}
	media-gfx/graphviz
"
BDEPEND="doc? ( app-doc/doxygen )"

src_prepare() {
	cmake_src_prepare

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
		"${S}"/CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_SYSCONFDIR="${EROOT}/etc"
		-DDCMTK_WITH_ICU=ON
		-DDCMTK_WITH_TIFF=$(usex tiff)
		-DDCMTK_WITH_PNG=$(usex png)
		-DDCMTK_WITH_XML=$(usex xml)
		-DDCMTK_WITH_ZLIB=$(usex zlib)
		-DDCMTK_WITH_OPENSSL=$(usex ssl)
		-DDCMTK_WITH_DOXYGEN=$(usex doc)
		-DDCMTK_WITH_THREADS=$(usex threads)
	)

	cmake_src_configure

	if use doc; then
		cd "${S}"/doxygen || die
		econf
	fi
}

src_compile() {
	cmake_src_compile

	if use doc; then
		emake -C "${S}"/doxygen
	fi
}

src_install() {
	doman doxygen/manpages/man1/*

	if use doc; then
		local HTML_DOCS=( "${S}"/doxygen/htmldocs/. )
	fi
	cmake_src_install
}
