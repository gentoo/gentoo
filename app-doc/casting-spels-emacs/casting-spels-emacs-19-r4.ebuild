# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edos2unix elisp-common

DESCRIPTION="Casting SPELs in Lisp - A Comic Book (Emacs Lisp Edition)"
HOMEPAGE="https://www.lisperati.com/casting-spels-emacs/html/casting-spels-emacs-1.html
	https://www.gnu.org/software/emacs/casting-spels-emacs/"
SRC_URI="https://web.archive.org/web/20151231165906/https://casting-spels-emacs.googlecode.com/files/${PN}-v${PV}.zip"
S="${WORKDIR}/${PN}"

LICENSE="GPL-2+ FDL-1.2"
SLOT="0"
KEYWORDS="amd64 ~riscv x86"

RDEPEND=">=app-editors/emacs-23.1:*"
BDEPEND="app-arch/unzip"

PATCHES="${FILESDIR}/${P}-require-cl.patch"

src_prepare() {
	edos2unix *.txt html/*.html {lisp,test}/*.el
	default
}

src_install() {
	elisp-install ${PN} lisp/*.el
	dodoc README.txt test/walk-through-commands.el
	docinto html
	dodoc html/*.html
	docinto html/images
	dodoc images/*.jpg images/*.png
	dosym html/images /usr/share/doc/${PF}/images
	dosym -r ${SITELISP}/${PN} /usr/share/doc/${PF}/lisp
}
