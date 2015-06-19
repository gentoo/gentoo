# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-embedded/libftdi/libftdi-0.18.ebuild,v 1.2 2010/09/09 18:04:18 vapier Exp $

EAPI="2"

if [[ ${PV} == 9999* ]] ; then
	EGIT_REPO_URI="git://developer.intra2net.com/libftdi"
	inherit git autotools
else
	SRC_URI="http://www.intra2net.com/en/developer/libftdi/download/${P}.tar.gz"
	KEYWORDS="amd64 ppc ppc64 sparc x86"
fi

DESCRIPTION="Userspace access to FTDI USB interface chips"
HOMEPAGE="http://www.intra2net.com/en/developer/libftdi/"

LICENSE="LGPL-2"
SLOT="0"
IUSE="cxx doc examples python"

RDEPEND="virtual/libusb:0
	cxx? ( dev-libs/boost )
	python? ( dev-lang/python )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

src_prepare() {
	if [[ ${PV} == 9999* ]] ; then
		mkdir -p m4
		eautoreconf
	fi
}

src_configure() {
	econf \
		$(use_enable cxx libftdipp) \
		$(use_with doc docs) \
		$(use_with examples) \
		$(use_enable python python-binding)
}

src_install() {
	emake DESTDIR="${D}" install || die
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
