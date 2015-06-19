# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-embedded/libftdi/libftdi-0.17.ebuild,v 1.3 2010/06/22 20:27:28 vapier Exp $

EAPI="2"

DESCRIPTION="Userspace access to FTDI USB interface chips"
HOMEPAGE="http://www.intra2net.com/en/developer/libftdi/"
SRC_URI="http://www.intra2net.com/en/developer/libftdi/download/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86"
IUSE="cxx doc examples python"

RDEPEND="virtual/libusb:0
	cxx? ( dev-libs/boost )
	python? ( dev-lang/python )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

src_prepare() {
	# don't bother building examples as we dont want the binaries
	# installed and the Makefile has broken install targets
	sed -i '/^SUBDIRS =/s:examples::' Makefile.in
	sed -i 's:@top_buildir@:@top_builddir@:' bindings/python/setup.py.in #298607
}

src_configure() {
	use doc || export ac_cv_path_DOXYGEN=true
	econf \
		$(use_enable cxx libftdipp) \
		$(use_enable python python-binding)
}

src_install() {
	emake DESTDIR="${D}" install || die "Installation failed"
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
