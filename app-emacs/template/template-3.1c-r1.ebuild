# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit elisp

DESCRIPTION="Use templates, decorate comments, auto-update buffers"
HOMEPAGE="http://emacs-template.sourceforge.net/"
SRC_URI="mirror://sourceforge/emacs-template/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/${PN}"
SITEFILE="50${PN}-gentoo.el"

src_compile() {
	elisp-compile lisp/*.el
}

src_install() {
	elisp-install ${PN} lisp/*.{el,elc}
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"

	insinto "${SITEETC}/${PN}"
	doins -r templates
	dodoc README lisp/ChangeLog
}
