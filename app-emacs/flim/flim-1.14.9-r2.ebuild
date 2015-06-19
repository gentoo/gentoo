# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/flim/flim-1.14.9-r2.ebuild,v 1.7 2014/04/21 13:21:01 ulm Exp $

EAPI=5

inherit elisp

DESCRIPTION="A library to provide basic features about message representation or encoding"
HOMEPAGE="http://git.chise.org/elisp/flim/"
SRC_URI="http://git.chise.org/elisp/dist/${PN}/${P%.*}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="alpha amd64 ppc sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris"

DEPEND=">=app-emacs/apel-10.3"
RDEPEND="${DEPEND}
	!app-emacs/limit"

ELISP_PATCHES="${P}-mel-q-ccl.patch"
SITEFILE="60${PN}-gentoo.el"

src_compile() {
	emake PREFIX="${ED}/usr" \
		LISPDIR="${ED}/${SITELISP}" \
		VERSION_SPECIFIC_LISPDIR="${ED}/${SITELISP}"
}

src_install() {
	emake PREFIX="${ED}/usr" \
		LISPDIR="${ED}/${SITELISP}" \
		VERSION_SPECIFIC_LISPDIR="${ED}/${SITELISP}" install

	elisp-site-file-install "${FILESDIR}/${SITEFILE}"

	dodoc FLIM-API.en NEWS VERSION README* ChangeLog
}
