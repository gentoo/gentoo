# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/e3/e3-2.8.ebuild,v 1.6 2014/01/01 16:42:11 ulm Exp $

EAPI=5

DESCRIPTION="Very tiny editor in ASM with emacs, pico, wordstar, and vi keybindings"
HOMEPAGE="http://sites.google.com/site/e3editor/"
SRC_URI="http://sites.google.com/site/e3editor/Home/${P}.tgz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="-* amd64 x86"
RESTRICT="strip"

DEPEND=">=dev-lang/nasm-2.09.04"
RDEPEND=""

src_prepare() {
	sed -i 's/-D$(EXMODE)//' Makefile || die
}

src_compile() {
	emake -- $(usex amd64 64 32)
}

src_install() {
	dobin e3
	dosym e3 /usr/bin/e3em
	dosym e3 /usr/bin/e3ne
	dosym e3 /usr/bin/e3pi
	dosym e3 /usr/bin/e3vi
	dosym e3 /usr/bin/e3ws

	newman e3.man e3.1
	dohtml e3.html
	dodoc ChangeLog README README_OLD
}
