# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit cmake-utils python-single-r1 eutils

SRC_URI="http://www.intra2net.com/en/developer/${PN}/download/${P}.tar.gz"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~sparc ~x86"

DESCRIPTION="Userspace access to FTDI USB interface chips"
HOMEPAGE="http://www.intra2net.com/en/developer/libftdi/"

LICENSE="LGPL-2"
SLOT="0"
IUSE="cxx doc examples python"

RDEPEND="virtual/libusb:0
	cxx? ( dev-libs/boost )
	python? ( ${PYTHON_DEPS} )"

DEPEND="${RDEPEND}
	python? ( dev-lang/swig )
	doc? ( app-doc/doxygen )"

src_prepare() {
	sed -i \
		-e "s:[$]{PYTHON_LIB_INSTALL}/../site-packages:$(python_get_sitedir):" \
		bindings/CMakeLists.txt || die
	sed -i \
		-e '/SET(LIB_SUFFIX /d' \
		CMakeLists.txt || die

	epatch "${FILESDIR}"/${P}-cmake-{include,version}.patch
}

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use cxx FTDIPP)
		$(cmake-utils_use doc DOCUMENTATION)
		$(cmake-utils_use examples EXAMPLES)
		$(cmake-utils_use python PYTHON_BINDINGS)
		-DCMAKE_SKIP_BUILD_RPATH=ON
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	dodoc ChangeLog README

	if use doc ; then
		# Clean up crap man pages. #356369
		rm -vf "${CMAKE_BUILD_DIR}"/doc/man/man3/{_,usb_,deprecated}*

		doman "${CMAKE_BUILD_DIR}"/doc/man/man3/*
		dohtml "${CMAKE_BUILD_DIR}"/doc/html/*
	fi
	if use examples ; then
		docinto examples
		dodoc examples/*.c
	fi
}
