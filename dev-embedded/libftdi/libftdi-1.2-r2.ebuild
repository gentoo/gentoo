# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit cmake-utils python-single-r1

MY_P="${PN}1-${PV}"
SRC_URI="http://www.intra2net.com/en/developer/${PN}/download/${MY_P}.tar.bz2"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 ~sparc ~x86"

DESCRIPTION="Userspace access to FTDI USB interface chips"
HOMEPAGE="http://www.intra2net.com/en/developer/libftdi/"

LICENSE="LGPL-2"
SLOT="1"
IUSE="cxx doc examples python static-libs tools"

RDEPEND="virtual/libusb:1
	cxx? ( dev-libs/boost )
	python? ( ${PYTHON_DEPS} )
	tools? (
		!<dev-embedded/ftdi_eeprom-1.0
		dev-libs/confuse
	)"
DEPEND="${RDEPEND}
	python? ( dev-lang/swig )
	doc? ( app-doc/doxygen )"

S=${WORKDIR}/${MY_P}

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use cxx FTDIPP)
		$(cmake-utils_use doc DOCUMENTATION)
		$(cmake-utils_use examples EXAMPLES)
		$(cmake-utils_use python PYTHON_BINDINGS)
		$(cmake-utils_use static-libs STATICLIBS)
		$(cmake-utils_use tools FTDI_EEPROM)
		-DCMAKE_SKIP_BUILD_RPATH=ON
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	dodoc AUTHORS ChangeLog README TODO

	if use doc ; then
		# Clean up crap man pages. #356369
		rm -vf "${CMAKE_BUILD_DIR}"/doc/man/man3/_* || die

		doman "${CMAKE_BUILD_DIR}"/doc/man/man3/*
		dohtml "${CMAKE_BUILD_DIR}"/doc/html/*
	fi
	if use examples ; then
		docinto examples
		dodoc examples/*.c
	fi
}
