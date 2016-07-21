# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1

inherit autotools-utils

DESCRIPTION="Mathematical programming environment"
HOMEPAGE="http://euler.sourceforge.net/"
SRC_URI="mirror://sourceforge/euler/${P}.tgz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc -sparc x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="x11-libs/gtk+:2
	virtual/pkgconfig"

RDEPEND="x11-libs/gtk+:2
	x11-misc/xdg-utils"

PATCHES=(
	"${FILESDIR}"/configure-gentoo.patch
	"${FILESDIR}"/command-gcc4-gentoo.patch
	"${FILESDIR}"/${PN}-glibc-2.4-gentoo.patch
	"${FILESDIR}"/${PN}-xdg.patch
	"${FILESDIR}"/${PN}-fortify.patch
)

src_prepare() {
	# gentoo specific stuff
	sed -i -e '/COPYING/d' -e '/INSTALL/d' Makefile.am || die
	sed -i \
		-e "s:doc/euler:doc/${PF}:g" \
		Makefile.am docs/Makefile.am \
		docs/*/Makefile.am docs/*/images/Makefile.am src/main.c  \
		|| die "sed for docs failed"
	autotools-utils_src_prepare
}
