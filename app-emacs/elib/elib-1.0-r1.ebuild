# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit elisp eutils

DESCRIPTION="The Emacs Lisp Library"
HOMEPAGE="http://jdee.sourceforge.net"
SRC_URI="http://jdee.sunsite.dk/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris"

SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	epatch "${FILESDIR}/${P}-texinfo-5.patch"
	sed -i 's:--infodir:--info-dir:g' Makefile || die
}

src_compile() {
	default
}

src_install() {
	dodir "${SITELISP}/elib"
	dodir /usr/share/info
	emake prefix="${ED}/usr" infodir="${ED}/usr/share/info" install
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	dodoc ChangeLog NEWS README TODO
}
