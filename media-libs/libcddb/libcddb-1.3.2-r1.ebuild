# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libcddb/libcddb-1.3.2-r1.ebuild,v 1.11 2015/02/28 13:59:43 ago Exp $

EAPI=5

AUTOTOOLS_PRUNE_LIBTOOL_FILES=all

inherit autotools-multilib

DESCRIPTION="A library for accessing a CDDB server"
HOMEPAGE="http://libcddb.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="doc static-libs"

RDEPEND=">=virtual/libiconv-0-r1[${MULTILIB_USEDEP}]"
DEPEND="doc? ( app-doc/doxygen )"

RESTRICT="test"

DOCS=( AUTHORS ChangeLog NEWS README THANKS TODO )

MULTILIB_WRAPPED_HEADERS=( /usr/include/cddb/version.h )

src_configure() {
	local myeconfargs=( --without-cdio )
	autotools-multilib_src_configure
}

src_compile() {
	autotools-multilib_src_compile

	if use doc; then
		cd "${S}"/doc
		doxygen doxygen.conf || die
	fi
}

src_install() {
	autotools-multilib_src_install

	use doc && dohtml "${S}"/doc/html/*
}
