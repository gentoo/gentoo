# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools-utils

DESCRIPTION="Open BEAGLE, a versatile EC/GA/GP framework"
SRC_URI="mirror://sourceforge/beagle/${P}.tar.gz"
HOMEPAGE="http://beagle.gel.ulaval.ca/"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="~amd64 x86"
IUSE="doc static-libs"

RDEPEND="
	sys-libs/zlib
	!app-misc/beagle
	!dev-libs/libbeagle"
DEPEND="${DEPEND}
	doc? ( app-doc/doxygen )"

PATCHES=( "${FILESDIR}"/${PN}-3.0.3-gcc43.patch "${FILESDIR}"/${PN}-3.0.3-gcc47.patch )

AUTOTOOLS_IN_SOURCE_BUILD=1

src_prepare() {
	autotools-utils_src_prepare
	sed -e "s:@LIBS@:@LIBS@ -lpthread:" \
		-i PACC/Threading/Makefile.in || \
		die "Failed to fix threading libs makefile."
}

src_configure() {
	local myeconfargs=( --enable-optimization )
	autotools-utils_src_configure
}

src_compile() {
	autotools-utils_src_compile

	use doc && autotools-utils_src_compile doc
}

src_install () {
	autotools-utils_src_install

	if use doc; then
		cp -pPR examples "${D}"/usr/share/doc/${PF} || \
			die "Failed to install examples."
		dohtml -r refman/*
	fi
}
