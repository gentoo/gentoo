# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools common-lisp-3 git-2

DESCRIPTION="Stumpwm is a Window Manager written entirely in Common Lisp."
HOMEPAGE="http://www.nongnu.org/stumpwm/index.html"
EGIT_REPO_URI="git://github.com/stumpwm/stumpwm"

LICENSE="GPL-2"
SLOT="0"
IUSE="doc clisp emacs +sbcl"

DEPEND="dev-lisp/common-lisp-controller
	virtual/commonlisp
	dev-lisp/cl-ppcre
	doc? ( virtual/texi2dvi )"

RDEPEND="${DEPEND}
	emacs? ( app-emacs/slime )
	!clisp? ( !sbcl? ( !amd64? ( dev-lisp/cmucl ) ) )
	clisp? ( >=dev-lisp/clisp-2.38-r2[X,-new-clx] )
	sbcl?  ( >=dev-lisp/sbcl-1.1.15 dev-lisp/clx )"

do_doc() {
	local pdffile="${PN}.pdf"

	dodoc AUTHORS NEWS README.md
	texi2pdf -o "${pdffile}" "${PN}.texi.in" && dodoc "${pdffile}" || die
}

src_prepare() {
	# Fix ASDF dir
	sed -i -e "/^STUMPWM_ASDF_DIR/s|\`pwd\`|${CLPKGDIR}|" configure.ac || die
	eautoreconf
}

src_compile() {
	emake -j1
}

src_install() {
	common-lisp-install-sources *.lisp
	common-lisp-install-asdf
	dobin "${PN}"
	use doc && do_doc
}
