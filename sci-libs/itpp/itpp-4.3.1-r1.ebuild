# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils multilib

DESCRIPTION="C++ library of mathematical, signal processing and communication"
HOMEPAGE="http://itpp.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

SLOT="0"
LICENSE="GPL-3"
KEYWORDS="amd64 ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="doc"

RDEPEND="
	virtual/blas
	virtual/lapack
	>=sci-libs/fftw-3"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen virtual/latex-base )"

DOCS=(ChangeLog NEWS AUTHORS README)

src_prepare() {
	# gentoo redefines the CMAKE_BUILD_TYPE
	sed -i \
		-e 's/CMAKE_BUILD_TYPE STREQUAL Release/NOT CMAKE_BUILD_TYPE STREQUAL Debug/' \
		CMakeLists.txt || die
	# respect gentoo doc dir
	sed -i \
		-e "s:share/doc/itpp:share/doc/${PF}:" \
		itpp/CMakeLists.txt || die

	# respect gentoo libdir
	sed -i "s#/lib#/$(get_libdir)#" itpp-config.cmake.in
	sed -i "s#/lib#/$(get_libdir)#" itpp.pc.cmake.in
	sed -i \
		-e "s#LIBRARY DESTINATION lib#LIBRARY DESTINATION $(get_libdir)#" \
		-e "s#ARCHIVE DESTINATION lib#ARCHIVE DESTINATION $(get_libdir)#" \
		itpp/CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DBLA_VENDOR=Generic
		$(cmake-utils_use doc HTML_DOCS)
	)
	cmake-utils_src_configure
}
