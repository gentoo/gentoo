# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit elisp-common

DESCRIPTION="Casting SPELs in Lisp - A Comic Book (Emacs Lisp Edition)"
HOMEPAGE="http://www.lisperati.com/casting-spels-emacs/html/casting-spels-emacs-1.html
	https://www.gnu.org/software/emacs/casting-spels-emacs/"
SRC_URI="https://casting-spels-emacs.googlecode.com/files/${PN}-v${PV}.zip"

LICENSE="GPL-2+ FDL-1.2"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND=">=app-editors/emacs-23.1:*"
DEPEND="app-arch/unzip"

S="${WORKDIR}/${PN}"

src_prepare() {
	sed -i 's/\r$//' *.txt html/*.html {lisp,test}/*.el || die
	# needs cl extensions
	eapply "${FILESDIR}/${P}-require-cl.patch"
	eapply_user
}

src_install() {
	elisp-install ${PN} lisp/*.el
	dodoc README.txt test/walk-through-commands.el
	docinto html
	dodoc html/*.html
	docinto html/images
	dodoc images/*.jpg images/*.png
	dosym html/images /usr/share/doc/${PF}/images
	dosym ${SITELISP}/${PN} /usr/share/doc/${PF}/lisp
}
