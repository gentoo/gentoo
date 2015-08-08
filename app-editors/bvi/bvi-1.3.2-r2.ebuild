# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

AUTOTOOLS_AUTORECONF="1"
AUTOTOOLS_IN_SOURCE_BUILD="1"

inherit multilib eutils autotools-utils

DESCRIPTION="display-oriented editor for binary files, based on the vi texteditor"
HOMEPAGE="http://bvi.sourceforge.net/"
SRC_URI="mirror://sourceforge/bvi/${P}.src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="amd64 ppc x86 ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~sparc64-solaris ~x86-solaris"

DEPEND="sys-libs/ncurses"
RDEPEND="${DEPEND}"

src_prepare() {
	local PATCHES=(
		"${FILESDIR}/${P}-fix-buffer-overflow.patch"
		"${FILESDIR}/${P}-tinfo.patch"
		)
	sed -i -e 's:ncurses/term.h:term.h:g' bmore.h || die "sed failed in bmore.h"
	sed -i -e 's:(INSTALL_PROGRAM) -s:(INSTALL_PROGRAM):g' \
		Makefile.in || die "sed failed in Makefile.in"

	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(--with-ncurses="${EPREFIX}"/usr)
	autotools-utils_src_configure

}

src_install() {
	autotools-utils_src_install
	rm -rf "${ED}"/usr/$(get_libdir)/bmore.help
	dodoc README CHANGES CREDITS bmore.help
	dohtml -r html/*
}
