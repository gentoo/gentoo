# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Mathematical programming environment"
HOMEPAGE="http://euler.sourceforge.net/"
SRC_URI="mirror://sourceforge/euler/${P}.tgz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc -sparc x86 ~amd64-linux ~x86-linux"

BDEPEND="virtual/pkgconfig"
DEPEND="x11-libs/gtk+:2"
RDEPEND="
	${DEPEND}
	x11-misc/xdg-utils
"

PATCHES=(
	"${FILESDIR}"/configure-gentoo.patch
	"${FILESDIR}"/command-gcc4-gentoo.patch
	"${FILESDIR}"/${PN}-glibc-2.4-gentoo.patch
	"${FILESDIR}"/${PN}-xdg.patch
	"${FILESDIR}"/${PN}-fortify.patch
)

src_prepare() {
	default

	# gentoo specific stuff
	sed -i -e '/COPYING/d' -e '/INSTALL/d' Makefile.am || die
	sed -i \
		-e "s:doc/euler:doc/${PF}:g" \
		Makefile.am docs/Makefile.am \
		docs/*/Makefile.am docs/*/images/Makefile.am src/main.c  \
		|| die "sed for docs failed"

	eautoreconf
}
