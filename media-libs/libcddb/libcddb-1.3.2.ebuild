# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit libtool

DESCRIPTION="A library for accessing a CDDB server"
HOMEPAGE="http://libcddb.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="doc static-libs"

RDEPEND="virtual/libiconv"
DEPEND="doc? ( app-doc/doxygen )"

RESTRICT="test"

DOCS="AUTHORS ChangeLog NEWS README THANKS TODO"

src_prepare() {
	elibtoolize # Sanitizing .so version for FreeBSD
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		--without-cdio
}

src_compile() {
	default

	if use doc; then
		cd doc
		doxygen doxygen.conf || die
	fi
}

src_install() {
	default

	rm -f "${ED}"/usr/lib*/libcddb.la

	use doc && dohtml doc/html/*
}
