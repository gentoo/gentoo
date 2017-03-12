# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PYTHON_COMPAT=( python2_7 python3_{3,4,5} )

inherit python-single-r1

SRC_URI="http://www.intra2net.com/en/developer/${PN}/download/${P}.tar.gz"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~sparc ~x86"

DESCRIPTION="Userspace access to FTDI USB interface chips"
HOMEPAGE="http://www.intra2net.com/en/developer/libftdi/"

LICENSE="LGPL-2"
SLOT="0"
IUSE="cxx doc examples python static-libs"

RDEPEND="virtual/libusb:0
	cxx? ( dev-libs/boost )
	python? ( ${PYTHON_DEPS} )"

DEPEND="${RDEPEND}
	python? ( dev-lang/swig )
	doc? ( app-doc/doxygen )"

src_configure() {
	econf \
		$(use_enable cxx libftdipp) \
		$(use_with doc docs) \
		$(use_with examples) \
		$(use_enable python python-binding) \
		$(use_enable static-libs static)
}

src_install() {
	emake DESTDIR="${D}" install || die
	use static-libs || find "${D}" -name '*.la' -delete
	dodoc ChangeLog README

	if use doc ; then
		doman doc/man/man3/*
		dohtml doc/html/*
	fi
	if use examples ; then
		docinto examples
		dodoc examples/*.c
	fi
}
