# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3

inherit elisp-common eutils

DESCRIPTION="Casting SPELs in Lisp - A Comic Book (Emacs Lisp Edition)"
HOMEPAGE="https://code.google.com/p/casting-spels-emacs/"
SRC_URI="https://casting-spels-emacs.googlecode.com/files/${PN}-v${PV}.zip"

LICENSE="GPL-2 FDL-1.2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="virtual/emacs"
DEPEND="app-arch/unzip"

S="${WORKDIR}/${PN}"

src_prepare() {
	edos2unix *.txt html/*.html {lisp,test}/*.el

	# needs cl extensions
	epatch "${FILESDIR}/${P}-require-cl.patch"
}

src_install() {
	elisp-install ${PN} lisp/*.el || die
	dohtml -r html/. images || die
	dosym html/images /usr/share/doc/${PF}/images
	dosym ${SITELISP}/${PN} /usr/share/doc/${PF}/lisp
	dodoc README.txt test/walk-through-commands.el
}
